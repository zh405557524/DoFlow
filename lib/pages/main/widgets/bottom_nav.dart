import 'package:doflow/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the custom bottom navigation used by the main shell.
class MainBottomNav extends StatelessWidget {
  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_MainNavItem> _items = <_MainNavItem>[
    _MainNavItem(label: 'Now', icon: Icons.bolt_rounded),
    _MainNavItem(label: 'Chat', icon: Icons.chat_bubble_outline_rounded),
    _MainNavItem(label: 'Plan', icon: Icons.calendar_today_rounded),
    _MainNavItem(label: 'Notes', icon: Icons.description_outlined),
    _MainNavItem(label: 'Me', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: List<Widget>.generate(_items.length, (int index) {
          final _MainNavItem item = _items[index];
          final bool isActive = index == currentIndex;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(18.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isActive
                          ? CustomTheme.primary
                          : const Color(0xFF9CA3AF),
                      size: 25.w,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? CustomTheme.primary
                            : const Color(0xFF9CA3AF),
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Stores a single bottom navigation destination descriptor.
class _MainNavItem {
  const _MainNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
