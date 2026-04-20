import 'package:bot_toast/bot_toast.dart';

/// Centralizes text toast calls so the rest of the app uses one helper.
abstract class AppToast {
  /// Shows a lightweight text toast.
  static void text(String message) {
    BotToast.showText(text: message);
  }
}
