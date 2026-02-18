import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:flutter/material.dart';

class AppRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logDomain(
      'PUSH: ${previousRoute?.settings.name ?? 'none'} → ${route.settings.name}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logDomain(
      'POP: ${route.settings.name} → ${previousRoute?.settings.name ?? 'none'}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logDomain('REMOVE: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logDomain(
      'REPLACE: ${oldRoute?.settings.name ?? 'none'} → ${newRoute?.settings.name ?? 'none'}',
    );
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logDomain('TAB INIT: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    logDomain('TAB CHANGE: ${previousRoute.name} → ${route.name}');
  }
}
