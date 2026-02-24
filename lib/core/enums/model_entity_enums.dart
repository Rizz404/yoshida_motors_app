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

enum AppraisalStatus {
  draft('draft'),
  submitted('submitted'),
  underReview('under_review'),
  completed('completed');

  const AppraisalStatus(this.value);

  final String value;

  String get label {
    switch (this) {
      case AppraisalStatus.draft:
        return 'Draft';
      case AppraisalStatus.submitted:
        return 'Submitted';
      case AppraisalStatus.underReview:
        return 'Under Review';
      case AppraisalStatus.completed:
        return 'Completed';
    }
  }
}
