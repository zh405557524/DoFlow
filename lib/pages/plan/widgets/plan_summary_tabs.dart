import 'package:doflow/pages/plan/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the summary scope tabs and progress card under the hero.
class PlanSummaryTabs extends StatelessWidget {
  const PlanSummaryTabs({
    super.key,
    required this.selectedScope,
    required this.summaryTitle,
    required this.summaryValue,
    required this.summaryCaption,
    required this.summaryProgress,
    required this.onScopeChanged,
  });

  final PlanSummaryScope selectedScope;
  final String summaryTitle;
  final String summaryValue;
  final String summaryCaption;
  final double summaryProgress;
  final ValueChanged<PlanSummaryScope> onScopeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              _ScopeButton(
                label: '今日 Today',
                isSelected: selectedScope == PlanSummaryScope.today,
                onTap: () => onScopeChanged(PlanSummaryScope.today),
              ),
              SizedBox(width: 8.w),
              _ScopeButton(
                label: '本周 Week',
                isSelected: selectedScope == PlanSummaryScope.week,
                onTap: () => onScopeChanged(PlanSummaryScope.week),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
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
              Row(
                children: [
                  Text(
                    summaryTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    summaryValue,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF6366F1),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: summaryProgress.clamp(0.0, 1.0),
                  minHeight: 10.h,
                  backgroundColor: const Color(0xFFE7EBF4),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7C5CFF),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                summaryCaption,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isSelected
                  ? const Color(0xFF1E1B4B)
                  : const Color(0xFF94A3B8),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
