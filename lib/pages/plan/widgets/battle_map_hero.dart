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
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x33312E81),
              blurRadius: 28,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 74.w,
              height: 74.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.public_rounded,
                color: Colors.white,
                size: 28.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '年度作战地图',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$planCount 条主线 · 把重要事情放回一张图里',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFA5B4FC),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFA5B4FC),
            ),
          ],
        ),
      ),
    );
  }
}
