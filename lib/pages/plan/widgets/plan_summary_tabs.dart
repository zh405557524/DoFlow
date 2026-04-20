import 'package:doflow/pages/plan/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the summary scope tabs and the metrics cards under the hero.
class PlanSummaryTabs extends StatelessWidget {
  const PlanSummaryTabs({
    super.key,
    required this.selectedScope,
    required this.headline,
    required this.metrics,
    required this.onScopeChanged,
  });

  final PlanSummaryScope selectedScope;
  final String headline;
  final List<PlanSummaryMetric> metrics;
  final ValueChanged<PlanSummaryScope> onScopeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              _ScopeButton(
                label: '今日',
                isSelected: selectedScope == PlanSummaryScope.today,
                onTap: () => onScopeChanged(PlanSummaryScope.today),
              ),
              SizedBox(width: 8.w),
              _ScopeButton(
                label: '本周',
                isSelected: selectedScope == PlanSummaryScope.week,
                onTap: () => onScopeChanged(PlanSummaryScope.week),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          headline,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: List<Widget>.generate(metrics.length, (int index) {
            final PlanSummaryMetric metric = metrics[index];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == metrics.length - 1 ? 0 : 10.w),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x0D1E1B4B),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metric.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        metric.value,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        metric.caption,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ScopeButton extends StatelessWidget {
  const _ScopeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isSelected
                  ? const Color(0xFF1E1B4B)
                  : const Color(0xFF64748B),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
