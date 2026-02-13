import 'package:car_rongsok_app/core/constants/storage_key_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeStorageService {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> removeThemeMode();
}

class ThemeStorageServiceImpl implements ThemeStorageService {
  final SharedPreferences _sharedPreferences;

  ThemeStorageServiceImpl(this._sharedPreferences);

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeModeString = _sharedPreferences.getString(
      StorageKeyConstant.themeModeKey,
    );

    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
          return ThemeMode.system;
        default:
          return ThemeMode.system;
      }
    }

    return ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await _sharedPreferences.setString(
      StorageKeyConstant.themeModeKey,
      themeModeString,
    );
  }

  @override
  Future<void> removeThemeMode() async {
    await _sharedPreferences.remove(StorageKeyConstant.themeModeKey);
  }
}
