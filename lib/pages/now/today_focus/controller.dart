import 'dart:async';

import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Controls the v2 full-screen single-task focus page.
class TodayFocusController extends GetxController {
  bool isLoading = true;
  bool isRunning = false;
  TaskInstanceModel? task;
  DateTime? startedAt;
  Duration elapsed = Duration.zero;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadCurrentTask();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Loads the current recommendation from the existing local engine.
  Future<void> loadCurrentTask({String? skipInstanceId}) async {
    isLoading = true;
    update();
    final NowSnapshotModel snapshot = await Get.find<NowService>()
        .buildSnapshot(skipInstanceId: skipInstanceId);
    task = snapshot.recommendedTask;
    isLoading = false;
    update();
  }

  /// Starts the local focus session for the current task.
  Future<void> startFocus() async {
    final TaskInstanceModel? current = task;
    if (current == null || isRunning) {
      return;
    }

    await Get.find<NowService>().startFocus(current.id);
    startedAt = DateTime.now();
    elapsed = Duration.zero;
    isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final DateTime? start = startedAt;
      if (start == null) {
        return;
      }
      elapsed = DateTime.now().difference(start);
      update();
    });
    update();
  }

  /// Replaces the current recommendation with the next candidate.
  Future<void> switchTask() async {
    final TaskInstanceModel? current = task;
    if (current == null || isRunning) {
      return;
    }
    await loadCurrentTask(skipInstanceId: current.id);
  }

  /// Marks the task completed and returns the home feedback message.
  Future<String> completeTask() async {
    final TaskInstanceModel? current = task;
    if (current == null) {
      return '';
    }
    await Get.find<NowService>().completeTask(current.id);
    return '已记录完成，计划进度已更新。';
  }

  /// Moves the task later and returns the home feedback message.
  Future<String> postponeTask() async {
    final TaskInstanceModel? current = task;
    if (current == null) {
      return '';
    }
    await Get.find<NowService>().postponeTask(current.id);
    return '已帮你稍后处理，今天的计划会重新排序。';
  }

  /// Drops the task and returns the home feedback message.
  Future<String> dropTask() async {
    final TaskInstanceModel? current = task;
    if (current == null) {
      return '';
    }
    await Get.find<NowService>().dropTask(current.id);
    return '已放弃这件事，我会重新挑下一件值得做的任务。';
  }

  /// Formats the current focus duration for the running state.
  String get elapsedLabel {
    final int minutes = elapsed.inMinutes;
    final int seconds = elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
