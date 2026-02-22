import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/models/create_appraisal_payload.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/validators/vehicle_info_validators.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
    final payload = CreateAppraisalPayload(
      vehicleBrand: (formData['vehicle_brand'] as String).trim(),
      vehicleModel: (formData['vehicle_model'] as String).trim(),
      yearManufacture: int.parse(
        (formData['year_manufacture'] as String).trim(),
      ),
      description: (formData['description'] as String?)?.trim(),
    );

    context.loaderOverlay.show();

    final result = await ref
        .read(appraisalRepositoryProvider)
        .createAppraisal(payload)
        .run();

    if (!mounted) return;
    context.loaderOverlay.hide();

    result.fold(
      (failure) =>
          AppToast.error(failure.message ?? 'Failed to create appraisal'),
      (success) {
        ref.read(currentAppraisalIdProvider.notifier).state = success.data.id;
        context.router.push(const PhotoCategoryRoute());
      },
    );
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
                _buildStepIndicator(context, current: 1),
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

  Widget _buildStepIndicator(BuildContext context, {required int current}) {
    const steps = ['Info', 'Photos', 'Summary'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // * Connector line
          final stepIndex = index ~/ 2;
          final isDone = stepIndex < current - 1;
          return Expanded(
            child: Container(
              height: 2,
              color: isDone
                  ? context.colorScheme.primary
                  : context.colors.border,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == current - 1;
        final isDone = stepIndex < current - 1;
        return _buildStepDot(
          context,
          label: steps[stepIndex],
          number: stepIndex + 1,
          isActive: isActive,
          isDone: isDone,
        );
      }),
    );
  }

  Widget _buildStepDot(
    BuildContext context, {
    required String label,
    required int number,
    required bool isActive,
    required bool isDone,
  }) {
    final color = (isActive || isDone)
        ? context.colorScheme.primary
        : context.colors.textTertiary;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: (isActive || isDone)
                ? context.colorScheme.primary
                : context.colors.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: context.colors.textOnPrimary,
                  )
                : AppText(
                    '$number',
                    style: AppTextStyle.labelMedium,
                    fontWeight: FontWeight.bold,
                    color: (isActive)
                        ? context.colors.textOnPrimary
                        : context.colors.textTertiary,
                  ),
          ),
        ),
        const SizedBox(height: 4),
        AppText(
          label,
          style: AppTextStyle.labelSmall,
          color: color,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ],
    );
  }
}
