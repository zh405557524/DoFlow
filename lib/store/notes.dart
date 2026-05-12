import 'package:doflow/models/index.dart';
import 'package:get/get.dart';

/// Stores folders and files for the local notes feature.
class NotesStore extends GetxService {
  static NotesStore get to => Get.find<NotesStore>();

  final RxList<NoteFolderModel> folders = <NoteFolderModel>[].obs;
  final RxList<NoteFileModel> files = <NoteFileModel>[].obs;

  /// Replaces the in-memory folder list.
  void setFolders(List<NoteFolderModel> items) {
    folders.assignAll(items);
  }

  /// Replaces the in-memory file list.
  void setFiles(List<NoteFileModel> items) {
    files.assignAll(items);
  }

  /// Returns a folder by identifier when available in memory.
  NoteFolderModel? getFolderById(String folderId) {
    try {
      return folders.firstWhere((NoteFolderModel item) => item.id == folderId);
    } catch (_) {
      return null;
    }
  }

  /// Returns a file by identifier when available in memory.
  NoteFileModel? getFileById(String fileId) {
    try {
      return files.firstWhere((NoteFileModel item) => item.id == fileId);
    } catch (_) {
      return null;
    }
  }
}
