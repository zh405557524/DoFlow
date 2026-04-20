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
    _MainNavItem(label: 'Chat', icon: Icons.forum_rounded),
    _MainNavItem(label: 'Plan', icon: Icons.flag_rounded),
    _MainNavItem(label: 'Profile', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: const Border(
          top: BorderSide(color: Color(0xFFEDE9FE)),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -6),
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
              borderRadius: BorderRadius.circular(20.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFEDE9FE)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isActive
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF9CA3AF),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF9CA3AF),
                        fontWeight: isActive
                            ? FontWeight.w600
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
