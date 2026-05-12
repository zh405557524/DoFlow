import 'package:bot_toast/bot_toast.dart';
import 'package:doflow/pages/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Owns the app router and all registered route entries.
abstract class CustomRouter {
  static final RouteObservers observer = RouteObservers();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static final GoRouter config = GoRouter(
    initialLocation: '/splash',
    navigatorKey: navigatorKey,
    observers: <NavigatorObserver>[observer, BotToastNavigatorObserver()],
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: RouteName.splash,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: '/',
        name: RouteName.now,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const MainPage(initialTab: MainTab.now),
        ),
      ),
      GoRoute(
        path: '/chat',
        name: RouteName.chat,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const ChatPage(),
        ),
      ),
      GoRoute(
        path: '/plan',
        name: RouteName.plan,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const MainPage(initialTab: MainTab.plan),
        ),
      ),
      GoRoute(
        path: '/notes',
        name: RouteName.notes,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const MainPage(initialTab: MainTab.notes),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: RouteName.profile,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const MainPage(initialTab: MainTab.profile),
        ),
      ),
      GoRoute(
        path: '/plan/battle',
        name: RouteName.battleMap,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const BattleMapPage(),
        ),
      ),
      GoRoute(
        path: '/plan/battle/:trackId',
        name: RouteName.trackDetail,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: TrackDetailPage(
            trackId: state.pathParameters['trackId'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/plan/editor',
        name: RouteName.planEditorCreate,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>? ?? <String, dynamic>{};
          return MaterialPage<void>(
            key: state.pageKey,
            name: state.name,
            child: PlanEditorPage(
              mode: PlanEditorMode.create,
              draftId: extra['draftId'] as String?,
              entry: extra['entry'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: '/plan/editor/:id',
        name: RouteName.planEditorEdit,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: PlanEditorPage(
            mode: PlanEditorMode.edit,
            planId: state.pathParameters['id'],
          ),
        ),
      ),
      GoRoute(
        path: '/profile/me',
        name: RouteName.userProfile,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: const UserProfilePage(),
        ),
      ),
      GoRoute(
        path: '/notes/folder/:id',
        name: RouteName.noteFolder,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: NoteFolderPage(
            folderId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/notes/file/:id',
        name: RouteName.noteFile,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: NoteFilePage(
            fileId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),
    ],
  );
}
