import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Builds and updates runnable task instances derived from plans.
class TaskInstanceService extends GetxService {
  final Uuid _uuid = const Uuid();

  Box<dynamic> get _box => Hive.box<dynamic>(AppHiveBoxes.taskInstances);

  /// Rebuilds every task instance that belongs to a single plan.
  Future<void> rebuildForPlan(String planId) async {
    final PlanModel? plan = await Get.find<PlanService>().getPlanById(planId);
    if (plan == null) {
      return;
    }

    final List<dynamic> staleKeys = _box.keys.where((dynamic key) {
      final dynamic value = _box.get(key);
      return value is Map && value['planId'] == planId;
    }).toList();
    await _box.deleteAll(staleKeys);

    int priority = 0;
    for (final PlanPhaseModel phase in plan.phases) {
      for (final PlanTaskModel task in phase.tasks) {
        final DateTime scheduledAt = phase.startAt.add(
          Duration(days: task.sortOrder),
        );
        final TaskInstanceModel instance = TaskInstanceModel(
          id: _uuid.v4(),
          planId: plan.id,
          planTitle: plan.title,
          phaseId: phase.id,
          phaseTitle: phase.title,
          taskId: task.id,
          taskTitle: task.title,
          taskNote: task.note,
          scheduledAt: scheduledAt,
          status: TaskInstanceStatus.pending,
          resolution: '',
          updatedAt: DateTime.now(),
          priority: priority,
        );
        await _box.put(instance.id, instance.toMap());
        priority += 1;
      }
    }
  }

  /// Reads every locally stored task instance.
  Future<List<TaskInstanceModel>> fetchAllInstances() async {
    final List<TaskInstanceModel> instances =
        _box.values
            .map(
              (dynamic item) =>
                  TaskInstanceModel.fromMap(item as Map<dynamic, dynamic>),
            )
            .toList()
          ..sort(
            (TaskInstanceModel a, TaskInstanceModel b) =>
                a.priority.compareTo(b.priority),
          );
    return instances;
  }

  /// Returns all task instances for a single plan.
  Future<List<TaskInstanceModel>> fetchInstancesForPlan(String planId) async {
    final List<TaskInstanceModel> instances = await fetchAllInstances();
    return instances
        .where((TaskInstanceModel instance) => instance.planId == planId)
        .toList();
  }

  /// Finds a single task instance for a local action.
  Future<TaskInstanceModel?> findById(String instanceId) async {
    final dynamic value = _box.get(instanceId);
    if (value == null) {
      return null;
    }
    return TaskInstanceModel.fromMap(value as Map<dynamic, dynamic>);
  }

  /// Writes an updated task instance back into Hive.
  Future<void> saveInstance(TaskInstanceModel instance) async {
    await _box.put(instance.id, instance.toMap());
  }
}
