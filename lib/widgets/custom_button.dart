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
    const double buttonRadius = 18;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(buttonRadius),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? CustomTheme.brandGradient
                : const LinearGradient(
                    colors: <Color>[Color(0xFFD6DBE8), Color(0xFFCBD5E1)],
                  ),
            borderRadius: BorderRadius.circular(buttonRadius),
            boxShadow: isEnabled
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x336366F1),
                      blurRadius: 16,
                      offset: Offset(0, 8),
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
                  const SizedBox(width: 6),
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
