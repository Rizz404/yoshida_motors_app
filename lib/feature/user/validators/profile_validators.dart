import 'package:form_builder_validators/form_builder_validators.dart';

/// Validators untuk Profile Screen
class ProfileValidators {
  ProfileValidators._();

  /// Validator untuk full name
  static String? Function(String?) fullName() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Full name is required'),
    ]);
  }

  /// Validator untuk email (optional)
  static String? Function(String?) email() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.email(),
    ]);
  }

  /// Validator untuk address
  static String? Function(String?) address() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Address is required'),
    ]);
  }
}
