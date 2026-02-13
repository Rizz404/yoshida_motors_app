import 'package:car_rongsok_app/core/router/router_refresh_listenable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// * GoRouter configuration untuk aplikasi Sigma Asset
/// * Menggunakan static GlobalKeys untuk refreshListenable pattern
class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();
  factory AppRouter() => _instance;

  // * Static keys untuk mendukung refreshListenable tanpa GlobalKey conflict
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;
  static final GlobalKey<NavigatorState> _userShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'userShell');
  static final GlobalKey<NavigatorState> _adminShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'adminShell');
  static final GlobalKey<NavigatorState> _staffShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'staffShell');

  // ==================== TRANSITION HELPERS ====================

  /// * Slide from right - untuk detail screens (iOS-style)
  /// * Memberikan context navigasi yang jelas: "going deeper"
  static CustomTransitionPage _slideFromRight({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// * Slide from bottom - untuk form/upsert screens (modal-style)
  /// * Memberikan kesan "action modal" untuk create/edit
  static CustomTransitionPage _slideFromBottom({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// * Fade + Scale - untuk profile updates (smooth & elegant)
  /// * Memberikan kesan premium untuk personal actions
  static CustomTransitionPage _fadeScale({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOut;

        var fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        var scaleTween = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
    );
  }

  /// * Create GoRouter instance dengan refreshListenable
  GoRouter createRouter(Ref ref) {
    final authRouterNotifier = RouterRefreshListenable(ref);

    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: _getInitialLocation(ref),
      debugLogDiagnostics: true,
      refreshListenable: authRouterNotifier,
      redirect: (context, state) => _handleRedirect(ref, state),
      routes: routes,
    );
  }

  /// * Tentukan initial location berdasarkan auth state
  String _getInitialLocation(Ref ref) {
    final authState = ref.read(authNotifierProvider);

    // * Kalau masih loading, default ke login (native splash masih tampil)
    if (authState.isLoading) {
      return RouteConstant.login;
    }

    final currentAuthState = authState.valueOrNull;
    final isAuthenticated =
        currentAuthState?.status == AuthStatus.authenticated;
    final isAdmin = currentAuthState?.user?.role == UserRole.admin;
    final isStaff = currentAuthState?.user?.role == UserRole.staff;

    if (!isAuthenticated) {
      return RouteConstant.login;
    }

    if (isAdmin) {
      return RouteConstant.adminDashboard;
    }

    if (isStaff) {
      return RouteConstant.staffDashboard;
    }

    return RouteConstant.home;
  }

  /// * Handle redirect logic berdasarkan auth state
  String? _handleRedirect(Ref ref, GoRouterState state) {
    final authState = ref.read(authNotifierProvider);

    // * Jangan redirect apapun kalau masih loading (native splash masih tampil)
    if (authState.isLoading) {
      return null;
    }

    final currentAuthState = authState.valueOrNull;
    final currentIsAuthenticated =
        currentAuthState?.status == AuthStatus.authenticated;
    final currentIsAdmin = currentAuthState?.user?.role == UserRole.admin;
    final currentIsStaff = currentAuthState?.user?.role == UserRole.staff;

    final isGoingToAuth = state.matchedLocation.startsWith('/auth');
    final isGoingToAdmin = state.matchedLocation.startsWith('/admin');
    final isGoingToStaff = state.matchedLocation.startsWith('/staff');

    if (!currentIsAuthenticated && !isGoingToAuth) {
      return RouteConstant.login;
    }

    if (currentIsAuthenticated && isGoingToAuth) {
      if (currentIsAdmin) {
        return RouteConstant.adminDashboard;
      }
      if (currentIsStaff) {
        return RouteConstant.staffDashboard;
      }
      return RouteConstant.home;
    }

    if (!currentIsAdmin && isGoingToAdmin) {
      return RouteConstant.home;
    }

    if (!currentIsStaff && isGoingToStaff) {
      return RouteConstant.home;
    }

    return null;
  }

  List<RouteBase> get routes => [
    // ==================== AUTH ROUTES ====================
    GoRoute(
      path: RouteConstant.login,
      name: PageKeyConstant.login,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
      path: RouteConstant.register,
      name: PageKeyConstant.register,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const RegisterScreen()),
    ),
    GoRoute(
      path: RouteConstant.forgotPassword,
      name: PageKeyConstant.forgotPassword,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.verifyResetCode,
      name: PageKeyConstant.verifyResetCode,
      pageBuilder: (context, state) {
        final email = state.extra as String? ?? '';
        return NoTransitionPage(
          key: state.pageKey,
          child: VerifyResetCodeScreen(email: email),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.resetPassword,
      name: PageKeyConstant.resetPassword,
      pageBuilder: (context, state) {
        final params = state.extra as Map<String, dynamic>? ?? {};
        final email = params['email'] as String? ?? '';
        final resetToken = params['resetToken'] as String? ?? '';
        return NoTransitionPage(
          key: state.pageKey,
          child: ResetPasswordScreen(email: email, resetToken: resetToken),
        );
      },
    ),

    // ==================== USER SHELL ====================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return UserShell(navigationShell: navigationShell);
      },
      branches: [
        // * Branch 1: Home
        StatefulShellBranch(
          navigatorKey: _userShellNavigatorKey,
          routes: [
            GoRoute(
              path: RouteConstant.home,
              name: PageKeyConstant.home,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),

        // * Branch 2: Scan Asset (User)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstant.scanAsset,
              name: PageKeyConstant.scanAsset,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ScanAssetScreen()),
            ),
          ],
        ),

        // * Branch 3: User Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstant.userDetailProfile,
              name: PageKeyConstant.userDetailProfile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UserDetailProfileScreen()),
            ),
          ],
        ),
      ],
    ),

    // ==================== USER SPECIFIC ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.myAssets,
      name: PageKeyConstant.myAssets,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const MyListAssetsScreen()),
    ),
    GoRoute(
      path: RouteConstant.myNotifications,
      name: PageKeyConstant.myNotifications,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const MyListNotificationsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.myIssueReports,
      name: PageKeyConstant.myIssueReports,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const MyListIssueReportsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.userUpdateProfile,
      name: PageKeyConstant.userUpdateProfile,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserUpdateProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.userChangePassword,
      name: PageKeyConstant.userChangePassword,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserChangePasswordScreen(),
        );
      },
    ),

    // ==================== SHARED DETAIL ROUTES (Accessible by both User, Staff & Admin) ====================
    GoRoute(
      path: RouteConstant.assetDetail,
      name: PageKeyConstant.assetDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final asset = state.extra as Asset?;
        // * Support both path param (/asset/:assetId) and query param (?id=xxx)
        final id =
            state.pathParameters['assetId'] ?? state.uri.queryParameters['id'];
        final assetTag = state.uri.queryParameters['assetTag'];
        return _slideFromRight(
          key: state.pageKey,
          child: AssetDetailScreen(asset: asset, id: id, assetTag: assetTag),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.assetMovementDetail,
      name: PageKeyConstant.assetMovementDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovement = state.extra as AssetMovement?;
        // * Support both path param (/asset-movement/:movementId) and query param (?id=xxx)
        final id =
            state.pathParameters['movementId'] ??
            state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: AssetMovementDetailScreen(
            assetMovement: assetMovement,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.categoryDetail,
      name: PageKeyConstant.categoryDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final category = state.extra as Category?;
        // * Support both path param (/category/:categoryId) and query param (?id=xxx)
        final id =
            state.pathParameters['categoryId'] ??
            state.uri.queryParameters['id'];
        final categoryCode = state.uri.queryParameters['categoryCode'];
        return _slideFromRight(
          key: state.pageKey,
          child: CategoryDetailScreen(
            category: category,
            id: id,
            categoryCode: categoryCode,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.locationDetail,
      name: PageKeyConstant.locationDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final location = state.extra as Location?;
        // * Support both path param (/location/:locationId) and query param (?id=xxx)
        final id =
            state.pathParameters['locationId'] ??
            state.uri.queryParameters['id'];
        final locationCode = state.uri.queryParameters['locationCode'];
        return _slideFromRight(
          key: state.pageKey,
          child: LocationDetailScreen(
            location: location,
            id: id,
            locationCode: locationCode,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.maintenanceScheduleDetail,
      name: PageKeyConstant.maintenanceScheduleDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceSchedule = state.extra as MaintenanceSchedule?;
        // * Support both path param (/maintenance-schedule/:maintenanceId) and query param (?id=xxx)
        final id =
            state.pathParameters['maintenanceId'] ??
            state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: MaintenanceScheduleDetailScreen(
            maintenanceSchedule: maintenanceSchedule,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.maintenanceRecordDetail,
      name: PageKeyConstant.maintenanceRecordDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceRecord = state.extra as MaintenanceRecord?;
        // * Support both path param (/maintenance-record/:maintenanceId) and query param (?id=xxx)
        final id =
            state.pathParameters['maintenanceId'] ??
            state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: MaintenanceRecordDetailScreen(
            maintenanceRecord: maintenanceRecord,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.issueReportUpsert,
      name: PageKeyConstant.issueReportUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final issueReportId = state.uri.queryParameters['issueReportId'];
        final extra = state.extra;
        IssueReport? issueReport;
        Asset? prePopulatedAsset;

        if (extra is IssueReport) {
          issueReport = extra;
        } else if (extra is Map<String, dynamic>) {
          issueReport = extra['issueReport'] as IssueReport?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: IssueReportUpsertScreen(
            issueReport: issueReport,
            issueReportId: issueReportId,
            prePopulatedAsset: prePopulatedAsset,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.issueReportDetail,
      name: PageKeyConstant.issueReportDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final issueReport = state.extra as IssueReport?;
        // * Support both path param (/issue-report/:issueReportId) and query param (?id=xxx)
        final id =
            state.pathParameters['issueReportId'] ??
            state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: IssueReportDetailScreen(issueReport: issueReport, id: id),
        );
      },
    ),

    GoRoute(
      path: RouteConstant.notificationDetail,
      name: PageKeyConstant.notificationDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final notification = state.extra as notification_entity.Notification?;
        // * Support both path param (/notification/:notificationId) and query param (?id=xxx)
        final id =
            state.pathParameters['notificationId'] ??
            state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: NotificationDetailScreen(notification: notification, id: id),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.scanLogDetail,
      name: PageKeyConstant.scanLogDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final scanLog = state.extra as ScanLog?;
        // * Support both path param (/scan-log/:scanLogId) and query param (?id=xxx)
        final id =
            state.pathParameters['scanLogId'] ??
            state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: ScanLogDetailScreen(scanLog: scanLog, id: id),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.userDetail,
      name: PageKeyConstant.userDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final user = state.extra as User?;
        // * Support both path param (/user/:userId) and query param (?id=xxx)
        final id =
            state.pathParameters['userId'] ?? state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: UserDetailScreen(user: user, id: id),
        );
      },
    ),

    // ==================== ADMIN SHELL ====================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdminShell(navigationShell: navigationShell);
      },
      branches: [
        // * Branch 1: Admin Dashboard
        StatefulShellBranch(
          navigatorKey: _adminShellNavigatorKey,
          routes: [
            GoRoute(
              path: RouteConstant.adminDashboard,
              name: PageKeyConstant.adminDashboard,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DashboardScreen()),
            ),
          ],
        ),

        // * Branch 2: Scan Asset (Admin)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstant.adminScanAsset,
              name: PageKeyConstant.adminScanAsset,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ScanAssetScreen()),
            ),
          ],
        ),

        // * Branch 3: Admin Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstant.adminUserDetailProfile,
              name: PageKeyConstant.adminUserDetailProfile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UserDetailProfileScreen()),
            ),
          ],
        ),
      ],
    ),

    // ==================== STAFF SHELL ====================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return StaffShell(navigationShell: navigationShell);
      },
      branches: [
        // * Branch 1: Staff Dashboard
        StatefulShellBranch(
          navigatorKey: _staffShellNavigatorKey,
          routes: [
            GoRoute(
              path: RouteConstant.staffDashboard,
              name: PageKeyConstant.staffDashboard,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DashboardScreen()),
            ),
          ],
        ),

        // * Branch 2: Scan Asset (Staff)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstant.staffScanAsset,
              name: PageKeyConstant.staffScanAsset,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ScanAssetScreen()),
            ),
          ],
        ),

        // * Branch 3: Staff Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstant.staffUserDetailProfile,
              name: PageKeyConstant.staffUserDetailProfile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UserDetailProfileScreen()),
            ),
          ],
        ),
      ],
    ),

    // ==================== ADMIN LIST ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.adminAssets,
      name: PageKeyConstant.adminAssets,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListAssetsScreen()),
    ),
    GoRoute(
      path: RouteConstant.adminAssetMovements,
      name: PageKeyConstant.adminAssetMovements,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListAssetMovementsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.adminCategories,
      name: PageKeyConstant.adminCategories,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListCategoriesScreen()),
    ),
    GoRoute(
      path: RouteConstant.adminLocations,
      name: PageKeyConstant.adminLocations,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListLocationsScreen()),
    ),
    GoRoute(
      path: RouteConstant.adminUsers,
      name: PageKeyConstant.adminUsers,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListUsersScreen()),
    ),
    GoRoute(
      path: RouteConstant.adminMaintenanceSchedules,
      name: PageKeyConstant.adminMaintenanceSchedules,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListMaintenanceSchedulesScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.adminMaintenanceRecords,
      name: PageKeyConstant.adminMaintenanceRecords,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListMaintenanceRecordsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.adminIssueReports,
      name: PageKeyConstant.adminIssueReports,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListIssueReportsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.adminScanLogs,
      name: PageKeyConstant.adminScanLogs,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListScanLogsScreen()),
    ),
    GoRoute(
      path: RouteConstant.adminNotifications,
      name: PageKeyConstant.adminNotifications,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListNotificationsScreen(),
      ),
    ),

    // ==================== ADMIN UPSERT ROUTES (Outside shell) ====================
    // * Untuk saat ini query params tidak dipakai dulu
    GoRoute(
      path: RouteConstant.adminAssetUpsert,
      name: PageKeyConstant.adminAssetUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetId = state.uri.queryParameters['assetId'];
        Asset? asset;
        Asset? copyFromAsset;

        // * Handle both Asset and Map<String, dynamic> in extra
        if (state.extra is Asset) {
          asset = state.extra as Asset;
        } else if (state.extra is Map<String, dynamic>) {
          copyFromAsset =
              (state.extra as Map<String, dynamic>)['copyFromAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: AssetUpsertScreen(
            asset: asset,
            assetId: assetId,
            copyFromAsset: copyFromAsset,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminAssetMovementUpsertForLocation,
      name: PageKeyConstant.adminAssetMovementUpsertForLocation,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovementId = state.uri.queryParameters['movementId'];
        final extra = state.extra;
        AssetMovement? assetMovement;
        AssetMovement? copyFromMovement;
        Asset? prePopulatedAsset;

        if (extra is AssetMovement) {
          assetMovement = extra;
        } else if (extra is Map<String, dynamic>) {
          assetMovement = extra['assetMovement'] as AssetMovement?;
          copyFromMovement = extra['copyFromMovement'] as AssetMovement?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: AssetMovementUpsertForLocationScreen(
            assetMovement: assetMovement,
            assetMovementId: assetMovementId,
            prePopulatedAsset: prePopulatedAsset,
            copyFromMovement: copyFromMovement,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminAssetMovementUpsertForUser,
      name: PageKeyConstant.adminAssetMovementUpsertForUser,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovementId = state.uri.queryParameters['movementId'];
        final extra = state.extra;
        AssetMovement? assetMovement;
        AssetMovement? copyFromMovement;
        Asset? prePopulatedAsset;

        if (extra is AssetMovement) {
          assetMovement = extra;
        } else if (extra is Map<String, dynamic>) {
          assetMovement = extra['assetMovement'] as AssetMovement?;
          copyFromMovement = extra['copyFromMovement'] as AssetMovement?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: AssetMovementUpsertForUserScreen(
            assetMovement: assetMovement,
            assetMovementId: assetMovementId,
            prePopulatedAsset: prePopulatedAsset,
            copyFromMovement: copyFromMovement,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminCategoryUpsert,
      name: PageKeyConstant.adminCategoryUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'];
        Category? category;
        Category? copyFromCategory;

        // * Handle both Category and Map<String, dynamic> in extra
        if (state.extra is Category) {
          category = state.extra as Category;
        } else if (state.extra is Map<String, dynamic>) {
          copyFromCategory =
              (state.extra as Map<String, dynamic>)['copyFromCategory']
                  as Category?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: CategoryUpsertScreen(
            category: category,
            categoryId: categoryId,
            copyFromCategory: copyFromCategory,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminLocationUpsert,
      name: PageKeyConstant.adminLocationUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final locationId = state.uri.queryParameters['locationId'];
        Location? location;
        Location? copyFromLocation;

        // * Handle both Location and Map<String, dynamic> in extra
        if (state.extra is Location) {
          location = state.extra as Location;
        } else if (state.extra is Map<String, dynamic>) {
          copyFromLocation =
              (state.extra as Map<String, dynamic>)['copyFromLocation']
                  as Location?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: LocationUpsertScreen(
            location: location,
            locationId: locationId,
            copyFromLocation: copyFromLocation,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminUserUpsert,
      name: PageKeyConstant.adminUserUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final userId = state.uri.queryParameters['userId'];
        User? user;
        User? copyFromUser;

        // * Handle both User and Map<String, dynamic> in extra
        if (state.extra is User) {
          user = state.extra as User;
        } else if (state.extra is Map<String, dynamic>) {
          copyFromUser =
              (state.extra as Map<String, dynamic>)['copyFromUser'] as User?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: UserUpsertScreen(
            user: user,
            userId: userId,
            copyFromUser: copyFromUser,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminMaintenanceScheduleUpsert,
      name: PageKeyConstant.adminMaintenanceScheduleUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceId = state.uri.queryParameters['maintenanceId'];
        final extra = state.extra;
        MaintenanceSchedule? maintenanceSchedule;
        MaintenanceSchedule? copyFromSchedule;
        Asset? prePopulatedAsset;

        if (extra is MaintenanceSchedule) {
          maintenanceSchedule = extra;
        } else if (extra is Map<String, dynamic>) {
          maintenanceSchedule =
              extra['maintenanceSchedule'] as MaintenanceSchedule?;
          copyFromSchedule = extra['copyFromSchedule'] as MaintenanceSchedule?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: MaintenanceScheduleUpsertScreen(
            maintenanceSchedule: maintenanceSchedule,
            maintenanceId: maintenanceId,
            prePopulatedAsset: prePopulatedAsset,
            copyFromSchedule: copyFromSchedule,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminMaintenanceRecordUpsert,
      name: PageKeyConstant.adminMaintenanceRecordUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceRecordId =
            state.uri.queryParameters['maintenanceRecordId'];
        final extra = state.extra;
        MaintenanceRecord? maintenanceRecord;
        MaintenanceRecord? copyFromRecord;
        Asset? prePopulatedAsset;

        if (extra is MaintenanceRecord) {
          maintenanceRecord = extra;
        } else if (extra is Map<String, dynamic>) {
          maintenanceRecord = extra['maintenanceRecord'] as MaintenanceRecord?;
          copyFromRecord = extra['copyFromRecord'] as MaintenanceRecord?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: MaintenanceRecordUpsertScreen(
            maintenanceRecord: maintenanceRecord,
            maintenanceRecordId: maintenanceRecordId,
            prePopulatedAsset: prePopulatedAsset,
            copyFromRecord: copyFromRecord,
          ),
        );
      },
    ),

    // ==================== ADMIN SPECIFIC ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.adminUserUpdateProfile,
      name: PageKeyConstant.adminUserUpdateProfile,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserUpdateProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminUserChangePassword,
      name: PageKeyConstant.adminUserChangePassword,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserChangePasswordScreen(),
        );
      },
    ),

    // ==================== STAFF LIST ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.staffAssets,
      name: PageKeyConstant.staffAssets,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListAssetsScreen()),
    ),
    GoRoute(
      path: RouteConstant.staffAssetMovements,
      name: PageKeyConstant.staffAssetMovements,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListAssetMovementsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.staffMaintenanceSchedules,
      name: PageKeyConstant.staffMaintenanceSchedules,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListMaintenanceSchedulesScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.staffMaintenanceRecords,
      name: PageKeyConstant.staffMaintenanceRecords,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListMaintenanceRecordsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.staffIssueReports,
      name: PageKeyConstant.staffIssueReports,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListIssueReportsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstant.staffScanLogs,
      name: PageKeyConstant.staffScanLogs,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListScanLogsScreen()),
    ),
    GoRoute(
      path: RouteConstant.staffNotifications,
      name: PageKeyConstant.staffNotifications,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ListNotificationsScreen(),
      ),
    ),

    // ==================== STAFF UPSERT ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.staffAssetUpsert,
      name: PageKeyConstant.staffAssetUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetId = state.uri.queryParameters['assetId'];
        final asset = state.extra as Asset?;
        return _slideFromBottom(
          key: state.pageKey,
          child: AssetUpsertScreen(asset: asset, assetId: assetId),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.staffAssetMovementUpsertForLocation,
      name: PageKeyConstant.staffAssetMovementUpsertForLocation,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovementId = state.uri.queryParameters['movementId'];
        final extra = state.extra;
        AssetMovement? assetMovement;
        Asset? prePopulatedAsset;

        if (extra is AssetMovement) {
          assetMovement = extra;
        } else if (extra is Map<String, dynamic>) {
          assetMovement = extra['assetMovement'] as AssetMovement?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: AssetMovementUpsertForLocationScreen(
            assetMovement: assetMovement,
            assetMovementId: assetMovementId,
            prePopulatedAsset: prePopulatedAsset,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.staffAssetMovementUpsertForUser,
      name: PageKeyConstant.staffAssetMovementUpsertForUser,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovementId = state.uri.queryParameters['movementId'];
        final extra = state.extra;
        AssetMovement? assetMovement;
        Asset? prePopulatedAsset;

        if (extra is AssetMovement) {
          assetMovement = extra;
        } else if (extra is Map<String, dynamic>) {
          assetMovement = extra['assetMovement'] as AssetMovement?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: AssetMovementUpsertForUserScreen(
            assetMovement: assetMovement,
            assetMovementId: assetMovementId,
            prePopulatedAsset: prePopulatedAsset,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.staffMaintenanceScheduleUpsert,
      name: PageKeyConstant.staffMaintenanceScheduleUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceId = state.uri.queryParameters['maintenanceId'];
        final extra = state.extra;
        MaintenanceSchedule? maintenanceSchedule;
        Asset? prePopulatedAsset;

        if (extra is MaintenanceSchedule) {
          maintenanceSchedule = extra;
        } else if (extra is Map<String, dynamic>) {
          maintenanceSchedule =
              extra['maintenanceSchedule'] as MaintenanceSchedule?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: MaintenanceScheduleUpsertScreen(
            maintenanceSchedule: maintenanceSchedule,
            maintenanceId: maintenanceId,
            prePopulatedAsset: prePopulatedAsset,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.staffMaintenanceRecordUpsert,
      name: PageKeyConstant.staffMaintenanceRecordUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceRecordId =
            state.uri.queryParameters['maintenanceRecordId'];
        final extra = state.extra;
        MaintenanceRecord? maintenanceRecord;
        Asset? prePopulatedAsset;

        if (extra is MaintenanceRecord) {
          maintenanceRecord = extra;
        } else if (extra is Map<String, dynamic>) {
          maintenanceRecord = extra['maintenanceRecord'] as MaintenanceRecord?;
          prePopulatedAsset = extra['prePopulatedAsset'] as Asset?;
        }

        return _slideFromBottom(
          key: state.pageKey,
          child: MaintenanceRecordUpsertScreen(
            maintenanceRecord: maintenanceRecord,
            maintenanceRecordId: maintenanceRecordId,
            prePopulatedAsset: prePopulatedAsset,
          ),
        );
      },
    ),

    // ==================== STAFF SPECIFIC ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.staffUserUpdateProfile,
      name: PageKeyConstant.staffUserUpdateProfile,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserUpdateProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.staffUserChangePassword,
      name: PageKeyConstant.staffUserChangePassword,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserChangePasswordScreen(),
        );
      },
    ),
  ];

  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  GlobalKey<NavigatorState> get userShellNavigatorKey => _userShellNavigatorKey;
  GlobalKey<NavigatorState> get adminShellNavigatorKey =>
      _adminShellNavigatorKey;
  GlobalKey<NavigatorState> get staffShellNavigatorKey =>
      _staffShellNavigatorKey;
}
