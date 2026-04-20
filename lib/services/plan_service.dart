import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Handles local persistence and aggregation of plans, phases, and tasks.
class PlanService extends GetxService {
  final Uuid _uuid = const Uuid();

  Box<dynamic> get _plansBox => Hive.box<dynamic>(AppHiveBoxes.plans);
  Box<dynamic> get _phasesBox => Hive.box<dynamic>(AppHiveBoxes.planPhases);
  Box<dynamic> get _tasksBox => Hive.box<dynamic>(AppHiveBoxes.planTasks);

  /// Loads all plans from local boxes into the reactive store.
  Future<void> bootstrap() async {
    final List<PlanModel> plans = await fetchPlans();
    PlanStore.to.setPlans(plans);
  }

  /// Reads and aggregates all locally stored plans.
  Future<List<PlanModel>> fetchPlans() async {
    final List<PlanModel> plans =
        _plansBox.values
            .map((dynamic item) => _hydratePlan(item as Map<dynamic, dynamic>))
            .toList()
          ..sort(
            (PlanModel a, PlanModel b) => b.updatedAt.compareTo(a.updatedAt),
          );
    return plans;
  }

  /// Returns a single aggregated plan by identifier.
  Future<PlanModel?> getPlanById(String planId) async {
    final dynamic overview = _plansBox.get(planId);
    if (overview == null) {
      return null;
    }
    return _hydratePlan(overview as Map<dynamic, dynamic>);
  }

  /// Creates a blank plan shell that the editor can start from.
  PlanModel createEmptyPlan() {
    final DateTime now = DateTime.now();
    final DateTime end = now.add(const Duration(days: 14));

    return PlanModel(
      id: _uuid.v4(),
      title: '',
      planType: PlanTypes.all.first,
      summary: '',
      startAt: now,
      endAt: end,
      colorHex: AppPlanColors.all.first,
      createdAt: now,
      updatedAt: now,
      phases: <PlanPhaseModel>[
        PlanPhaseModel(
          id: _uuid.v4(),
          title: 'Phase 1',
          goal: '',
          startAt: now,
          endAt: end,
          sortOrder: 0,
          tasks: const <PlanTaskModel>[],
        ),
      ],
    );
  }

  /// Saves a full aggregated plan into overview, phase, and task boxes.
  Future<void> savePlan(PlanModel plan) async {
    final DateTime now = DateTime.now();
    final PlanModel normalizedPlan = plan.copyWith(
      summary: plan.summary.isEmpty ? _buildSummary(plan) : plan.summary,
      updatedAt: now,
      colorHex: plan.colorHex.isEmpty ? AppPlanColors.all.first : plan.colorHex,
    );

    await _plansBox.put(normalizedPlan.id, normalizedPlan.toOverviewMap());

    final List<dynamic> phaseKeysToDelete = _phasesBox.keys.where((
      dynamic key,
    ) {
      final dynamic value = _phasesBox.get(key);
      return value is Map && value['planId'] == normalizedPlan.id;
    }).toList();
    await _phasesBox.deleteAll(phaseKeysToDelete);

    final List<dynamic> taskKeysToDelete = _tasksBox.keys.where((dynamic key) {
      final dynamic value = _tasksBox.get(key);
      return value is Map && value['planId'] == normalizedPlan.id;
    }).toList();
    await _tasksBox.deleteAll(taskKeysToDelete);

    for (final PlanPhaseModel phase in normalizedPlan.phases) {
      await _phasesBox.put(phase.id, phase.toMap(planId: normalizedPlan.id));

      for (final PlanTaskModel task in phase.tasks) {
        await _tasksBox.put(
          task.id,
          task.toMap(planId: normalizedPlan.id, phaseId: phase.id),
        );
      }
    }

    await bootstrap();
    await Get.find<TaskInstanceService>().rebuildForPlan(normalizedPlan.id);
    await Get.find<SyncService>().recordPending(
      entityType: 'plan',
      entityId: normalizedPlan.id,
      message: 'Plan saved locally.',
    );
  }

  /// Hydrates a full plan using the overview map as the aggregation root.
  PlanModel _hydratePlan(Map<dynamic, dynamic> overview) {
    final String planId = overview['id'] as String;

    final List<PlanPhaseModel> phases =
        _phasesBox.values
            .where(
              (dynamic item) =>
                  item is Map<dynamic, dynamic> && item['planId'] == planId,
            )
            .map((dynamic item) {
              final Map<dynamic, dynamic> phaseMap =
                  item as Map<dynamic, dynamic>;
              final String phaseId = phaseMap['id'] as String;
              final List<PlanTaskModel> tasks =
                  _tasksBox.values
                      .where(
                        (dynamic taskItem) =>
                            taskItem is Map<dynamic, dynamic> &&
                            taskItem['planId'] == planId &&
                            taskItem['phaseId'] == phaseId,
                      )
                      .map(
                        (dynamic taskItem) => PlanTaskModel.fromMap(
                          taskItem as Map<dynamic, dynamic>,
                        ),
                      )
                      .toList()
                    ..sort(
                      (PlanTaskModel a, PlanTaskModel b) =>
                          a.sortOrder.compareTo(b.sortOrder),
                    );

              return PlanPhaseModel.fromMap(phaseMap, tasks: tasks);
            })
            .toList()
          ..sort(
            (PlanPhaseModel a, PlanPhaseModel b) =>
                a.sortOrder.compareTo(b.sortOrder),
          );

    return PlanModel.fromMap(overview, phases: phases);
  }

  /// Builds a summary string when the editor does not provide one.
  String _buildSummary(PlanModel plan) {
    return '${plan.phases.length} phases · ${plan.taskCount} tasks';
  }
}
