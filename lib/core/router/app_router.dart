import 'package:car_rongsok_app/core/router/router_refresh_listenable.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/di/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Provider untuk GoRouter instance
/// Menggunakan go_router_builder untuk type-safe routing
final goRouterProvider = Provider<GoRouter>((ref) {
  final authRouterNotifier = RouterRefreshListenable(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _getInitialLocation(ref),
    debugLogDiagnostics: true,
    refreshListenable: authRouterNotifier,
    redirect: (context, state) => _handleRedirect(ref, state),
    routes: $appRoutes,
  );
});

// ==================== GLOBAL NAVIGATOR KEYS ====================

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

// ==================== ROUTER HELPERS ====================

/// Tentukan initial location berdasarkan auth state
String _getInitialLocation(Ref ref) {
  final authState = ref.read(authNotifierProvider);

  // * Kalau masih loading, default ke login (native splash masih tampil)
  if (authState.isLoading) {
    return const LoginRoute().location;
  }

  final currentAuthState = authState.whenOrNull(data: (state) => state);
  final isAuthenticated = currentAuthState?.status == AuthStatus.authenticated;

  if (!isAuthenticated) {
    return const LoginRoute().location;
  }

  // * Authenticated users go to home
  return const HomeRoute().location;
}

/// Handle redirect logic berdasarkan auth state
String? _handleRedirect(Ref ref, GoRouterState state) {
  final authState = ref.read(authNotifierProvider);

  // * Jangan redirect apapun kalau masih loading (native splash masih tampil)
  if (authState.isLoading) {
    return null;
  }

  final currentAuthState = authState.whenOrNull(data: (state) => state);
  final currentIsAuthenticated =
      currentAuthState?.status == AuthStatus.authenticated;

  final isGoingToAuth = state.matchedLocation.startsWith('/auth');

  // * Not authenticated and not going to auth? Redirect to login
  if (!currentIsAuthenticated && !isGoingToAuth) {
    return const LoginRoute().location;
  }

  // * Authenticated and going to auth? Redirect to home
  if (currentIsAuthenticated && isGoingToAuth) {
    return const HomeRoute().location;
  }

  return null;
}
