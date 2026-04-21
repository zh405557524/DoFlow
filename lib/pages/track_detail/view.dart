import 'package:doflow/models/index.dart';
import 'package:doflow/pages/track_detail/index.dart';
import 'package:doflow/pages/track_detail/widgets/timeline.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the detail page for one selected plan.
class TrackDetailPage extends StatelessWidget {
  const TrackDetailPage({super.key, required this.trackId});

  final String trackId;

  double _progressOfPlan(PlanModel plan) {
    final int totalDays = plan.endAt.difference(plan.startAt).inDays;
    if (totalDays <= 0) {
      return 0.1;
    }
    final int elapsedDays = DateTime.now().difference(plan.startAt).inDays;
    return (elapsedDays / totalDays).clamp(0.08, 0.92);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackDetailController>(
      init: TrackDetailController(trackId: trackId),
      global: false,
      builder: (TrackDetailController controller) {
        final plan = controller.plan;

        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : plan == null
                ? Center(
                    child: Text(
                      '没有找到对应主线。',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : Builder(
                    builder: (BuildContext context) {
                      final double progress = _progressOfPlan(plan);
                      final int activeIndex = plan.phases.length <= 1 ? 0 : 1;
                      final String currentPhase = plan.phases.isEmpty
                          ? '待开始'
                          : plan.phases[activeIndex].title;

                      return ListView(
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
                                      plan.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      '目标：${plan.summary.isEmpty ? '把这条主线稳定推进下去' : plan.summary}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: const Color(0xFF94A3B8),
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .pushNamed(
                                        RouteName.planEditorEdit,
                                        pathParameters: {'id': plan.id},
                                      )
                                      .then((_) => controller.loadDetail());
                                },
                                child: Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    color: CustomTheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFF1E1B4B),
                                  Color(0xFF312E81),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '总体进度',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.72,
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${(progress * 100).round()}%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999.r),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 10.h,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.12,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      Color(0xFFA5B4FC),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  '当前阶段 · $currentPhase',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.h),
                          PlanTimeline(phases: plan.phases),
                          SizedBox(height: 8.h),
                          CustomButton(
                            label: '去 Now 页面立刻执行',
                            icon: Icons.bolt_rounded,
                            onPressed: () => context.goNamed(RouteName.now),
                          ),
                        ],
                      );
                    },
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
          color: CustomTheme.primary,
          size: 18,
        ),
      ),
    );
  }
}
