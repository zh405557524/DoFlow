import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Loads aggregated plans for the battle map overview.
class BattleMapController extends GetxController {
  bool isLoading = true;
  List<PlanModel> plans = const <PlanModel>[];

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  /// Refreshes the local battle map list from plans.
  Future<void> loadPlans() async {
    isLoading = true;
    update();
    plans = await Get.find<PlanService>().fetchPlans();
    isLoading = false;
    update();
  }
}
