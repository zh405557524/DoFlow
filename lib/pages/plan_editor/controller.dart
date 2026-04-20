import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Stores the editor mode used by the plan editor route.
enum PlanEditorMode { create, edit }

/// Holds the full mutable plan form and all editor actions.
class PlanEditorController extends GetxController {
  PlanEditorController({
    required this.mode,
    this.planId,
    this.draftId,
    this.entry,
  });

  final Uuid _uuid = const Uuid();
  final PlanEditorMode mode;
  final String? planId;
  final String? draftId;
  final String? entry;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String selectedPlanType = PlanTypes.all.first;
  String selectedColor = AppPlanColors.all.first;
  DateTime startAt = DateTime.now();
  DateTime endAt = DateTime.now().add(const Duration(days: 14));
  List<PlanPhaseModel> phases = <PlanPhaseModel>[];
  final Map<String, String> fieldErrors = <String, String>{};

  @override
  void onInit() {
    super.onInit();
    initEditor();
  }

  @override
  void onClose() {
    titleController.dispose();
    summaryController.dispose();
    super.onClose();
  }

  /// Initializes the editor from a blank plan, a saved plan, or a draft.
  Future<void> initEditor() async {
    isLoading = true;
    update();

    if (mode == PlanEditorMode.edit && planId != null) {
      final PlanModel? plan = await Get.find<PlanService>().getPlanById(
        planId!,
      );
      if (plan != null) {
        _applyPlan(plan);
      }
    } else if (draftId != null) {
      final PlanDraftModel? draft = Get.find<ChatService>().getDraftById(
        draftId!,
      );
      if (draft != null) {
        _applyDraft(draft);
      } else {
        _applyPlan(Get.find<PlanService>().createEmptyPlan());
      }
    } else {
      _applyPlan(Get.find<PlanService>().createEmptyPlan());
    }

    isLoading = false;
    update();
  }

  /// Applies a full plan aggregate into editable field state.
  void _applyPlan(PlanModel plan) {
    titleController.text = plan.title;
    summaryController.text = plan.summary;
    selectedPlanType = plan.planType;
    selectedColor = plan.colorHex;
    startAt = plan.startAt;
    endAt = plan.endAt;
    phases = plan.phases
        .map(
          (PlanPhaseModel phase) => phase.copyWith(
            tasks: phase.tasks
                .map((PlanTaskModel task) => task.copyWith())
                .toList(),
          ),
        )
        .toList();
  }

  /// Converts a draft into a temporary editable plan form.
  void _applyDraft(PlanDraftModel draft) {
    titleController.text = draft.title;
    summaryController.text = draft.summary;
    selectedPlanType = draft.planType;
    selectedColor = AppPlanColors.all.first;
    startAt = draft.createdAt;
    endAt = draft.createdAt.add(const Duration(days: 14));
    phases = draft.phases
        .map(
          (PlanPhaseModel phase) => phase.copyWith(
            tasks: phase.tasks
                .map((PlanTaskModel task) => task.copyWith())
                .toList(),
          ),
        )
        .toList();
  }

  /// Adds a new phase section to the form.
  void addPhase() {
    phases = <PlanPhaseModel>[
      ...phases,
      PlanPhaseModel(
        id: _uuid.v4(),
        title: 'Phase ${phases.length + 1}',
        goal: '',
        startAt: startAt,
        endAt: endAt,
        sortOrder: phases.length,
        tasks: const <PlanTaskModel>[],
      ),
    ];
    update();
  }

  /// Updates a phase with new field values.
  void updatePhase(PlanPhaseModel updatedPhase) {
    phases = phases
        .map(
          (PlanPhaseModel phase) =>
              phase.id == updatedPhase.id ? updatedPhase : phase,
        )
        .toList();
    update();
  }

  /// Removes a phase from the form.
  void removePhase(String phaseId) {
    phases = phases
        .where((PlanPhaseModel phase) => phase.id != phaseId)
        .toList();
    update();
  }

  /// Inserts a new task into a phase.
  void addTask(String phaseId, PlanTaskModel task) {
    phases = phases.map((PlanPhaseModel phase) {
      if (phase.id != phaseId) {
        return phase;
      }
      return phase.copyWith(tasks: <PlanTaskModel>[...phase.tasks, task]);
    }).toList();
    update();
  }

  /// Updates an existing task in a phase.
  void updateTask(String phaseId, PlanTaskModel updatedTask) {
    phases = phases.map((PlanPhaseModel phase) {
      if (phase.id != phaseId) {
        return phase;
      }
      return phase.copyWith(
        tasks: phase.tasks
            .map(
              (PlanTaskModel task) =>
                  task.id == updatedTask.id ? updatedTask : task,
            )
            .toList(),
      );
    }).toList();
    update();
  }

  /// Removes a task from the selected phase.
  void removeTask(String phaseId, String taskId) {
    phases = phases.map((PlanPhaseModel phase) {
      if (phase.id != phaseId) {
        return phase;
      }
      return phase.copyWith(
        tasks: phase.tasks
            .where((PlanTaskModel task) => task.id != taskId)
            .toList(),
      );
    }).toList();
    update();
  }

  /// Validates the current form before save.
  bool validateForm() {
    fieldErrors.clear();

    if (titleController.text.trim().isEmpty) {
      fieldErrors['title'] = 'Plan title is required.';
    }
    if (phases.isEmpty) {
      fieldErrors['phases'] = 'At least one phase is required.';
    }
    if (phases.any((PlanPhaseModel phase) => phase.tasks.isEmpty)) {
      fieldErrors['tasks'] = 'Each phase needs at least one task.';
    }

    update();
    return fieldErrors.isEmpty;
  }

  /// Persists the current form as a local plan and refreshes related stores.
  Future<bool> savePlan() async {
    if (!validateForm()) {
      return false;
    }

    isSaving = true;
    update();

    final PlanModel existing = mode == PlanEditorMode.edit && planId != null
        ? (await Get.find<PlanService>().getPlanById(planId!)) ??
              Get.find<PlanService>().createEmptyPlan()
        : Get.find<PlanService>().createEmptyPlan();

    final PlanModel plan = existing.copyWith(
      id: existing.id,
      title: titleController.text.trim(),
      planType: selectedPlanType,
      summary: summaryController.text.trim(),
      startAt: startAt,
      endAt: endAt,
      colorHex: selectedColor,
      phases: phases.asMap().entries.map((entry) {
        final int phaseIndex = entry.key;
        final PlanPhaseModel phase = entry.value;
        return phase.copyWith(
          sortOrder: phaseIndex,
          tasks: phase.tasks.asMap().entries.map((taskEntry) {
            final int taskIndex = taskEntry.key;
            final PlanTaskModel task = taskEntry.value;
            return task.copyWith(sortOrder: taskIndex);
          }).toList(),
        );
      }).toList(),
    );

    await Get.find<PlanService>().savePlan(plan);
    if (draftId != null) {
      await Get.find<ChatService>().markDraftApplied(draftId!);
    }

    isSaving = false;
    update();
    return true;
  }
}
