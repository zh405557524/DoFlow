import 'package:doflow/models/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders a simplified row card in the Plan page list.
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
    final Color accent = CustomTheme.planColor(plan.colorHex);
    final bool isActive = _timeProgress > 0.05 && _timeProgress < 1;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0D1E1B4B),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFD8E0EF),
                ),
              ),
              alignment: Alignment.center,
              child: isActive
                  ? const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: CustomTheme.primary,
                    )
                  : null,
            ),
            SizedBox(width: 14.w),
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.layers_rounded, color: accent, size: 22.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${labelForPlanType(plan.planType)} · ${formatDateRange(plan.startAt, plan.endAt)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '${plan.taskCount}项',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }
}
