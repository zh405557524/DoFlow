import 'package:doflow/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders a single editable task row inside a phase card.
class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  final PlanTaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bool isRecurring = task.isOptional;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0x336366F1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isRecurring
                    ? const Color(0xFFFCD34D)
                    : const Color(0xFFD8E0EF),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              isRecurring ? Icons.repeat_rounded : Icons.task_alt_rounded,
              size: 18.w,
              color: isRecurring
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF6366F1),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  task.note.isEmpty
                      ? (isRecurring ? '循环任务' : '顺序任务')
                      : task.note,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isRecurring
                      ? const Color(0x1AF59E0B)
                      : const Color(0x1A6366F1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  isRecurring ? '循环' : '顺序',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isRecurring
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF6366F1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
