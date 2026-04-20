import 'package:bot_toast/bot_toast.dart';
import 'package:doflow/global.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Boots the app and initializes the offline-first foundation first.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive must be ready before Global.init opens the app boxes.
  await Hive.initFlutter();

  // Global.init wires storage, services, stores, and local boxes once.
  await Global.init();

  // The app stays portrait-first in the current mobile scope.
  SystemChrome.setSystemUIOverlayStyle(CustomTheme.systemStyleLight);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const DoFlowApp());
}

/// Root app widget that binds theme, screen adaptation, toast, and router.
class DoFlowApp extends StatelessWidget {
  const DoFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TransitionBuilder botToastBuilder = BotToastInit();

    return MaterialApp.router(
      title: '执行力',
      theme: CustomTheme.light,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: CustomRouter.config,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context),
          child: Builder(
            builder: (BuildContext innerContext) {
              // ScreenUtil stays aligned with the Solfeggio-style foundation.
              ScreenUtil.init(
                innerContext,
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
              );

              return botToastBuilder(innerContext, child);
            },
          ),
        );
      },
    );
  }
}
