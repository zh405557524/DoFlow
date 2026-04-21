import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/store/index.dart';
import 'package:get/get.dart';

/// Loads profile summary data for the Profile page.
class ProfileController extends GetxController {
  ProfileModel? profile;
  int planCount = 0;
  int pendingSyncCount = 0;
  int completedTaskCount = 0;

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
    completedTaskCount = PlanStore.to.plans.fold<int>(0, (int total, plan) {
      return total +
          plan.phases.fold<int>(0, (int phaseTotal, phase) {
            return phaseTotal +
                phase.tasks
                    .where((task) => !SyncStore.to.hasPendingFor(task.id))
                    .length;
          });
    });
    update();
  }

  double get completionRate {
    final int totalTaskCount = PlanStore.to.plans.fold<int>(
      0,
      (int total, plan) => total + plan.taskCount,
    );
    if (totalTaskCount == 0) {
      return 0;
    }
    return completedTaskCount / totalTaskCount;
  }
}
