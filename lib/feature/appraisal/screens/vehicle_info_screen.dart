import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/validators/vehicle_info_validators.dart';
import 'package:car_rongsok_app/feature/appraisal/widgets/appraisal_step_indicator.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class VehicleInfoScreen extends ConsumerStatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  ConsumerState<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends ConsumerState<VehicleInfoScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _onNext() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final formData = _formKey.currentState!.value;

    final mileageString = formData['mileage'] as String?;

    ref
        .read(appraisalFormProvider.notifier)
        .setVehicleInfo(
          brand: (formData['vehicle_brand'] as String).trim(),
          model: (formData['vehicle_model'] as String).trim(),
          year: int.parse((formData['year_manufacture'] as String).trim()),
          licensePlate: (formData['license_plate'] as String?)?.trim(),
          mileage: mileageString != null ? int.tryParse(mileageString) : null,
          description: (formData['description'] as String?)?.trim(),
        );

    context.router.push(const PhotoCategoryRoute());
  }

  @override
  Widget build(BuildContext context) {
    return AppLoaderOverlay(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Vehicle Information'),
        body: ScreenWrapper(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // * Step indicator
                const AppraisalStepIndicator(currentStep: 1),
                const SizedBox(height: 24),

                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        name: 'vehicle_brand',
                        label: 'Vehicle Brand',
                        placeHolder: 'Toyota, Honda, Suzuki...',
                        prefixIcon: Icon(
                          Icons.directions_car_outlined,
                          color: context.colors.primary,
                        ),
                        validator: VehicleInfoValidators.vehicleBrand(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'vehicle_model',
                        label: 'Vehicle Model',
                        placeHolder: 'Avanza, Brio, Ertiga...',
                        prefixIcon: Icon(
                          Icons.commute_outlined,
                          color: context.colors.primary,
                        ),
                        validator: VehicleInfoValidators.vehicleModel(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'year_manufacture',
                        label: 'Year of Manufacture',
                        placeHolder: '2020',
                        type: AppTextFieldType.number,
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: context.colors.primary,
                        ),
                        validator: VehicleInfoValidators.yearManufacture(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'license_plate',
                        label: 'License Plate (Optional)',
                        placeHolder: 'B 1234 ABC',
                        prefixIcon: Icon(
                          Icons.pin_outlined,
                          color: context.colors.primary,
                        ),
                        // Optionally add a validator if it's required later
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'mileage',
                        label: 'Mileage (Optional)',
                        placeHolder: '50000',
                        type: AppTextFieldType.number,
                        prefixIcon: Icon(
                          Icons.speed_outlined,
                          color: context.colors.primary,
                        ),
                        // Optionally add a validator if it's required later
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'description',
                        label: 'Additional Notes (Optional)',
                        placeHolder: 'Condition, modifications, etc.',
                        type: AppTextFieldType.multiline,
                        maxLines: 4,
                        prefixIcon: Icon(
                          Icons.notes_outlined,
                          color: context.colors.primary,
                        ),
                        validator: VehicleInfoValidators.description(),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: 'Next: Take Photos',
                        onPressed: _onNext,
                        trailingIcon: Icon(
                          Icons.arrow_forward_rounded,
                          color: context.colors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
