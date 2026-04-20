import 'package:doflow/models/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the phase timeline for a plan detail page.
class PlanTimeline extends StatelessWidget {
  const PlanTimeline({super.key, required this.phases});

  final List<PlanPhaseModel> phases;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: phases.asMap().entries.map((entry) {
        final int index = entry.key;
        final PlanPhaseModel phase = entry.value;
        final bool isLast = index == phases.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2.w,
                      height: 56.h,
                      color: const Color(0xFFD1D5DB),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      phase.goal,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      formatDateRange(phase.startAt, phase.endAt),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
