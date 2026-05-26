import 'dart:io';

import 'package:doflow/global.dart';
import 'package:doflow/main.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/utils/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final Directory tempDir = await Directory.systemTemp.createTemp(
      'doflow_widget_test_',
    );
    const MethodChannel pathProviderChannel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return tempDir.path;
          }
          return tempDir.path;
        });

    Hive.init(tempDir.path);
    PackageInfo.setMockInitialValues(
      appName: 'DoFlow',
      packageName: 'com.example.doflow',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );

    await Global.init();
  });

  test('full_demo seed imports stable local business data', () async {
    await Get.find<LocalSeedService>().resetAndSeed(SeedScenario.fullDemo);

    expect(Hive.box<dynamic>(AppHiveBoxes.plans).length, 3);
    expect(Hive.box<dynamic>(AppHiveBoxes.planPhases).length, 9);
    expect(Hive.box<dynamic>(AppHiveBoxes.planTasks).length, 21);
    expect(Hive.box<dynamic>(AppHiveBoxes.taskInstances).length, 21);
    expect(Hive.box<dynamic>(AppHiveBoxes.chatMessages).length, 4);
    expect(Hive.box<dynamic>(AppHiveBoxes.planDrafts).length, 2);
    expect(Hive.box<dynamic>(AppHiveBoxes.profiles).length, 1);
    expect(Hive.box<dynamic>(AppHiveBoxes.noteFolders).length, 3);
    expect(Hive.box<dynamic>(AppHiveBoxes.noteFiles).length, 5);
    expect(Hive.box<dynamic>(AppHiveBoxes.syncRecords).length, 3);

    expect(
      Hive.box<dynamic>(
        AppHiveBoxes.planDrafts,
      ).containsKey(DemoSeedIds.draftChatGenerated),
      isTrue,
    );
    expect(
      Hive.box<dynamic>(
        AppHiveBoxes.planDrafts,
      ).containsKey(DemoSeedIds.draftChatApplied),
      isTrue,
    );
    expect(
      Hive.box<dynamic>(AppHiveBoxes.profiles).containsKey(
        DemoSeedIds.profileDemoUser,
      ),
      isTrue,
    );
    expect(
      Hive.box<dynamic>(
        AppHiveBoxes.noteFolders,
      ).containsKey(DemoSeedIds.noteRootAndroid),
      isTrue,
    );
    expect(
      Hive.box<dynamic>(
        AppHiveBoxes.noteFolders,
      ).containsKey(DemoSeedIds.noteRootProduct),
      isTrue,
    );

    final snapshot = await Get.find<NowService>().buildSnapshot();
    expect(snapshot.recommendedTask?.id, 'instance_job_android');
    expect(snapshot.backupTasks, hasLength(3));

    final jobPlan = await Get.find<PlanService>().getPlanById(
      DemoSeedIds.planJobSwitch,
    );
    final lovePlan = await Get.find<PlanService>().getPlanById(
      DemoSeedIds.planLoveProgress,
    );

    expect(jobPlan?.phases.length, 3);
    expect(lovePlan?.phases.length, 3);
  });

  testWidgets('App boots into the branded splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DoFlowApp());
    await tester.pump();

    expect(find.text('执行力'), findsOneWidget);
    expect(find.text('始终显示现在该做什么'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
  });
}
