import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom transition builders untuk app routing
/// Mempertahankan transition patterns dari project lama
class AppTransitions {
  AppTransitions._();

  /// * Slide from right - untuk detail screens (iOS-style)
  /// * Memberikan context navigasi yang jelas: "going deeper"
  static CustomTransitionPage<void> slideFromRight({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
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
  static CustomTransitionPage<void> slideFromBottom({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
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
  static CustomTransitionPage<void> fadeScale({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
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
          opacity: fadeTween.animate(animation),
          child: ScaleTransition(
            scale: scaleTween.animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  /// * No transition - untuk instant navigation (auth screens)
  static NoTransitionPage<void> noTransition({
    required LocalKey key,
    required Widget child,
  }) {
    return NoTransitionPage<void>(key: key, child: child);
  }
}

/// Enum untuk menentukan jenis transition yang digunakan
enum TransitionType {
  /// Slide dari kanan (default untuk detail screens)
  slideFromRight,

  /// Slide dari bawah (untuk modal/form screens)
  slideFromBottom,

  /// Fade + Scale (untuk profile/personal screens)
  fadeScale,

  /// No transition (untuk auth screens)
  none,
}
