import 'package:doflow/pages/now/dialog/focus_dialog.dart';
import 'package:doflow/pages/now/index.dart';
import 'package:doflow/pages/now/widgets/ai_suggestion_card.dart';
import 'package:doflow/pages/now/widgets/backup_task_item.dart';
import 'package:doflow/pages/now/widgets/recommend_task_card.dart';
import 'package:doflow/pages/now/widgets/top_status_bar.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Renders the execution-first Now page.
class NowPage extends StatelessWidget {
  const NowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NowController>(
      init: NowController(),
      global: false,
      builder: (NowController controller) {
        return CustomScaffold(
          appBar: AppBar(
            title: const Text('Now'),
            actions: [
              IconButton(
                onPressed: controller.loadNowData,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    children: [
                      TopStatusBar(
                        greeting: controller.currentGreeting,
                        statusLabel: controller.currentStatusLabel,
                      ),
                      SizedBox(height: 16.h),
                      AiSuggestionCard(suggestion: controller.suggestionText),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: 'Start focus',
                              icon: Icons.play_arrow_rounded,
                              onPressed: controller.recommendedTask == null
                                  ? null
                                  : () async {
                                      final bool confirmed =
                                          await FocusDialog.show(
                                            context,
                                            controller.recommendedTask!,
                                          );
                                      if (confirmed) {
                                        await controller.startFocus();
                                      }
                                    },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: controller.recommendedTask == null
                                  ? null
                                  : controller.switchCandidate,
                              child: const Text('Switch'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (controller.recommendedTask != null)
                        RecommendTaskCard(task: controller.recommendedTask!),
                      if (controller.recommendedTask != null) ...[
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: [
                            OutlinedButton(
                              onPressed: controller.completeTask,
                              child: const Text('Complete'),
                            ),
                            OutlinedButton(
                              onPressed: controller.postponeTask,
                              child: const Text('Postpone'),
                            ),
                            OutlinedButton(
                              onPressed: controller.dropTask,
                              child: const Text('Drop'),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 18.h),
                      Text(
                        'Backup tasks',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12.h),
                      if (controller.backupTasks.isEmpty)
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(18.w),
                            child: Text(
                              'No backup tasks yet. Save more tasks in your plans to build optional paths.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ...controller.backupTasks.map(
                        (task) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: BackupTaskItem(
                            task: task,
                            onTap: () => controller.pickBackupTask(task.id),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
