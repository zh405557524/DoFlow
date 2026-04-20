import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';

/// Builds the Now page state and applies local execution feedback.
class NowService extends GetxService {
  /// Builds the current recommendation snapshot from local task instances.
  Future<NowSnapshotModel> buildSnapshot({
    String? skipInstanceId,
    String? preferredInstanceId,
  }) async {
    final DateTime now = DateTime.now();
    final List<TaskInstanceModel> allInstances =
        await Get.find<TaskInstanceService>().fetchAllInstances();
    final List<TaskInstanceModel> actionable =
        allInstances
            .where(
              (TaskInstanceModel item) =>
                  item.status == TaskInstanceStatus.inProgress ||
                  item.status == TaskInstanceStatus.pending ||
                  item.status == TaskInstanceStatus.postponed,
            )
            .toList()
          ..sort(_compareInstances);

    if (preferredInstanceId != null) {
      actionable.sort((TaskInstanceModel a, TaskInstanceModel b) {
        if (a.id == preferredInstanceId) {
          return -1;
        }
        if (b.id == preferredInstanceId) {
          return 1;
        }
        return _compareInstances(a, b);
      });
    }

    if (skipInstanceId != null) {
      actionable.removeWhere(
        (TaskInstanceModel item) => item.id == skipInstanceId,
      );
    }

    final TaskInstanceModel? recommended = actionable.isEmpty
        ? null
        : actionable.first;
    final List<TaskInstanceModel> backups = actionable
        .skip(recommended == null ? 0 : 1)
        .take(3)
        .toList();

    if (recommended == null) {
      return NowSnapshotModel(
        greeting: buildGreeting(now),
        statusLabel: 'No active plan',
        suggestionText:
            'Create a plan or apply a draft to generate your next task.',
        recommendedTask: null,
        backupTasks: backups,
      );
    }

    final String statusLabel =
        recommended.status == TaskInstanceStatus.inProgress
        ? 'In focus'
        : 'Ready to start';

    return NowSnapshotModel(
      greeting: buildGreeting(now),
      statusLabel: statusLabel,
      suggestionText:
          'A small next step in "${recommended.planTitle}" will create the most momentum right now.',
      recommendedTask: recommended,
      backupTasks: backups,
    );
  }

  /// Marks a task as actively focused.
  Future<void> startFocus(String instanceId) async {
    await _updateInstance(
      instanceId: instanceId,
      status: TaskInstanceStatus.inProgress,
      resolution: '',
      message: 'Focus started locally.',
    );
  }

  /// Marks a task as completed and records the local change.
  Future<void> completeTask(String instanceId) async {
    await _updateInstance(
      instanceId: instanceId,
      status: TaskInstanceStatus.completed,
      resolution: 'completed',
      message: 'Task completed locally.',
    );
  }

  /// Moves a task out by one day without deleting the plan.
  Future<void> postponeTask(String instanceId) async {
    final TaskInstanceModel? instance = await Get.find<TaskInstanceService>()
        .findById(instanceId);
    if (instance == null) {
      return;
    }

    await _saveUpdatedInstance(
      instance.copyWith(
        status: TaskInstanceStatus.postponed,
        resolution: 'postponed',
        scheduledAt: instance.scheduledAt.add(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      message: 'Task postponed locally.',
    );
  }

  /// Drops a task from the current candidate pool.
  Future<void> dropTask(String instanceId) async {
    await _updateInstance(
      instanceId: instanceId,
      status: TaskInstanceStatus.dropped,
      resolution: 'dropped',
      message: 'Task dropped locally.',
    );
  }

  /// Refreshes the reactive plan store after local task updates.
  Future<void> refreshPlanStore() async {
    await Get.find<PlanService>().bootstrap();
  }

  /// Applies a new status to a single task instance.
  Future<void> _updateInstance({
    required String instanceId,
    required String status,
    required String resolution,
    required String message,
  }) async {
    final TaskInstanceModel? instance = await Get.find<TaskInstanceService>()
        .findById(instanceId);
    if (instance == null) {
      return;
    }

    await _saveUpdatedInstance(
      instance.copyWith(
        status: status,
        resolution: resolution,
        updatedAt: DateTime.now(),
      ),
      message: message,
    );
  }

  /// Persists the changed instance and writes a sync record.
  Future<void> _saveUpdatedInstance(
    TaskInstanceModel instance, {
    required String message,
  }) async {
    await Get.find<TaskInstanceService>().saveInstance(instance);
    await refreshPlanStore();
    await Get.find<SyncService>().recordPending(
      entityType: 'task_instance',
      entityId: instance.id,
      message: message,
    );

    // Reading the store keeps the Now page in sync with the latest status badges.
    SyncStore.to.hasPendingFor(instance.id);
  }

  /// Sorts instances so active work appears before later candidates.
  int _compareInstances(TaskInstanceModel a, TaskInstanceModel b) {
    final int aRank = _statusRank(a.status);
    final int bRank = _statusRank(b.status);
    if (aRank != bRank) {
      return aRank.compareTo(bRank);
    }

    final int timeOrder = a.scheduledAt.compareTo(b.scheduledAt);
    if (timeOrder != 0) {
      return timeOrder;
    }
    return a.priority.compareTo(b.priority);
  }

  /// Converts a string status into a stable sort weight.
  int _statusRank(String status) {
    switch (status) {
      case TaskInstanceStatus.inProgress:
        return 0;
      case TaskInstanceStatus.pending:
        return 1;
      case TaskInstanceStatus.postponed:
        return 2;
      default:
        return 99;
    }
  }
}
