import 'package:get/get.dart';

/// Stores app-wide local configuration flags.
class ConfigStore extends GetxService {
  static ConfigStore get to => Get.find<ConfigStore>();

  final RxBool isFoundationReady = false.obs;

  /// Marks the app as ready once Global.init finishes.
  void markFoundationReady() {
    isFoundationReady.value = true;
  }
}
