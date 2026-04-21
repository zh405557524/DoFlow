import 'package:doflow/models/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the currently recommended task.
class RecommendTaskCard extends StatelessWidget {
  const RecommendTaskCard({super.key, required this.task});

  final TaskInstanceModel task;

  @override
  Widget build(BuildContext context) {
    final bool pendingSync = SyncStore.to.hasPendingFor(task.id);

    return Container(
      padding: EdgeInsets.all(22.w),
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
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x336366F1),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${task.planTitle} · ${formatClock(task.scheduledAt)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFFA5B4FC),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            task.taskTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          if (task.taskNote.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Text(
              task.taskNote,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
                height: 1.5,
              ),
            ),
          ],
          if (pendingSync) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '等待同步',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
