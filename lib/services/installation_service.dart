import 'package:doflow/services/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Generates and persists a stable installation identifier for this device.
class InstallationService extends GetxService {
  final Uuid _uuid = const Uuid();
  late final String installationId;

  /// Ensures the installation identifier exists before the app starts routing.
  Future<InstallationService> init() async {
    final StorageService storageService = Get.find<StorageService>();
    final String? savedId = storageService.read<String>(
      AppStorageKeys.installationId,
    );

    if (savedId != null && savedId.isNotEmpty) {
      installationId = savedId;
      return this;
    }

    installationId = _uuid.v4();
    await storageService.write(AppStorageKeys.installationId, installationId);
    return this;
  }
}
