import 'package:doflow/global.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

class FoundationPlaceholderController extends GetxController {
  String get appName => Global.appName;
  String get version => Global.version;
  String get buildNumber => Global.buildNumber;
  String get installationId => Get.find<InstallationService>().installationId;
  List<String> get openedBoxes => Global.openedBoxes;
  bool get isReady => Global.isInitialized;
}
