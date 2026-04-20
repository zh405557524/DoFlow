import 'dart:io';

import 'package:doflow/global.dart';
import 'package:doflow/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
