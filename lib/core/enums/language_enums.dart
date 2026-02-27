import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

enum Language {
  english('en'),
  japanese('ja');

  const Language(this.value);
  final String value;

  String get mobileCode => value;

  String get backendCode {
    switch (this) {
      case Language.english:
        return 'en-US';
      case Language.japanese:
        return 'ja-JP';
    }
  }

  // * Convert dari backend code ke enum
  static Language fromBackendCode(String code) {
    switch (code) {
      case 'en-US':
        return Language.english;
      case 'ja-JP':
        return Language.japanese;
      default:
        return Language.english; // * Fallback ke english
    }
  }

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case Language.english:
        return l10n.enumLanguageEnglish;
      case Language.japanese:
        return l10n.enumLanguageJapanese;
    }
  }

  IconData get icon {
    switch (this) {
      case Language.english:
      case Language.japanese:
        return Icons.language;
    }
  }
}
