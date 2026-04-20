import 'package:doflow/models/index.dart';
import 'package:doflow/store/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the currently recommended task.
class RecommendTaskCard extends StatelessWidget {
  const RecommendTaskCard({super.key, required this.task});

  final TaskInstanceModel task;

  @override
  Widget build(BuildContext context) {
    final bool pendingSync = SyncStore.to.hasPendingFor(task.id);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.taskTitle, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.h),
            Text(
              '${task.planTitle} · ${task.phaseTitle}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (task.taskNote.isNotEmpty) ...[
              SizedBox(height: 10.h),
              Text(task.taskNote, style: Theme.of(context).textTheme.bodyLarge),
            ],
            if (pendingSync) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Pending sync',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF92400E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
