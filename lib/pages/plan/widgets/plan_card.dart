import 'package:doflow/models/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders a single plan summary card in the Plan page list.
class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan, required this.onTap});

  final PlanModel plan;
  final VoidCallback onTap;

  double get _timeProgress {
    final int totalDays = plan.endAt.difference(plan.startAt).inDays;
    if (totalDays <= 0) {
      return 0.0;
    }

    final int elapsedDays = DateTime.now().difference(plan.startAt).inDays;
    return (elapsedDays / totalDays).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: CustomTheme.planColor(
                        plan.colorHex,
                      ).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.flag_rounded,
                      color: CustomTheme.planColor(plan.colorHex),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          plan.planType,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: CustomTheme.planColor(plan.colorHex),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                plan.summary,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    '时间进度',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(_timeProgress * 100).round()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomTheme.planColor(plan.colorHex),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: _timeProgress,
                  color: CustomTheme.planColor(plan.colorHex),
                  minHeight: 8.h,
                  backgroundColor: const Color(0xFFE5E7EB),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                formatDateRange(plan.startAt, plan.endAt),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _MetaChip(label: '${plan.phaseCount} phases'),
                  _MetaChip(label: '${plan.taskCount} tasks'),
                  _MetaChip(label: '继续推进'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders a compact metadata chip for plan summaries.
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
