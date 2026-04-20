import 'package:doflow/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the battle map header summary.
class OverviewBanner extends StatelessWidget {
  const OverviewBanner({super.key, required this.plans});

  final List<PlanModel> plans;

  @override
  Widget build(BuildContext context) {
    final int taskCount = plans.fold<int>(
      0,
      (int sum, PlanModel plan) => sum + plan.taskCount,
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BattleMap', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10.h),
            Text(
              'View every active plan as one strategic board.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 14.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                _BattleMetric(label: 'Plans', value: '${plans.length}'),
                _BattleMetric(
                  label: 'Phases',
                  value:
                      '${plans.fold<int>(0, (int sum, PlanModel plan) => sum + plan.phaseCount)}',
                ),
                _BattleMetric(label: 'Tasks', value: '$taskCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a compact metric inside the overview banner.
class _BattleMetric extends StatelessWidget {
  const _BattleMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 4.h),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
