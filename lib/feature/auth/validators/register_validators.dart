import 'package:form_builder_validators/form_builder_validators.dart';

/// Validators untuk Register Screen
class RegisterValidators {
  RegisterValidators._();

  /// Validator untuk phone number (format internasional)
  /// Contoh: +628123456789
  static String? Function(String?) phoneNumber() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.match(
        RegExp(r'^\+[1-9]\d{1,14}$'),
        errorText:
            'Invalid format. Use international format (e.g., +628xxxxxxxxx)',
      ),
    ]);
  }

  /// Validator untuk OTP code (6 digit)
  static String? Function(String?) otpCode() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(6),
      FormBuilderValidators.maxLength(6),
      FormBuilderValidators.numeric(),
    ]);
  }

  /// Validator untuk email (optional)
  static String? Function(String?) email() {
    return FormBuilderValidators.compose([FormBuilderValidators.email()]);
  }

  /// Validator untuk email (required)
  static String? Function(String?) emailRequired() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.email(),
    ]);
  }

  /// Validator untuk password
  static String? Function(String?) password() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(
        6,
        errorText: 'Password must be at least 6 characters',
      ),
    ]);
  }

  /// Validator untuk confirm password
  static String? Function(String?) confirmPassword(String? password) {
    return (value) {
      if (value == null || value.isEmpty) return 'Confirm password is required';
      if (value != password) return 'Passwords do not match';
      return null;
    };
  }

  /// Validator untuk full name (optional)
  static String? Function(String?) fullName() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.maxLength(100, errorText: 'Name is too long'),
    ]);
  }

  /// Validator untuk address (optional)
  static String? Function(String?) address() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.maxLength(255, errorText: 'Address is too long'),
    ]);
  }
}
