// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $loginRoute,
      $registerRoute,
      $homeRoute,
      $profileRoute,
      $appraisalHomeRoute,
      $vehicleInfoRoute,
      $photoCategoryRoute,
      $cameraCaptureRoute,
      $summaryRoute,
      $appraisalResultRoute,
    ];

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/auth/login',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/auth/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute => GoRouteData.$route(
      path: '/auth/register',
      name: 'register',
      factory: $RegisterRouteExtension._fromState,
    );

extension $RegisterRouteExtension on RegisterRoute {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  String get location => GoRouteData.$location(
        '/auth/register',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      name: 'home',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      name: 'profile',
      factory: $ProfileRouteExtension._fromState,
    );

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $appraisalHomeRoute => GoRouteData.$route(
      path: '/appraisal',
      name: 'appraisal-home',
      factory: $AppraisalHomeRouteExtension._fromState,
    );

extension $AppraisalHomeRouteExtension on AppraisalHomeRoute {
  static AppraisalHomeRoute _fromState(GoRouterState state) =>
      const AppraisalHomeRoute();

  String get location => GoRouteData.$location(
        '/appraisal',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $vehicleInfoRoute => GoRouteData.$route(
      path: '/appraisal/vehicle-info',
      name: 'vehicle-info',
      factory: $VehicleInfoRouteExtension._fromState,
    );

extension $VehicleInfoRouteExtension on VehicleInfoRoute {
  static VehicleInfoRoute _fromState(GoRouterState state) =>
      const VehicleInfoRoute();

  String get location => GoRouteData.$location(
        '/appraisal/vehicle-info',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $photoCategoryRoute => GoRouteData.$route(
      path: '/appraisal/photo-category',
      name: 'photo-category',
      factory: $PhotoCategoryRouteExtension._fromState,
    );

extension $PhotoCategoryRouteExtension on PhotoCategoryRoute {
  static PhotoCategoryRoute _fromState(GoRouterState state) =>
      const PhotoCategoryRoute();

  String get location => GoRouteData.$location(
        '/appraisal/photo-category',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cameraCaptureRoute => GoRouteData.$route(
      path: '/appraisal/camera-capture',
      name: 'camera-capture',
      factory: $CameraCaptureRouteExtension._fromState,
    );

extension $CameraCaptureRouteExtension on CameraCaptureRoute {
  static CameraCaptureRoute _fromState(GoRouterState state) =>
      CameraCaptureRoute(
        category: state.uri.queryParameters['category'],
      );

  String get location => GoRouteData.$location(
        '/appraisal/camera-capture',
        queryParams: {
          if (category != null) 'category': category,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $summaryRoute => GoRouteData.$route(
      path: '/appraisal/summary',
      name: 'summary',
      factory: $SummaryRouteExtension._fromState,
    );

extension $SummaryRouteExtension on SummaryRoute {
  static SummaryRoute _fromState(GoRouterState state) => const SummaryRoute();

  String get location => GoRouteData.$location(
        '/appraisal/summary',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $appraisalResultRoute => GoRouteData.$route(
      path: '/appraisal/result',
      name: 'appraisal-result',
      factory: $AppraisalResultRouteExtension._fromState,
    );

extension $AppraisalResultRouteExtension on AppraisalResultRoute {
  static AppraisalResultRoute _fromState(GoRouterState state) =>
      const AppraisalResultRoute();

  String get location => GoRouteData.$location(
        '/appraisal/result',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
