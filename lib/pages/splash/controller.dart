import 'package:doflow/routes/index.dart';
import 'package:doflow/store/index.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Coordinates the splash delay and the first navigation into the main shell.
class SplashController extends GetxController {
  bool _started = false;

  /// Starts the delayed bootstrap once per page mount.
  Future<void> start(BuildContext context) async {
    if (_started) {
      return;
    }
    _started = true;

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!context.mounted) {
      return;
    }

    if (ConfigStore.to.isFoundationReady.value) {
      context.goNamed(RouteName.chatHome);
    }
  }
}
