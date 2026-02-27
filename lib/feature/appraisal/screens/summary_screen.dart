import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_photo.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_detail_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/widgets/appraisal_step_indicator.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  void _handleDetailStateChange(
    BuildContext context,
    AsyncValue<AppraisalDetailState>? previous,
    AsyncValue<AppraisalDetailState> next,
  ) {
    next.whenData((state) {
      if (state.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (previous?.value?.isMutating == true && !state.isMutating) {
        if (state.mutationError != null) {
          AppToast.error(
            state.mutationError?.message ??
                context.l10n.summarySubmissionFailed,
          );
        } else if (state.appraisal.status == AppraisalStatus.submitted) {
          AppToast.success(context.l10n.summarySubmitSuccess);
          context.router.replaceAll([const AppShellRoute()]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. In the new flow, the Appraisal has ALREADY been created on the previous screen
    // `PhotoCategoryScreen` via `_handleSubmit()`. At this point, `currentAppraisalIdProvider`
    // has the newly created ID.
    final int? appraisalId = ref.watch(currentAppraisalIdProvider);
    if (appraisalId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final detailAsync = ref.watch(appraisalDetailNotifierProvider(appraisalId));

    ref.listen<AsyncValue<AppraisalDetailState>>(
      appraisalDetailNotifierProvider(appraisalId),
      (previous, next) => _handleDetailStateChange(context, previous, next),
    );

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.summaryTitle),
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: AppText(
              context.l10n.summaryFailedToLoad,
              color: context.semantic.error,
            ),
          ),
          data: (state) {
            final appraisal = state.appraisal;
            final photos = appraisal.photos ?? [];

            return ScreenWrapper(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const AppraisalStepIndicator(currentStep: 3),
                    const SizedBox(height: 24),

                    // * Vehicle info section
                    AppText(
                      context.l10n.summaryVehicleInfoSection,
                      style: AppTextStyle.titleSmall,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            label: context.l10n.summaryBrand,
                            value: appraisal.vehicleBrand,
                          ),
                          _buildInfoRow(
                            context,
                            label: context.l10n.summaryModel,
                            value: appraisal.vehicleModel,
                          ),
                          _buildInfoRow(
                            context,
                            label: context.l10n.summaryYear,
                            value: '${appraisal.yearManufacture}',
                          ),
                          if (appraisal.licensePlate?.isNotEmpty == true)
                            _buildInfoRow(
                              context,
                              label: context.l10n.summaryLicensePlate,
                              value: appraisal.licensePlate!,
                            ),
                          if (appraisal.mileage != null)
                            _buildInfoRow(
                              context,
                              label: context.l10n.summaryMileage,
                              value: '${appraisal.mileage} km',
                            ),
                          if (appraisal.description?.isNotEmpty == true)
                            _buildInfoRow(
                              context,
                              label: context.l10n.summaryNotes,
                              value: appraisal.description!,
                              isLast: true,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // * Photos section
                    AppText(
                      context.l10n.summaryPhotosSection(photos.length),
                      style: AppTextStyle.titleSmall,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    if (photos.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.colors.border),
                        ),
                        child: AppText(
                          context.l10n.summaryNoPhotos,
                          color: context.colors.textTertiary,
                          style: AppTextStyle.bodySmall,
                        ),
                      )
                    else
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                        itemCount: photos.length,
                        itemBuilder: (context, index) =>
                            _buildPhotoThumbnail(context, photo: photos[index]),
                      ),
                    const SizedBox(height: 24),

                    // * Disclaimer
                    AppText(
                      context.l10n.summaryDisclaimer,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textTertiary,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // * Submit button
                    AppButton(
                      text: context.l10n.summarySubmitButton,
                      onPressed: () {
                        // The submission actually marks it submitted when doing PUT /appraisals/{id} with status=submitted
                        ref
                            .read(
                              appraisalDetailNotifierProvider(
                                appraisalId,
                              ).notifier,
                            )
                            .submitAppraisal();
                      },
                      leadingIcon: Icon(
                        Icons.send_rounded,
                        color: context.colors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: AppText(
                  label,
                  style: AppTextStyle.bodySmall,
                  color: context.colors.textSecondary,
                ),
              ),
              Expanded(
                child: AppText(
                  value,
                  style: AppTextStyle.bodySmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: context.colors.divider, height: 1),
      ],
    );
  }

  Widget _buildPhotoThumbnail(
    BuildContext context, {
    required AppraisalPhoto photo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppImage(
              imageUrl: ApiConstant.resolveUrl(photo.imagePath),
              fit: BoxFit.cover,
              shape: ImageShape.rectangle,
              size: ImageSize.fullWidth,
              enablePreview: true,
            ),
          ),
        ),
        const SizedBox(height: 4),
        AppText(
          photo.categoryName,
          style: AppTextStyle.labelSmall,
          color: context.colors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
