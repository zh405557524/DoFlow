import 'package:doflow/global.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Controls the internal debug page used for local demo seed actions.
class DebugToolsController extends GetxController {
  bool isBusy = false;
  String lastResult = '尚未执行导入。';

  int planCount = 0;
  int taskInstanceCount = 0;
  int draftCount = 0;
  int noteFolderCount = 0;
  int noteFileCount = 0;
  int syncRecordCount = 0;

  String get appName => Global.appName;
  String get version => Global.version;
  String get buildNumber => Global.buildNumber;
  String get installationId => Get.find<InstallationService>().installationId;
  List<String> get openedBoxes => Global.openedBoxes;

  @override
  void onInit() {
    super.onInit();
    refreshSnapshot();
  }

  Future<void> importFullDemo() async {
    if (isBusy) {
      return;
    }

    isBusy = true;
    update();

    try {
      await Get.find<LocalSeedService>().resetAndSeed(SeedScenario.fullDemo);
      lastResult = '已重置业务数据并导入 full_demo 场景。';
      await refreshSnapshot();
      AppToast.text('full_demo 测试数据已导入');
    } catch (error) {
      lastResult = '导入失败：$error';
      AppToast.text('导入测试数据失败');
    } finally {
      isBusy = false;
      update();
    }
  }

  Future<void> refreshSnapshot() async {
    planCount = Hive.box<dynamic>(AppHiveBoxes.plans).length;
    taskInstanceCount = Hive.box<dynamic>(AppHiveBoxes.taskInstances).length;
    draftCount = Hive.box<dynamic>(AppHiveBoxes.planDrafts).length;
    noteFolderCount = Hive.box<dynamic>(AppHiveBoxes.noteFolders).length;
    noteFileCount = Hive.box<dynamic>(AppHiveBoxes.noteFiles).length;
    syncRecordCount = Hive.box<dynamic>(AppHiveBoxes.syncRecords).length;
    update();
  }
}
