// Transitions
import 'package:car_rongsok_app/core/router/app_transitions.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/appraisal_result_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/camera_capture_screen.dart';
// Appraisal Screens
import 'package:car_rongsok_app/feature/appraisal/screens/home_screen.dart'
    as appraisal;
import 'package:car_rongsok_app/feature/appraisal/screens/photo_category_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/summary_screen.dart';
import 'package:car_rongsok_app/feature/appraisal/screens/vehicle_info_screen.dart';
// Auth Screens
import 'package:car_rongsok_app/feature/auth/screens/login_screen.dart';
import 'package:car_rongsok_app/feature/auth/screens/register_screen.dart';
// Home Screen
import 'package:car_rongsok_app/feature/home/screens/home_screen.dart';
// User Screens
import 'package:car_rongsok_app/feature/user/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

// ==================== AUTH ROUTES ====================

@TypedGoRoute<LoginRoute>(path: '/auth/login', name: 'login')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.noTransition(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

@TypedGoRoute<RegisterRoute>(path: '/auth/register', name: 'register')
class RegisterRoute extends GoRouteData {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.noTransition(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

// ==================== HOME ROUTES ====================

@TypedGoRoute<HomeRoute>(path: '/', name: 'home')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.noTransition(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

// ==================== USER ROUTES ====================

@TypedGoRoute<ProfileRoute>(path: '/profile', name: 'profile')
class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.fadeScale(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

// ==================== APPRAISAL ROUTES ====================

@TypedGoRoute<AppraisalHomeRoute>(path: '/appraisal', name: 'appraisal-home')
class AppraisalHomeRoute extends GoRouteData {
  const AppraisalHomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const appraisal.HomeScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.slideFromRight(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

@TypedGoRoute<VehicleInfoRoute>(
  path: '/appraisal/vehicle-info',
  name: 'vehicle-info',
)
class VehicleInfoRoute extends GoRouteData {
  const VehicleInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const VehicleInfoScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.slideFromRight(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

@TypedGoRoute<PhotoCategoryRoute>(
  path: '/appraisal/photo-category',
  name: 'photo-category',
)
class PhotoCategoryRoute extends GoRouteData {
  const PhotoCategoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PhotoCategoryScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.slideFromRight(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

@TypedGoRoute<CameraCaptureRoute>(
  path: '/appraisal/camera-capture',
  name: 'camera-capture',
)
class CameraCaptureRoute extends GoRouteData {
  const CameraCaptureRoute({this.category});

  final String? category;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CameraCaptureScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.slideFromBottom(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

@TypedGoRoute<SummaryRoute>(path: '/appraisal/summary', name: 'summary')
class SummaryRoute extends GoRouteData {
  const SummaryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SummaryScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.slideFromRight(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}

@TypedGoRoute<AppraisalResultRoute>(
  path: '/appraisal/result',
  name: 'appraisal-result',
)
class AppraisalResultRoute extends GoRouteData {
  const AppraisalResultRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AppraisalResultScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AppTransitions.slideFromRight(
      key: state.pageKey,
      child: build(context, state),
    );
  }
}
