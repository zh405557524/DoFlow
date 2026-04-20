import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the empty-state prompt when no plans have been created yet.
class PlanEmptyState extends StatelessWidget {
  const PlanEmptyState({
    super.key,
    required this.onCreate,
    required this.onOpenBattleMap,
  });

  final VoidCallback onCreate;
  final VoidCallback onOpenBattleMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.flag_outlined,
                  size: 30.w,
                  color: const Color(0xFF6366F1),
                ),
              ),
              SizedBox(height: 18.h),
              Text('还没有计划', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10.h),
              Text(
                '先创建第一条主线，或者先去作战地图里明确今年最值得推进的方向。',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              CustomButton(
                label: '创建计划',
                icon: Icons.add_rounded,
                onPressed: onCreate,
              ),
              SizedBox(height: 12.h),
              OutlinedButton.icon(
                onPressed: onOpenBattleMap,
                icon: const Icon(Icons.auto_awesome_mosaic_rounded),
                label: const Text('先看作战地图'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
