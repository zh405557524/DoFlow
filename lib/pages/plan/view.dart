import 'package:doflow/pages/plan/index.dart';
import 'package:doflow/pages/plan/widgets/battle_map_hero.dart';
import 'package:doflow/pages/plan/widgets/plan_card.dart';
import 'package:doflow/pages/plan/widgets/plan_empty_state.dart';
import 'package:doflow/pages/plan/widgets/plan_summary_tabs.dart';
import 'package:doflow/routes/index.dart';
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
          appBar: AppBar(
            title: const Text('计划'),
            actions: [
              IconButton(
                onPressed: controller.loadPlans,
                icon: const Icon(Icons.refresh_rounded),
              ),
              IconButton(
                onPressed: openCreatePlan,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    children: [
                      BattleMapHero(
                        planCount: controller.plans.length,
                        onOpenBattleMap: openBattleMap,
                        onCreatePlan: openCreatePlan,
                      ),
                      SizedBox(height: 16.h),
                      PlanSummaryTabs(
                        selectedScope: controller.selectedSummaryScope,
                        headline: controller.summaryHeadline,
                        metrics: controller.summaryMetrics,
                        onScopeChanged: controller.changeSummaryScope,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            '你的计划',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Text(
                            '${controller.plans.length} 条',
                            style: Theme.of(context).textTheme.bodyMedium,
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
          floatingActionButton: FloatingActionButton(
            onPressed: openCreatePlan,
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }
}
