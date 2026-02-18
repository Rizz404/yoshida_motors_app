import 'package:car_rongsok_app/core/router/router_refresh_listenable.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider untuk AppRouter instance
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

/// Provider untuk RouterRefreshListenable
final routerRefreshProvider = Provider<RouterRefreshListenable>((ref) {
  return RouterRefreshListenable(ref);
});
