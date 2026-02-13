import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:car_rongsok_app/core/enums/language_enums.dart';

class LocaleInterceptor extends Interceptor {
  Locale? _currentLocale;

  void updateLocale(Locale locale) {
    _currentLocale = locale;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_currentLocale != null) {
      options.headers['Accept-Language'] = _getLocaleHeaderValue(
        _currentLocale!,
      );
    }
    super.onRequest(options, handler);
  }

  String _getLocaleHeaderValue(Locale locale) {
    try {
      final language = Language.values.firstWhere(
        (e) => e.value == locale.languageCode,
      );
      return language.backendCode;
    } catch (e) {
      return 'en-US';
    }
  }
}
