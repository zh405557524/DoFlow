import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Handles local persistence and tree queries for notes.
class NotesService extends GetxService {
  final Uuid _uuid = const Uuid();

  Box<dynamic> get _foldersBox => Hive.box<dynamic>(AppHiveBoxes.noteFolders);
  Box<dynamic> get _filesBox => Hive.box<dynamic>(AppHiveBoxes.noteFiles);

  /// Loads or seeds the local notes structure.
  Future<void> bootstrap() async {
    if (_foldersBox.isEmpty && _filesBox.isEmpty) {
      await _seedInitialNotes();
    }
    await _reload();
  }

  /// Returns folders under a specific parent.
  List<NoteFolderModel> getFoldersByParent(String? parentId) {
    return NotesStore.to.folders
        .where((NoteFolderModel folder) => folder.parentId == parentId)
        .toList();
  }

  /// Returns files under a specific folder or root when null.
  List<NoteFileModel> getFilesByFolder(String? folderId) {
    return NotesStore.to.files
        .where((NoteFileModel file) => file.folderId == folderId)
        .toList();
  }

  /// Returns a folder by identifier.
  NoteFolderModel? getFolderById(String folderId) {
    return NotesStore.to.getFolderById(folderId);
  }

  /// Returns a file by identifier.
  NoteFileModel? getFileById(String fileId) {
    return NotesStore.to.getFileById(fileId);
  }

  /// Returns the visible item count inside a folder.
  int getFolderItemCount(String folderId) {
    return getFoldersByParent(folderId).length + getFilesByFolder(folderId).length;
  }

  /// Builds the folder trail from root to the current folder.
  List<NoteFolderModel> buildFolderTrail(String folderId) {
    final List<NoteFolderModel> trail = <NoteFolderModel>[];
    NoteFolderModel? current = getFolderById(folderId);

    while (current != null) {
      trail.insert(0, current);
      current = current.parentId == null
          ? null
          : getFolderById(current.parentId!);
    }

    return trail;
  }

  /// Creates a folder in root or under the given parent.
  Future<NoteFolderModel> createFolder({
    required String name,
    String? parentId,
  }) async {
    final DateTime now = DateTime.now();
    final NoteFolderModel folder = NoteFolderModel(
      id: _uuid.v4(),
      name: name.trim(),
      parentId: parentId,
      createdAt: now,
      updatedAt: now,
    );

    await _foldersBox.put(folder.id, folder.toMap());
    await _reload();
    await Get.find<SyncService>().recordPending(
      entityType: 'note_folder',
      entityId: folder.id,
      message: 'Note folder saved locally.',
    );
    return folder;
  }

  /// Creates a note file and returns the local snapshot.
  Future<NoteFileModel> createFile({
    required String title,
    String? folderId,
    String? format,
    String? content,
  }) async {
    final DateTime now = DateTime.now();
    final String normalizedTitle = _normalizeTitle(title.trim());
    final String resolvedFormat =
        format ?? (normalizedTitle.endsWith('.md')
            ? NoteFileFormats.markdown
            : NoteFileFormats.document);

    final NoteFileModel file = NoteFileModel(
      id: _uuid.v4(),
      title: normalizedTitle,
      folderId: folderId,
      format: resolvedFormat,
      content: content ?? _defaultContentFor(normalizedTitle, resolvedFormat),
      createdAt: now,
      updatedAt: now,
    );

    await _filesBox.put(file.id, file.toMap());
    await _reload();
    await Get.find<SyncService>().recordPending(
      entityType: 'note_file',
      entityId: file.id,
      message: 'Note file saved locally.',
    );
    return file;
  }

  /// Persists file updates and refreshes the in-memory store.
  Future<void> saveFile(NoteFileModel file) async {
    final NoteFileModel updated = file.copyWith(updatedAt: DateTime.now());
    await _filesBox.put(updated.id, updated.toMap());
    await _reload();
    await Get.find<SyncService>().recordPending(
      entityType: 'note_file',
      entityId: updated.id,
      message: 'Note file updated locally.',
    );
  }

