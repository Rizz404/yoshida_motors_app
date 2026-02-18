import 'package:car_rongsok_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// * Global navigator key untuk akses context di luar widget tree
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

extension LocalizationExtension on BuildContext {
  L10n get l10n => L10n.of(this)!;

  String get locale => Localizations.localeOf(this).languageCode;

  bool get isEnglish => locale == 'en';
  bool get isIndonesian => locale == 'id';
  bool get isJapanese => locale == 'ja';

  // * Static helper for usage without context (e.g. Enums)
  // * Requires navigatorKey to be initialized
  static L10n get current {
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw Exception(
        'Navigator context is null. Ensure router is initialized.',
      );
    }
    return L10n.of(context)!;
  }
}
