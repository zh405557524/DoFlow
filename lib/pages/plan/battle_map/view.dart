import 'package:doflow/pages/plan/battle_map/index.dart';
import 'package:doflow/pages/plan/battle_map/widgets/overview_banner.dart';
import 'package:doflow/pages/plan/battle_map/widgets/track_card.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the strategic view of all active plans.
class BattleMapPage extends StatelessWidget {
  const BattleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BattleMapController>(
      init: BattleMapController(),
      global: false,
      builder: (BattleMapController controller) {
        final DateTime now = DateTime.now();
        final DateTime startOfYear = DateTime(now.year, 1, 1);
        final int dayOfYear = now.difference(startOfYear).inDays + 1;

        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
                    children: [
                      Row(
                        children: [
                          _BackButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '年度作战地图',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  '${now.year} · 第 $dayOfYear 天 / 365',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: const Color(0xFF94A3B8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      OverviewBanner(plans: controller.plans),
                      SizedBox(height: 18.h),
                      ...controller.plans.map(
                        (plan) => Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: TrackCard(
                            plan: plan,
                            onTap: () {
                              context.pushNamed(
                                RouteName.trackDetail,
                                pathParameters: {'trackId': plan.id},
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF6366F1),
          size: 18,
        ),
      ),
    );
  }
}
