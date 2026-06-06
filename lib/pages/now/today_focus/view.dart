import 'package:doflow/models/index.dart';
import 'package:doflow/pages/now/today_focus/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the v2 full-screen, single-task focus page.
class TodayFocusPage extends StatelessWidget {
  const TodayFocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodayFocusController>(
      init: TodayFocusController(),
      global: false,
      builder: (TodayFocusController controller) {
        return CustomScaffold(
          backgroundColor: const Color(0xFFFEFDF9),
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.task == null
                ? _EmptyFocus(
                    onBack: () => context.pop(),
                    onCreatePlan: () => context.pushNamed(RouteName.planCreate),
                  )
                : _FocusReady(controller: controller, task: controller.task!),
          ),
        );
      },
    );
  }
}

class _FocusReady extends StatelessWidget {
  const _FocusReady({required this.controller, required this.task});

  final TodayFocusController controller;
  final TaskInstanceModel task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _FocusTopBar(
          durationLabel: controller.isRunning
              ? controller.elapsedLabel
              : _estimateLabel(task),
          onClose: () => context.pop(),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  controller.isRunning ? '专注中' : '现在只做这一件事',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CustomTheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  task.taskTitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0D0F14),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  '${task.planTitle} · ${_estimateLabel(task)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7380),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 54.h),
                _ProgressLine(isRunning: controller.isRunning),
                SizedBox(height: 18.h),
                Text(
                  controller.isRunning ? '只保留计时和必要反馈' : '进入后只保留计时和反馈',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF8C919C),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(32.w, 12.h, 32.w, 18.h),
          child: Column(
            children: <Widget>[
              FilledButton(
                onPressed: () async {
                  if (!controller.isRunning) {
                    await controller.startFocus();
                    return;
                  }
                  final String result = await controller.completeTask();
                  if (context.mounted) {
                    context.pop(result);
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(54.h),
                  backgroundColor: CustomTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(controller.isRunning ? '完成这件事' : '开始专注'),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!controller.isRunning)
                    TextButton(
                      onPressed: controller.switchTask,
                      child: const Text('换一个'),
                    ),
                  SizedBox(width: 26.w),
                  TextButton(
                    onPressed: () async {
                      final String result = await controller.postponeTask();
                      if (context.mounted) {
                        context.pop(result);
                      }
                    },
                    child: const Text('稍后'),
                  ),
                  if (controller.isRunning) ...<Widget>[
                    SizedBox(width: 26.w),
                    TextButton(
                      onPressed: () async {
                        final String result = await controller.dropTask();
                        if (context.mounted) {
                          context.pop(result);
                        }
                      },
                      child: const Text('放弃'),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                '完成后会回到对话页并更新计划进度',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF9499A6),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _estimateLabel(TaskInstanceModel task) {
    final int base = 35 + (task.priority % 3) * 10;
    return '$base 分钟';
  }
}

class _FocusTopBar extends StatelessWidget {
  const _FocusTopBar({required this.durationLabel, required this.onClose});

  final String durationLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 16.w, 0),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: const Color(0xFF1F2129),
          ),
          const Spacer(),
          Text(
            '专注',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          SizedBox(
            width: 72.w,
            child: Text(
              durationLabel,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7380),
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.isRunning});

  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5DB),
        borderRadius: BorderRadius.circular(3.r),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: isRunning ? 0.38 : 0.18,
        child: Container(
          decoration: BoxDecoration(
            color: CustomTheme.success,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
      ),
    );
  }
}

class _EmptyFocus extends StatelessWidget {
  const _EmptyFocus({required this.onBack, required this.onCreatePlan});

  final VoidCallback onBack;
  final VoidCallback onCreatePlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          const Spacer(),
          Text(
            '今天还没有可执行任务',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '先创建一个计划，我再帮你挑出现在最值得做的一件事。',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: const Color(0xFF6B7380),
            ),
          ),
          SizedBox(height: 34.h),
          FilledButton(
            onPressed: onCreatePlan,
            style: FilledButton.styleFrom(
              minimumSize: Size.fromHeight(54.h),
              backgroundColor: CustomTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            child: const Text('创建计划'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
