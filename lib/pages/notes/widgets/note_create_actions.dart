import 'package:doflow/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the paired create-folder and create-note actions.
class NoteCreateActions extends StatelessWidget {
  const NoteCreateActions({
    super.key,
    required this.onCreateFolder,
    required this.onCreateNote,
  });

  final VoidCallback onCreateFolder;
  final VoidCallback onCreateNote;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: '新建文件夹',
            icon: Icons.create_new_folder_outlined,
            isPrimary: false,
            onTap: onCreateFolder,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ActionButton(
            label: '新建笔记',
            icon: Icons.note_add_outlined,
            isPrimary: true,
            onTap: onCreateNote,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isPrimary ? Colors.white : const Color(0xFF334155);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Ink(
        height: 46.h,
        decoration: BoxDecoration(
          color: isPrimary ? null : const Color(0xFFF8FAFC),
          gradient: isPrimary ? CustomTheme.brandGradient : null,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: 17.w),
            SizedBox(width: 6.w),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 15.sp,
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
