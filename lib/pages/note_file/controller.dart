import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// Owns the note file editing and preview state.
class NoteFileController extends GetxController {
  NoteFileController({required this.fileId});

  final String fileId;
  final TextEditingController contentController = TextEditingController();

  bool isLoading = true;
  bool isPreview = false;
  NoteFileModel? file;
  String pathLabel = 'Notes';

  NotesService get _notesService => Get.find<NotesService>();
  StorageService get _storage => Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    loadFile();
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

  /// Loads the target file and its persisted mode preference.
  Future<void> loadFile() async {
    isLoading = true;
    update();

    file = _notesService.getFileById(fileId);
    if (file != null) {
      contentController.text = file!.content;
      final List<NoteFolderModel> trail = file!.folderId == null
          ? const <NoteFolderModel>[]
          : _notesService.buildFolderTrail(file!.folderId!);
      final String prefix = trail.isEmpty
          ? 'Notes'
          : 'Notes / ${trail.map((NoteFolderModel item) => item.name).join(' / ')}';
      pathLabel = '$prefix / ${file!.title}';
      final String? storedMode = _storage.read<String>('note_mode_$fileId');
      isPreview = storedMode == null
          ? file!.isMarkdown
          : storedMode == 'preview';
    }

    isLoading = false;
    update();
  }

  /// Toggles between edit and preview mode and persists the preference.
  Future<void> setPreviewMode(bool nextValue) async {
    if (isPreview == nextValue) {
      return;
    }
    if (nextValue) {
      await saveChanges();
    }
    isPreview = nextValue;
    await _storage.write(
      'note_mode_$fileId',
      isPreview ? 'preview' : 'edit',
    );
    update();
  }

  /// Saves the current content back into local Hive storage.
  Future<void> saveChanges() async {
    final NoteFileModel? current = file;
    if (current == null) {
      return;
    }

    final String nextContent = contentController.text;
    if (nextContent == current.content) {
      return;
    }

    final NoteFileModel updated = current.copyWith(content: nextContent);
    await _notesService.saveFile(updated);
    file = _notesService.getFileById(fileId) ?? updated;
    update();
  }
}
