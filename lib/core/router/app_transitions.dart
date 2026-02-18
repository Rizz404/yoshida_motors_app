import 'package:flutter/material.dart';

/// Custom transition builders untuk app routing
class AppTransitions {
  AppTransitions._();

  /// * Slide from right - untuk detail screens (iOS-style)
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// * Slide from bottom - untuk form/upsert screens (modal-style)
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// * Fade + Scale - untuk profile updates (smooth & elegant)
  static Widget fadeScale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeOut;

    final fadeTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: curve));

    final scaleTween = Tween<double>(
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
  }

  /// * No transition - untuk instant navigation (auth screens)
  static Widget noTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
