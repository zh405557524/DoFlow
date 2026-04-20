import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:get/get.dart';

/// Owns the Now page state and local execution actions.
class NowController extends GetxController {
  bool isLoading = true;
  String currentGreeting = '';
  String currentStatusLabel = '';
  String suggestionText = '';
  TaskInstanceModel? recommendedTask;
  List<TaskInstanceModel> backupTasks = const <TaskInstanceModel>[];

  @override
  void onInit() {
    super.onInit();
    loadNowData();
  }

  /// Loads the current recommendation snapshot from the local engine.
  Future<void> loadNowData() async {
    isLoading = true;
    update();
    final NowSnapshotModel snapshot = await Get.find<NowService>()
        .buildSnapshot();
    _applySnapshot(snapshot);
  }

  /// Switches to the next available candidate.
  Future<void> switchCandidate() async {
    if (recommendedTask == null) {
      return;
    }

    final NowSnapshotModel snapshot = await Get.find<NowService>()
        .buildSnapshot(skipInstanceId: recommendedTask!.id);
    _applySnapshot(snapshot);
  }

  /// Promotes one backup task to be the main recommendation.
  Future<void> pickBackupTask(String instanceId) async {
    final NowSnapshotModel snapshot = await Get.find<NowService>()
        .buildSnapshot(preferredInstanceId: instanceId);
    _applySnapshot(snapshot);
  }

  /// Starts focus for the currently recommended task.
  Future<void> startFocus() async {
    if (recommendedTask == null) {
      AppToast.text('No task is ready yet.');
      return;
    }
    await Get.find<NowService>().startFocus(recommendedTask!.id);
    await loadNowData();
  }

  /// Marks the current recommendation as done.
  Future<void> completeTask() async {
    if (recommendedTask == null) {
      return;
    }
    await Get.find<NowService>().completeTask(recommendedTask!.id);
    await loadNowData();
  }

  /// Moves the current recommendation out by one day.
  Future<void> postponeTask() async {
    if (recommendedTask == null) {
      return;
    }
    await Get.find<NowService>().postponeTask(recommendedTask!.id);
    await loadNowData();
  }

  /// Drops the current recommendation from the active queue.
  Future<void> dropTask() async {
    if (recommendedTask == null) {
      return;
    }
    await Get.find<NowService>().dropTask(recommendedTask!.id);
    await loadNowData();
  }

  /// Applies a loaded snapshot to local controller fields.
  void _applySnapshot(NowSnapshotModel snapshot) {
    currentGreeting = snapshot.greeting;
    currentStatusLabel = snapshot.statusLabel;
    suggestionText = snapshot.suggestionText;
    recommendedTask = snapshot.recommendedTask;
    backupTasks = snapshot.backupTasks;
    isLoading = false;
    update();
  }
}
