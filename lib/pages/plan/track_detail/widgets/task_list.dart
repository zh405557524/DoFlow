import 'package:doflow/models/index.dart';
import 'package:doflow/store/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders every task inside a phase section.
class TrackTaskList extends StatelessWidget {
  const TrackTaskList({super.key, required this.phase});

  final PlanPhaseModel phase;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: phase.tasks.map((PlanTaskModel task) {
        final bool hasPendingSync = SyncStore.to.hasPendingFor(task.id);
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0D1E1B4B),
                blurRadius: 12,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: task.isOptional
                      ? const Color(0x1AF59E0B)
                      : const Color(0x1A6366F1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  task.isOptional
                      ? Icons.repeat_rounded
                      : Icons.check_circle_outline_rounded,
                  size: 14.w,
                  color: task.isOptional
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF6366F1),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      task.note.isEmpty
                          ? (task.isOptional ? '循环执行任务' : '顺序推进任务')
                          : task.note,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPendingSync)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '待同步',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF92400E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