  Future<void> _reload() async {
    NotesStore.to.setFolders(
      _foldersBox.values
          .map(
            (dynamic item) =>
                NoteFolderModel.fromMap(item as Map<dynamic, dynamic>),
          )
          .toList(),
    );
    NotesStore.to.setFiles(
      _filesBox.values
          .map(
            (dynamic item) =>
                NoteFileModel.fromMap(item as Map<dynamic, dynamic>),
          )
          .toList(),
    );
  }

  Future<void> _seedInitialNotes() async {
    final DateTime now = DateTime.now();
    final NoteFolderModel productFolder = NoteFolderModel(
      id: _uuid.v4(),
      name: '产品规划',
      createdAt: now,
      updatedAt: now,
    );
    final NoteFolderModel androidFolder = NoteFolderModel(
      id: _uuid.v4(),
      name: 'Android面试',
      createdAt: now.add(const Duration(minutes: 1)),
      updatedAt: now.add(const Duration(minutes: 1)),
    );
    final NoteFolderModel jvmFolder = NoteFolderModel(
      id: _uuid.v4(),
      name: 'JVM',
      parentId: androidFolder.id,
      createdAt: now.add(const Duration(minutes: 2)),
      updatedAt: now.add(const Duration(minutes: 2)),
    );
    final NoteFileModel binderFile = NoteFileModel(
      id: _uuid.v4(),
      title: 'Binder.md',
      folderId: androidFolder.id,
      format: NoteFileFormats.markdown,
      content: _defaultBinderContent,
      createdAt: now.add(const Duration(minutes: 3)),
      updatedAt: now.add(const Duration(minutes: 3)),
    );
    final NoteFileModel handlerFile = NoteFileModel(
      id: _uuid.v4(),
      title: 'Handler.md',
      folderId: androidFolder.id,
      format: NoteFileFormats.markdown,
      content: '# Handler\n\n- 消息循环\n- Looper\n- MessageQueue',
      createdAt: now.add(const Duration(minutes: 4)),
      updatedAt: now.add(const Duration(minutes: 4)),
    );

    await _foldersBox.put(productFolder.id, productFolder.toMap());
    await _foldersBox.put(androidFolder.id, androidFolder.toMap());
    await _foldersBox.put(jvmFolder.id, jvmFolder.toMap());
    await _filesBox.put(binderFile.id, binderFile.toMap());
    await _filesBox.put(handlerFile.id, handlerFile.toMap());
  }

  String _normalizeTitle(String title) {
    if (title.isEmpty) {
      return '新笔记.md';
    }
    if (title.contains('.')) {
      return title;
    }
    return '$title.md';
  }

  String _defaultContentFor(String title, String format) {
    if (title == 'Binder.md') {
      return _defaultBinderContent;
    }
    if (format == NoteFileFormats.markdown) {
      final String baseTitle = title.replaceAll('.md', '');
      return '# $baseTitle\n\n开始记录你的新笔记。';
    }
    return '开始记录你的新文档。';
  }

  static const String _defaultBinderContent =
      '# Binder 机制\n\n'
      '## 什么是 Binder\n\n'
      'Binder 是 Android 系统中的一种进程间通信（IPC）机制。\n\n'
      '## 核心概念\n\n'
      '- **Client**：服务的请求方\n'
      '- **Server**：服务的提供方\n'
      '- **ServiceManager**：服务管理器\n'
      '- **Binder Driver**：内核驱动\n\n'
      '## 为什么使用 Binder\n\n'
      '1. **性能高**：只需要一次数据拷贝（vs 传统 IPC 需要两次）\n'
      '2. **安全性**：传递进程的 UID/PID，便于权限校验\n'
      '3. **易用性**：面向对象的调用方式';
}
