import 'package:doflow/models/index.dart';
import 'package:doflow/pages/plan_editor/dialog/task_editor_dialog.dart';
import 'package:doflow/pages/plan_editor/index.dart';
import 'package:doflow/pages/plan_editor/widgets/basic_info_section.dart';
import 'package:doflow/pages/plan_editor/widgets/phase_section.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Renders the full create/edit plan workflow.
class PlanEditorPage extends StatelessWidget {
  const PlanEditorPage({
    super.key,
    required this.mode,
    this.planId,
    this.draftId,
    this.entry,
  });

  final PlanEditorMode mode;
  final String? planId;
  final String? draftId;
  final String? entry;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanEditorController>(
      init: PlanEditorController(
        mode: mode,
        planId: planId,
        draftId: draftId,
        entry: entry,
      ),
      global: false,
      builder: (PlanEditorController controller) {
        return CustomScaffold(
          appBar: AppBar(
            title: Text(
              mode == PlanEditorMode.edit ? 'Edit plan' : 'Create plan',
            ),
          ),
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    children: [
                      BasicInfoSection(
                        titleController: controller.titleController,
                        summaryController: controller.summaryController,
                        selectedPlanType: controller.selectedPlanType,
                        selectedColor: controller.selectedColor,
                        startAt: controller.startAt,
                        endAt: controller.endAt,
                        titleError: controller.fieldErrors['title'],
                        onTypeChanged: (String? value) {
                          if (value == null) {
                            return;
                          }
                          controller.selectedPlanType = value;
                          controller.update();
                        },
                        onColorChanged: (String color) {
                          controller.selectedColor = color;
                          controller.update();
                        },
                        onPickStart: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.startAt,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2040),
                          );
                          if (picked != null) {
                            controller.startAt = picked;
                            controller.update();
                          }
                        },
                        onPickEnd: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.endAt,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2040),
                          );
                          if (picked != null) {
                            controller.endAt = picked;
                            controller.update();
                          }
                        },
                      ),
                      if (controller.fieldErrors['tasks'] != null) ...[
                        SizedBox(height: 10.h),
                        Text(
                          controller.fieldErrors['tasks']!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                        ),
                      ],
                      SizedBox(height: 16.h),
                      ...controller.phases.map(
                        (PlanPhaseModel phase) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: PhaseSection(
                            phase: phase,
                            onChanged: controller.updatePhase,
                            onDelete: () => controller.removePhase(phase.id),
                            onAddTask: () async {
                              final PlanTaskModel? task =
                                  await TaskEditorDialog.show(context);
                              if (task != null) {
                                controller.addTask(phase.id, task);
                              }
                            },
                            onEditTask: (PlanTaskModel task) async {
                              final PlanTaskModel? updatedTask =
                                  await TaskEditorDialog.show(
                                    context,
                                    initialTask: task,
                                  );
                              if (updatedTask != null) {
                                controller.updateTask(phase.id, updatedTask);
                              }
                            },
                            onDeleteTask: (PlanTaskModel task) {
                              controller.removeTask(phase.id, task.id);
                            },
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: controller.addPhase,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add phase'),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: CustomButton(
              label: controller.isSaving ? 'Saving...' : 'Save plan',
              icon: Icons.save_rounded,
              onPressed: controller.isSaving
                  ? null
                  : () async {
                      final bool success = await controller.savePlan();
                      if (success && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
            ),
          ),
        );
      },
    );
  }
}
