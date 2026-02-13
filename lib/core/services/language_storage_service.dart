import 'package:car_rongsok_app/core/constants/storage_key_constant.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:car_rongsok_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LanguageStorageService {
  Future<Locale> getLocale();
  Future<void> setLocale(Locale locale);
  Future<void> removeLocale();
}

class LanguageStorageServiceImpl implements LanguageStorageService {
  final SharedPreferences _sharedPreferences;

  LanguageStorageServiceImpl(this._sharedPreferences);

  @override
  Future<Locale> getLocale() async {
    try {
      final localeString = _sharedPreferences.getString(
        StorageKeyConstant.localeKey,
      );

      if (localeString != null) {
        final parts = localeString.split('_');
        Locale locale;

        if (parts.length == 2) {
          locale = Locale(parts[0], parts[1]);
        } else if (parts.length == 1) {
          locale = Locale(parts[0]);
        } else {
          // * Fallback ke default locale
          final defaultLocale = L10n.supportedLocales.first;
          logData('GET locale', defaultLocale.toString());
          return defaultLocale;
        }

        if (L10n.supportedLocales.contains(locale)) {
          logData('GET locale', locale.toString());
          return locale;
        }
      }

      final defaultLocale = L10n.supportedLocales.first;
      logData('GET locale', defaultLocale.toString());
      return defaultLocale;
    } catch (e, s) {
      logError('Failed to get locale', e, s);
      return L10n.supportedLocales.first;
    }
  }

  @override
  Future<void> setLocale(Locale locale) async {
    try {
      if (L10n.supportedLocales.contains(locale)) {
        await _sharedPreferences.setString(
          StorageKeyConstant.localeKey,
          locale.toString(),
        );
        logData('SAVE locale', locale.toString());
      } else {
        logError('Unsupported locale: $locale');
        throw ArgumentError('Unsupported locale: $locale');
      }
    } catch (e, s) {
      logError('Failed to set locale', e, s);
      rethrow;
    }
  }

  @override
  Future<void> removeLocale() async {
    try {
      await _sharedPreferences.remove(StorageKeyConstant.localeKey);
      logData('REMOVE locale', 'success');
    } catch (e, s) {
      logError('Failed to remove locale', e, s);
    }
  }
}
