import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:get/get.dart';

/// Loads profile summary data for the Profile page.
class ProfileController extends GetxController {
  ProfileModel? profile;
  int planCount = 0;
  int pendingSyncCount = 0;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  /// Refreshes the local profile summary and small counters.
  Future<void> loadProfile() async {
    profile = Get.find<ProfileService>().getProfile();
    planCount = PlanStore.to.plans.length;
    pendingSyncCount = SyncStore.to.syncRecords.length;
    update();
  }
}
