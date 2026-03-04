import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:flutter/material.dart';

class AppRouteObserver extends AutoRouterObserver {
  /// Extract structured path info like go_router
  String _extractRouteData(Route<dynamic>? route) {
    if (route == null) return 'none';

    final settings = route.settings;
    if (settings is AutoRoutePage) {
      final routeData = settings.routeData;
      final buffer = StringBuffer();

      buffer.write(routeData.name);
      if (routeData.path.isNotEmpty) {
        buffer.write(' [${routeData.path}]');
      }

      if (routeData.params.isNotEmpty) {
        buffer.write('\n      ├─ Params: ${routeData.params}');
      }

      if (routeData.queryParams.isNotEmpty) {
        buffer.write('\n      ├─ Query: ${routeData.queryParams}');
      }

      // Accessing route arguments if present, though they can be large
      // Only log if not trivial
      if (routeData.args != null) {
        buffer.write('\n      ├─ Args: ${routeData.args}');
      }

      return buffer.toString();
    }

    return settings.name ?? 'none';
  }

  String _extractTabRouteData(TabPageRoute route) {
    return '${route.name} [${route.path}]';
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final to = _extractRouteData(route);
    logRoute('PUSH: ${previousRoute?.settings.name ?? 'none'} →\n      └─ $to');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final from = _extractRouteData(route);
    final to = _extractRouteData(previousRoute);
    logRoute('POP: $from →\n      └─ $to');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logRoute('REMOVE: ${_extractRouteData(route)}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final oldR = _extractRouteData(oldRoute);
    final newR = _extractRouteData(newRoute);
    logRoute('REPLACE: $oldR →\n      └─ $newR');
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logRoute('TAB INIT: ${_extractTabRouteData(route)}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    final from = _extractTabRouteData(previousRoute);
    final to = _extractTabRouteData(route);
    logRoute('TAB CHANGE: $from → $to');
  }
}
