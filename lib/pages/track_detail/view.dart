import 'package:doflow/pages/track_detail/index.dart';
import 'package:doflow/pages/track_detail/widgets/task_list.dart';
import 'package:doflow/pages/track_detail/widgets/timeline.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the detail page for one selected plan.
class TrackDetailPage extends StatelessWidget {
  const TrackDetailPage({super.key, required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackDetailController>(
      init: TrackDetailController(trackId: trackId),
      global: false,
      builder: (TrackDetailController controller) {
        final plan = controller.plan;

        return CustomScaffold(
          appBar: AppBar(
            title: const Text('Track detail'),
            actions: [
              IconButton(
                onPressed: plan == null
                    ? null
                    : () {
                        context
                            .pushNamed(
                              RouteName.planEditorEdit,
                              pathParameters: {'id': plan.id},
                            )
                            .then((_) => controller.loadDetail());
                      },
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : plan == null
                ? Center(
                    child: Text(
                      'Plan not found.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(18.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                plan.summary,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                formatDateRange(plan.startAt, plan.endAt),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Timeline',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12.h),
                      PlanTimeline(phases: plan.phases),
                      SizedBox(height: 18.h),
                      Text(
                        'Tasks by phase',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12.h),
                      ...plan.phases.map(
                        (phase) => Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phase.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 8.h),
                              TrackTaskList(phase: phase),
                            ],
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
