import 'package:form_builder_validators/form_builder_validators.dart';

/// Validators untuk Vehicle Info Screen
class VehicleInfoValidators {
  VehicleInfoValidators._();

  /// Validator untuk vehicle brand
  static String? Function(String?) vehicleBrand() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Vehicle brand is required'),
    ]);
  }

  /// Validator untuk vehicle model
  static String? Function(String?) vehicleModel() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Vehicle model is required'),
    ]);
  }

  /// Validator untuk license plate
  static String? Function(String?) licensePlate() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'License plate is required'),
    ]);
  }

  /// Validator untuk mileage
  static String? Function(String?) mileage() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Mileage is required'),
      FormBuilderValidators.numeric(errorText: 'Mileage must be a number'),
    ]);
  }

  /// Validator untuk year of manufacture
  static String? Function(String?) yearManufacture() {
    return (val) {
      if (val == null || val.trim().isEmpty) {
        return 'Year is required';
      }
      final year = int.tryParse(val.trim());
      if (year == null || year < 1980 || year > DateTime.now().year) {
        return 'Enter a valid year';
      }
      return null;
    };
  }

  /// Validator untuk description (optional)
  static String? Function(String?) description() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.maxLength(
        500,
        errorText: 'Description is too long',
      ),
    ]);
  }
}
