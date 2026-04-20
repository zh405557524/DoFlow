import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Boots the app-wide services, stores, and local persistence boxes.
class Global {
  Global._();

  static PackageInfo? _platform;
  static bool _initialized = false;
  static final List<String> _openedBoxes = <String>[];

  static bool get isInitialized => _initialized;
  static String get appName => _platform?.appName ?? 'DoFlow';
  static String get version => _platform?.version ?? '0.0.0';
  static String get buildNumber => _platform?.buildNumber ?? '0';
  static List<String> get openedBoxes =>
      List<String>.unmodifiable(_openedBoxes);

  /// Initializes package info, storage, Hive boxes, stores, and services.
  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    _platform = await PackageInfo.fromPlatform();

    await Get.putAsync<StorageService>(() => StorageService().init());
    await Get.putAsync<InstallationService>(() => InstallationService().init());

    _openedBoxes.clear();
    for (final String boxName in AppHiveBoxes.all) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      _openedBoxes.add(boxName);
    }

    Get.put<HttpService>(HttpService());
    Get.put<ConfigStore>(ConfigStore());
    Get.put<UserStore>(UserStore());
    Get.put<PlanStore>(PlanStore());
    Get.put<DraftStore>(DraftStore());
    Get.put<SyncStore>(SyncStore());

    Get.put<SyncService>(SyncService());
    Get.put<PlanService>(PlanService());
    Get.put<TaskInstanceService>(TaskInstanceService());
    Get.put<NowService>(NowService());
    Get.put<ChatService>(ChatService());
    Get.put<ProfileService>(ProfileService());

    await Get.find<SyncService>().bootstrap();
    await Get.find<PlanService>().bootstrap();
    await Get.find<ChatService>().bootstrap();
    await Get.find<ProfileService>().bootstrap();

    ConfigStore.to.markFoundationReady();
    _initialized = true;
  }
}
