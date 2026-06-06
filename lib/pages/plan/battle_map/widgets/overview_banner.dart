import 'package:doflow/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the yearly progress banner for the battle map page.
class OverviewBanner extends StatelessWidget {
  const OverviewBanner({super.key, required this.plans});

  final List<PlanModel> plans;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime startOfYear = DateTime(now.year, 1, 1);
    final DateTime endOfYear = DateTime(now.year + 1, 1, 1);
    final int totalDays = endOfYear.difference(startOfYear).inDays;
    final int passedDays = now.difference(startOfYear).inDays + 1;
    final double progress = (passedDays / totalDays).clamp(0.0, 1.0);
    final int remainingDays = totalDays - passedDays;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF1E1B4B), Color(0xFF312E81)],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33312E81),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${now.year} 已过去',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '剩余 $remainingDays 天',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.58),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFA5B4FC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
