import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

enum UserRole {
  admin('admin'),
  user('user');

  const UserRole(this.value);

  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case UserRole.admin:
        return l10n.enumUserRoleAdmin;
      case UserRole.user:
        return l10n.enumUserRoleUser;
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.user:
        return Icons.person;
    }
  }
}
