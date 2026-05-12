import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Loads a nested folder and its local children.
class NoteFolderController extends GetxController {
  NoteFolderController({required this.folderId});

  final String folderId;

  bool isLoading = true;
  NoteFolderModel? folder;
  List<NoteFolderModel> childFolders = const <NoteFolderModel>[];
  List<NoteFileModel> childFiles = const <NoteFileModel>[];
  List<NoteFolderModel> trail = const <NoteFolderModel>[];

  NotesService get _service => Get.find<NotesService>();

  @override
  void onInit() {
    super.onInit();
    loadFolder();
  }

  /// Reloads the current folder and all direct children.
  Future<void> loadFolder() async {
    isLoading = true;
    update();
    folder = _service.getFolderById(folderId);
    childFolders = _service.getFoldersByParent(folderId);
    childFiles = _service.getFilesByFolder(folderId);
    trail = folder == null ? const <NoteFolderModel>[] : _service.buildFolderTrail(folderId);
    isLoading = false;
    update();
  }

  /// Creates a child folder under the current folder.
  Future<NoteFolderModel?> createFolder(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final NoteFolderModel item = await _service.createFolder(
      name: trimmed,
      parentId: folderId,
    );
    await loadFolder();
    return item;
  }

  /// Creates a file under the current folder.
  Future<NoteFileModel?> createFile(String title) async {
    final String trimmed = title.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final NoteFileModel file = await _service.createFile(
      title: trimmed,
      folderId: folderId,
    );
    await loadFolder();
    return file;
  }

  /// Returns the visible item count inside a child folder.
  int itemCountFor(NoteFolderModel item) {
    return _service.getFolderItemCount(item.id);
  }

  String get breadcrumbLabel {
    if (trail.isEmpty) {
      return 'Notes';
    }
    return 'Notes / ${trail.map((NoteFolderModel item) => item.name).join(' / ')}';
  }
}
