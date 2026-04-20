import 'package:doflow/models/index.dart';
import 'package:get/get.dart';

/// Stores locally aggregated plans so pages can reactively render them.
class PlanStore extends GetxService {
  static PlanStore get to => Get.find<PlanStore>();

  final RxList<PlanModel> plans = <PlanModel>[].obs;

  /// Replaces the in-memory plan list with the latest aggregate data.
  void setPlans(List<PlanModel> items) {
    plans.assignAll(items);
  }

  /// Returns a single aggregated plan if it is already in memory.
  PlanModel? getPlanById(String planId) {
    try {
      return plans.firstWhere((PlanModel plan) => plan.id == planId);
    } catch (_) {
      return null;
    }
  }
}
