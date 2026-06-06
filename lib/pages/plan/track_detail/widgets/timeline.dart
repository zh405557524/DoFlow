import 'package:doflow/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the phase timeline for a plan detail page.
class PlanTimeline extends StatelessWidget {
  const PlanTimeline({super.key, required this.phases});

  final List<PlanPhaseModel> phases;

  @override
  Widget build(BuildContext context) {
    final int activeIndex = phases.length <= 1 ? 0 : 1;

    return Column(
      children: phases.asMap().entries.map((entry) {
        final int index = entry.key;
        final PlanPhaseModel phase = entry.value;
        final bool isCompleted = index < activeIndex;
        final bool isActive = index == activeIndex;
        final bool isLast = index == phases.length - 1;

        final Color nodeColor = isCompleted
            ? const Color(0xFF10B981)
            : isActive
            ? const Color(0xFF6366F1)
            : const Color(0xFFE2E8F0);

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30.w,
                child: Column(
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: nodeColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: isCompleted
                          ? Icon(
                              Icons.check_rounded,
                              size: 14.w,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2.w,
                        height: isActive ? 180.h : 46.h,
                        color: const Color(0xFFDDE3F1),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            phase.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: isCompleted
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF1E1B4B),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          _periodLabel(phase),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        if (isActive) ...[
                          SizedBox(width: 10.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAE7FF),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              '进行中',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF6366F1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (isActive) ...[
                      SizedBox(height: 14.h),
                      ...phase.tasks.map((PlanTaskModel task) {
                        final bool isRecurring = task.isOptional;
                        final Color tagColor = isRecurring
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF6366F1);
                        final Color tagBackground = isRecurring
                            ? const Color(0x1AF59E0B)
                            : const Color(0x1A6366F1);

                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22.r),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x0D1E1B4B),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isRecurring
                                        ? const Color(0xFFFCD34D)
                                        : const Color(0xFFD8E0EF),
                                  ),
                                  color: isRecurring
                                      ? const Color(0xFFFFFBEB)
                                      : Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: isRecurring
                                    ? Icon(
                                        Icons.repeat_rounded,
                                        size: 16.w,
                                        color: tagColor,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      task.note.isEmpty
                                          ? (isRecurring
                                              ? '循环任务 · 每周保持推进'
                                              : '顺序任务 · 当前阶段优先完成')
                                          : task.note,
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: tagBackground,
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Text(
                                  isRecurring ? '循环' : '顺序',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: tagColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _periodLabel(PlanPhaseModel phase) {
    return '${phase.startAt.month}月-${phase.endAt.month}月';
  }
}
