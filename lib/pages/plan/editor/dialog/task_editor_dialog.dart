import 'package:doflow/models/index.dart';
import 'package:doflow/theme.dart';
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
  late bool _isRecurring;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title);
    _noteController = TextEditingController(text: widget.initialTask?.note);
    _isRecurring = widget.initialTask?.isOptional ?? false;
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialTask == null ? '添加任务' : '编辑任务',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '任务标题'),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '任务说明'),
            ),
            SizedBox(height: 16.h),
            Text(
              '任务类型',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _TypeOption(
                    label: '顺序任务',
                    active: !_isRecurring,
                    onTap: () => setState(() => _isRecurring = false),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _TypeOption(
                    label: '循环任务',
                    active: _isRecurring,
                    onTap: () => setState(() => _isRecurring = true),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: CustomTheme.primary,
                    ),
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
                                isOptional: _isRecurring,
                              );
                      Navigator.of(context).pop(task);
                    },
                    child: const Text('确认'),
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

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          gradient: active ? CustomTheme.brandGradient : null,
          color: active ? null : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: active ? Colors.white : CustomTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
