import 'package:doflow/pages/battle_map/index.dart';
import 'package:doflow/pages/battle_map/widgets/overview_banner.dart';
import 'package:doflow/pages/battle_map/widgets/track_card.dart';
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
        return CustomScaffold(
          appBar: AppBar(title: const Text('BattleMap')),
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    children: [
                      OverviewBanner(plans: controller.plans),
                      SizedBox(height: 16.h),
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
