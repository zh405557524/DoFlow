import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the BattleMap entry hero on the Plan page.
class BattleMapHero extends StatelessWidget {
  const BattleMapHero({
    super.key,
    required this.planCount,
    required this.onOpenBattleMap,
  });

  final int planCount;
  final VoidCallback onOpenBattleMap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenBattleMap,
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF1E1B4B),
              Color(0xFF312E81),
              Color(0xFF4C1D95),
            ],
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x33312E81),
              blurRadius: 22,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.public_rounded,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '年度作战地图',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '$planCount 条主线 · 把重要事情放回一张图里',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFA5B4FC),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFA5B4FC)),
          ],
        ),
      ),
    );
  }
}
