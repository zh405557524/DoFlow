import 'package:doflow/models/index.dart';
import 'package:doflow/pages/plan_editor/widgets/task_item.dart';
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
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: phase.title,
                    decoration: const InputDecoration(labelText: 'Phase title'),
                    onChanged: (String value) {
                      onChanged(phase.copyWith(title: value));
                    },
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              initialValue: phase.goal,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Phase goal'),
              onChanged: (String value) {
                onChanged(phase.copyWith(goal: value));
              },
            ),
            SizedBox(height: 12.h),
            Text(
              formatDateRange(phase.startAt, phase.endAt),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 14.h),
            Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10.h),
            ...phase.tasks.map(
              (PlanTaskModel task) => TaskItem(
                task: task,
                onEdit: () => onEditTask(task),
                onDelete: () => onDeleteTask(task),
              ),
            ),
            SizedBox(height: 8.h),
            OutlinedButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add task'),
            ),
          ],
        ),
      ),
    );
  }
}
