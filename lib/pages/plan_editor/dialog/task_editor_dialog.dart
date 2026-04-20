import 'package:doflow/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

/// Shows a dialog for creating or editing a task inside the editor.
class TaskEditorDialog extends StatefulWidget {
  const TaskEditorDialog({super.key, this.initialTask});

  final PlanTaskModel? initialTask;

  static Future<PlanTaskModel?> show(
    BuildContext context, {
    PlanTaskModel? initialTask,
  }) {
    return showDialog<PlanTaskModel>(
      context: context,
      builder: (_) => TaskEditorDialog(initialTask: initialTask),
    );
  }

  @override
  State<TaskEditorDialog> createState() => _TaskEditorDialogState();
}

/// Stores mutable dialog field state for the task editor.
class _TaskEditorDialogState extends State<TaskEditorDialog> {
  final Uuid _uuid = const Uuid();
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title);
    _noteController = TextEditingController(text: widget.initialTask?.note);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
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
            Text(
              widget.initialTask == null ? 'Add task' : 'Edit task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 14.h),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Task note'),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) {
                        return;
                      }
                      final PlanTaskModel task =
                          (widget.initialTask ??
                                  PlanTaskModel(
                                    id: _uuid.v4(),
                                    title: '',
                                    note: '',
                                    sortOrder: 0,
                                  ))
                              .copyWith(
                                title: _titleController.text.trim(),
                                note: _noteController.text.trim(),
                              );
                      Navigator.of(context).pop(task);
                    },
                    child: const Text('Confirm'),
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
