import 'package:flutter/widgets.dart';

/// Records route transitions so future debugging can inspect page history.
class RouteObservers extends RouteObserver<PageRoute<dynamic>> {
  final List<String> history = <String>[];

  void _record(Route<dynamic>? route) {
    final String name =
        route?.settings.name ?? route?.settings.arguments?.toString() ?? '';
    if (name.isNotEmpty) {
      history.add(name);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _record(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
