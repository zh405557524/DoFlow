import 'package:flutter/material.dart';

/// Centralizes modal dialog display for lightweight app dialogs.
abstract class AppDialog {
  /// Shows a dialog widget inside the shared rounded shell.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: child,
      ),
    );
  }
}
