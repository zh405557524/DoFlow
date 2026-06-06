import 'package:doflow/models/index.dart';
import 'package:doflow/pages/plan/editor/dialog/task_editor_dialog.dart';
import 'package:doflow/pages/plan/editor/index.dart';
import 'package:doflow/pages/plan/editor/widgets/basic_info_section.dart';
import 'package:doflow/pages/plan/editor/widgets/phase_section.dart';
import 'package:doflow/theme.dart';
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
          body: SafeArea(
            bottom: false,
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE9FE),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: CustomTheme.primary,
                                  size: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mode == PlanEditorMode.edit ? '编辑计划' : '新建计划',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    mode == PlanEditorMode.edit
                                        ? '把这条主线重新整理得更清楚'
                                        : '构造你的未来',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: const Color(0xFF94A3B8),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
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
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.red),
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
                              label: const Text('添加阶段'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: CustomButton(
              label: controller.isSaving
                  ? '保存中...'
                  : mode == PlanEditorMode.edit
                  ? '保存计划'
                  : '创建计划',
              icon: Icons.check_rounded,
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
