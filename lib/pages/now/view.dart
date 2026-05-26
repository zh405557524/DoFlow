import 'package:doflow/pages/now/dialog/focus_dialog.dart';
import 'package:doflow/pages/now/index.dart';
import 'package:doflow/pages/now/widgets/ai_suggestion_card.dart';
import 'package:doflow/pages/now/widgets/backup_task_item.dart';
import 'package:doflow/pages/now/widgets/recommend_task_card.dart';
import 'package:doflow/pages/now/widgets/top_status_bar.dart';
import 'package:doflow/theme.dart';
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
          body: Container(
            decoration: const BoxDecoration(
              gradient: CustomTheme.nowBackground,
            ),
            child: SafeArea(
              bottom: false,
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
                      children: [
                        TopStatusBar(
                          greeting: controller.currentGreeting,
                          statusLabel: controller.currentStatusLabel,
                        ),
                        SizedBox(height: 16.h),
                        AiSuggestionCard(suggestion: controller.suggestionText),
                        SizedBox(height: 12.h),
                        if (controller.recommendedTask != null) ...<Widget>[
                          RecommendTaskCard(task: controller.recommendedTask!),
                          SizedBox(height: 14.h),
                        ] else
                          SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomButton(
                                label: '开始专注',
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
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size.fromHeight(52.h),
                                  backgroundColor: Colors.white,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                ),
                                child: Text(
                                  '换一个',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          '📌 备用任务',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        SizedBox(height: 12.h),
                        if (controller.backupTasks.isEmpty)
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Text(
                                '还没有备用任务。先去计划页补充更多可执行任务。',
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
                        SizedBox(height: 20.h),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
