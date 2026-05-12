import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders a lightweight empty or missing state for the notes flow.
class NoteEmptyState extends StatelessWidget {
  const NoteEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FF),
              borderRadius: BorderRadius.circular(18.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFF6366F1), size: 28.w),
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF94A3B8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 16.h),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
