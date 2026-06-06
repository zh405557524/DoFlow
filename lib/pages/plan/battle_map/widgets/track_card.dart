import 'package:doflow/models/index.dart';
import 'package:doflow/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders a single plan lane inside the battle map list.
class TrackCard extends StatelessWidget {
  const TrackCard({super.key, required this.plan, required this.onTap});

  final PlanModel plan;
  final VoidCallback onTap;

  double get _progress {
    final int totalDays = plan.endAt.difference(plan.startAt).inDays;
    if (totalDays <= 0) {
      return 0.1;
    }
    final int elapsedDays = DateTime.now().difference(plan.startAt).inDays;
    return (elapsedDays / totalDays).clamp(0.08, 0.92);
  }

  String get _statusLabel => _progress > 0.18 ? '进行中' : '低频';

  Color get _statusColor =>
      _progress > 0.18 ? const Color(0xFF10B981) : const Color(0xFF94A3B8);

  IconData get _icon {
    final String seed = '${plan.title}${plan.planType}';
    if (seed.contains('工作')) {
      return Icons.rocket_launch_rounded;
    }
    if (seed.contains('作品') || seed.contains('创作')) {
      return Icons.palette_rounded;
    }
    if (seed.contains('房')) {
      return Icons.home_rounded;
    }
    if (seed.contains('恋爱') || seed.contains('关系')) {
      return Icons.favorite_rounded;
    }
    return Icons.bolt_rounded;
  }

  List<double> get _rhythm {
    final int base = (plan.phaseCount + plan.taskCount).clamp(3, 9);
    return List<double>.generate(7, (int index) {
      return ((base + index) % 4 + 1) / 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = CustomTheme.planColor(plan.colorHex);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0D1E1B4B),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 78.w,
              height: 78.w,
              decoration: BoxDecoration(
                gradient: CustomTheme.planGradient(plan.colorHex),
                borderRadius: BorderRadius.circular(24.r),
              ),
              alignment: Alignment.center,
              child: Icon(_icon, color: Colors.white, size: 34.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          plan.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Text(
                          _statusLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999.r),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 8.h,
                            backgroundColor: const Color(0xFFE8EDF5),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accent),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '${(_progress * 100).round()}%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: _rhythm.map((double item) {
                      return Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Container(
                          width: 8.w,
                          height: (14 + (item * 18)).h,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.78),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
