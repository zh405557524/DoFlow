import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Loads the root notes directory and creation actions.
class NotesController extends GetxController {
  bool isLoading = true;
  List<NoteFolderModel> rootFolders = const <NoteFolderModel>[];
  List<NoteFileModel> rootFiles = const <NoteFileModel>[];

  NotesService get _service => Get.find<NotesService>();

  @override
  void onInit() {
    super.onInit();
    loadRoot();
  }

  /// Reloads the root directory from the local notes service.
  Future<void> loadRoot() async {
    isLoading = true;
    update();
    rootFolders = _service.getFoldersByParent(null);
    rootFiles = _service.getFilesByFolder(null);
    isLoading = false;
    update();
  }

  /// Creates a root folder and refreshes the view state.
  Future<NoteFolderModel?> createFolder(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final NoteFolderModel folder = await _service.createFolder(name: trimmed);
    await loadRoot();
    return folder;
  }

  /// Creates a root file and refreshes the view state.
  Future<NoteFileModel?> createFile(String title) async {
    final String trimmed = title.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final NoteFileModel file = await _service.createFile(title: trimmed);
    await loadRoot();
    return file;
  }

  /// Returns the current visible item count under a folder.
  int itemCountFor(NoteFolderModel folder) {
    return _service.getFolderItemCount(folder.id);
  }
}
