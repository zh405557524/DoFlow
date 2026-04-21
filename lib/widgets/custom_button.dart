import 'package:doflow/theme.dart';
import 'package:flutter/material.dart';

/// Provides a shared gradient action button for the current app build.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? CustomTheme.brandGradient
                : const LinearGradient(
                    colors: <Color>[Color(0xFFD6DBE8), Color(0xFFCBD5E1)],
                  ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isEnabled
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x336366F1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
