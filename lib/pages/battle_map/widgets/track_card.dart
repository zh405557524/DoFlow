import 'package:doflow/models/index.dart';
import 'package:doflow/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders a single plan lane inside the battle map list.
class TrackCard extends StatelessWidget {
  const TrackCard({super.key, required this.plan, required this.onTap});

  final PlanModel plan;
  final VoidCallback onTap;

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
                  Expanded(
                    child: Text(
                      plan.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: CustomTheme.planColor(
                        plan.colorHex,
                      ).withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      plan.planType,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomTheme.planColor(plan.colorHex),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(plan.summary, style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 14.h),
              LinearProgressIndicator(
                value: plan.taskCount == 0 ? 0 : 1 / (plan.taskCount + 1),
                color: CustomTheme.planColor(plan.colorHex),
                minHeight: 8.h,
                borderRadius: BorderRadius.circular(999.r),
                backgroundColor: const Color(0xFFE5E7EB),
              ),
              SizedBox(height: 12.h),
              Text(
                '${plan.phaseCount} phases · ${plan.taskCount} tasks',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
