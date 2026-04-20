import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the top-level BattleMap entry hero on the Plan page.
class BattleMapHero extends StatelessWidget {
  const BattleMapHero({
    super.key,
    required this.planCount,
    required this.onOpenBattleMap,
    required this.onCreatePlan,
  });

  final int planCount;
  final VoidCallback onOpenBattleMap;
  final VoidCallback onCreatePlan;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x332C1D95),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '年度作战地图',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFA5B4FC),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '把计划放到一张图里，\n看清真正的主线。',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                height: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '当前已整理 $planCount 条计划，适合先从最重要的一条开始推进。',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: '打开作战地图',
                    icon: Icons.auto_awesome_mosaic_rounded,
                    onPressed: onOpenBattleMap,
                  ),
                ),
                SizedBox(width: 12.w),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: IconButton(
                    onPressed: onCreatePlan,
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    tooltip: '创建计划',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
