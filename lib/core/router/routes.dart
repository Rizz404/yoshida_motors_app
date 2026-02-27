import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/app_transitions.dart';
import 'package:car_rongsok_app/di/auth_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/appraisal_result_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/camera_capture_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/edit_appraisal_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/list_appraisals_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/photo_category_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/summary_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/vehicle_info_screen.dart';
import 'package:car_rongsok_app/feature/auth/screens/login_screen.dart';
import 'package:car_rongsok_app/feature/auth/screens/register_screen.dart';
import 'package:car_rongsok_app/feature/home/screens/home_screen.dart';
import 'package:car_rongsok_app/feature/notification/screens/list_notifications_screen.dart';
import 'package:car_rongsok_app/feature/user/providers/user_provider.dart';
import 'package:car_rongsok_app/feature/user/screens/profile_screen.dart';
import 'package:car_rongsok_app/shared/widgets/app_drawer.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:car_rongsok_app/shared/widgets/app_shell.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'routes.gr.dart';

// ==================== SHELL SCREEN ====================

@RoutePage()
class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final user = profileAsync.value?.user;
    final userName = user?.name ?? 'User';
    final photoUrl = user?.profilePhoto;

    final initials = userName.isNotEmpty
        ? userName
              .trim()
              .split(RegExp(r'\s+'))
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .take(2)
              .join()
        : 'U';

    return AutoTabsRouter(
      routes: const [HomeRoute(), ProfileRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final isHome = tabsRouter.activeIndex == 0;

        return Scaffold(
          appBar: CustomAppBar(
            backgroundColor: context.colorScheme.primary,
            titleSpacing: 0,
            titleWidget: Row(
              children: [
                if (isHome) ...[
                  const AppImage(
                    assetPath: 'assets/images/app-icon.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                ],
                AppText(
                  isHome ? 'Yoshida Motors' : 'My Profile',
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textOnPrimary,
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: photoUrl != null && photoUrl.isNotEmpty
                      ? AppImage(
                          imageUrl: photoUrl,
                          width: 32,
                          height: 32,
                          shape: ImageShape.circle,
                        )
                      : CircleAvatar(
                          radius: 16,
                          backgroundColor: context.colorScheme.surface,
                          child: AppText(
                            initials,
                            style: AppTextStyle.bodyMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                ),
              ),
            ],
          ),
          body: child,
          drawer: const AppDrawer(),
          bottomNavigationBar: AppBottomNav(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}

// ==================== AUTH GUARD ====================

class AuthGuard extends AutoRouteGuard {
  final Ref _ref;

  AuthGuard(this._ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authState = _ref.read(authNotifierProvider);

    // * Jangan block kalau masih loading
    if (authState.isLoading) {
      resolver.next(true);
      return;
    }

    final currentAuthState = authState.whenOrNull(data: (s) => s);
    final isAuthenticated =
        currentAuthState?.status == AuthStatus.authenticated;

    if (isAuthenticated) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(const LoginRoute());
    }
  }
}

// ==================== APP ROUTER ====================

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final Ref _ref;

  AppRouter(this._ref);

  @override
  List<AutoRoute> get routes => [
    // ==================== AUTH ROUTES (no guard) ====================
    CustomRoute<void>(
      page: LoginRoute.page,
      path: '/auth/login',
      initial: true,
      transitionsBuilder: AppTransitions.noTransition,
    ),
    CustomRoute<void>(
      page: RegisterRoute.page,
      path: '/auth/register',
      transitionsBuilder: AppTransitions.noTransition,
    ),

    // ==================== SHELL (TAB) ROUTES ====================
    AutoRoute(
      page: AppShellRoute.page,
      path: '/',
      guards: [AuthGuard(_ref)],
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),

    // ==================== APPRAISAL ROUTES ====================
    CustomRoute<void>(
      page: VehicleInfoRoute.page,
      path: '/appraisal/vehicle-info',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute<void>(
      page: PhotoCategoryRoute.page,
      path: '/appraisal/photo-category',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute<void>(
      page: CameraCaptureRoute.page,
      path: '/appraisal/camera-capture',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromBottom,
      duration: const Duration(milliseconds: 350),
    ),
    CustomRoute<void>(
      page: SummaryRoute.page,
      path: '/appraisal/summary',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute<void>(
      page: ListAppraisalsRoute.page,
      path: '/appraisal/list',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute<void>(
      page: ListNotificationsRoute.page,
      path: '/notification/list',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute<void>(
      page: AppraisalResultRoute.page,
      path: '/appraisal/result',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute<void>(
      page: EditAppraisalRoute.page,
      path: '/appraisal/edit/:id',
      guards: [AuthGuard(_ref)],
      transitionsBuilder: AppTransitions.slideFromRight,
      duration: const Duration(milliseconds: 300),
    ),
  ];
}
