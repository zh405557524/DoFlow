import 'package:doflow/pages/plan/index.dart';
import 'package:doflow/pages/plan/widgets/battle_map_hero.dart';
import 'package:doflow/pages/plan/widgets/plan_card.dart';
import 'package:doflow/pages/plan/widgets/plan_empty_state.dart';
import 'package:doflow/pages/plan/widgets/plan_summary_tabs.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the plan hub with overview, list, and creation entry points.
class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanController>(
      init: PlanController(),
      global: false,
      builder: (PlanController controller) {
        Future<void> openBattleMap() async {
          await context.pushNamed(RouteName.battleMap);
          await controller.loadPlans();
        }

        Future<void> openCreatePlan() async {
          await context.pushNamed(RouteName.planEditorCreate);
          await controller.loadPlans();
        }

        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '计划',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '提供安全感，但不干扰执行',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: const Color(0xFF94A3B8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: openCreatePlan,
                            child: Container(
                              width: 68.w,
                              height: 68.w,
                              decoration: BoxDecoration(
                                gradient: CustomTheme.brandGradient,
                                borderRadius: BorderRadius.circular(22.r),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0x336366F1),
                                    blurRadius: 18,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 30.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      BattleMapHero(
                        planCount: controller.plans.length,
                        onOpenBattleMap: openBattleMap,
                      ),
                      SizedBox(height: 16.h),
                      PlanSummaryTabs(
                        selectedScope: controller.selectedSummaryScope,
                        summaryTitle: controller.summaryTitle,
                        summaryValue: controller.summaryValue,
                        summaryCaption: controller.summaryCaption,
                        summaryProgress: controller.summaryProgress,
                        onScopeChanged: controller.changeSummaryScope,
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        children: [
                          Text(
                            '主线列表',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Text(
                            '${controller.plans.length} 条',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (controller.plans.isEmpty)
                        PlanEmptyState(
                          onCreate: openCreatePlan,
                          onOpenBattleMap: openBattleMap,
                        ),
                      ...controller.plans.map((plan) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: PlanCard(
                            plan: plan,
                            onTap: () async {
                              await context.pushNamed(
                                RouteName.trackDetail,
                                pathParameters: {'trackId': plan.id},
                              );
                              await controller.loadPlans();
                            },
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
