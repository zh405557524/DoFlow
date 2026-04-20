import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Loads a single plan detail view by id.
class TrackDetailController extends GetxController {
  TrackDetailController({required this.trackId});

  final String trackId;
  bool isLoading = true;
  PlanModel? plan;
  List<TaskInstanceModel> taskInstances = const <TaskInstanceModel>[];

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  /// Refreshes the detail aggregate and task instances from local storage.
  Future<void> loadDetail() async {
    isLoading = true;
    update();
    plan = await Get.find<PlanService>().getPlanById(trackId);
    taskInstances = await Get.find<TaskInstanceService>().fetchInstancesForPlan(
      trackId,
    );
    isLoading = false;
    update();
  }
}
