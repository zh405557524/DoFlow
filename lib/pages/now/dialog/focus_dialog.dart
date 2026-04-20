import 'package:doflow/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows the focus confirmation dialog.
class FocusDialog extends StatelessWidget {
  const FocusDialog({super.key, required this.task});

  final TaskInstanceModel task;

  static Future<bool> show(BuildContext context, TaskInstanceModel task) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (_) => FocusDialog(task: task),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start focus?', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12.h),
            Text(
              task.taskTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            Text(
              '${task.planTitle} · ${task.phaseTitle}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Start'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
