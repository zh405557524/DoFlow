import 'package:doflow/models/index.dart';
import 'package:doflow/pages/plan/editor/widgets/task_item.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders one editable phase card and its task list.
class PhaseSection extends StatelessWidget {
  const PhaseSection({
    super.key,
    required this.phase,
    required this.onChanged,
    required this.onDelete,
    required this.onAddTask,
    required this.onEditTask,
    required this.onDeleteTask,
  });

  final PlanPhaseModel phase;
  final ValueChanged<PlanPhaseModel> onChanged;
  final VoidCallback onDelete;
  final VoidCallback onAddTask;
  final ValueChanged<PlanTaskModel> onEditTask;
  final ValueChanged<PlanTaskModel> onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEC4899),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Text('阶段目标', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF2F8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${phase.sortOrder + 3}'.padLeft(2, '0'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFEC4899),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          TextFormField(
            initialValue: phase.title,
            decoration: const InputDecoration(labelText: '阶段名称'),
            onChanged: (String value) {
              onChanged(phase.copyWith(title: value));
            },
          ),
          SizedBox(height: 12.h),
          TextFormField(
            initialValue: phase.goal,
            maxLines: 2,
            decoration: const InputDecoration(labelText: '阶段目标'),
            onChanged: (String value) {
              onChanged(phase.copyWith(goal: value));
            },
          ),
          SizedBox(height: 12.h),
          Text(
            formatDateRange(phase.startAt, phase.endAt),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 18.h),
          ...phase.tasks.map(
            (PlanTaskModel task) => TaskItem(
              task: task,
              onEdit: () => onEditTask(task),
              onDelete: () => onDeleteTask(task),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('添加任务'),
                ),
              ),
              SizedBox(width: 12.w),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
