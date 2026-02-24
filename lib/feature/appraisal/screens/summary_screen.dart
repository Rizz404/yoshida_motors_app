import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_photo.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_detail_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
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
          AppToast.error(state.mutationError?.message ?? 'Submission failed');
        } else if (state.appraisal.status == AppraisalStatus.submitted) {
          AppToast.success('Appraisal submitted successfully!');
          context.router.replaceAll([const AppShellRoute()]);
        }
      }
    });
  }

  String _resolveUrl(String path) {
    if (path.startsWith('http')) return path;
    return 'https://yoshida-motors-admin.fts.biz.id/$path';
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
        appBar: const CustomAppBar(title: 'Review & Submit'),
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: AppText('Failed to load', color: context.semantic.error),
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
                    _buildStepIndicatorSummary(context),
                    const SizedBox(height: 24),

                    // * Vehicle info section
                    AppText(
                      'Vehicle Information',
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
                            label: 'Brand',
                            value: appraisal.vehicleBrand,
                          ),
                          _buildInfoRow(
                            context,
                            label: 'Model',
                            value: appraisal.vehicleModel,
                          ),
                          _buildInfoRow(
                            context,
                            label: 'Year',
                            value: '${appraisal.yearManufacture}',
                          ),
                          if (appraisal.licensePlate?.isNotEmpty == true)
                            _buildInfoRow(
                              context,
                              label: 'License Plate',
                              value: appraisal.licensePlate!,
                            ),
                          if (appraisal.mileage != null)
                            _buildInfoRow(
                              context,
                              label: 'Mileage',
                              value: '${appraisal.mileage} km',
                            ),
                          if (appraisal.description?.isNotEmpty == true)
                            _buildInfoRow(
                              context,
                              label: 'Notes',
                              value: appraisal.description!,
                              isLast: true,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // * Photos section
                    AppText(
                      'Photos (${photos.length})',
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
                          'No photos uploaded yet.',
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
                      'By submitting, you agree that the information provided is accurate.',
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textTertiary,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // * Submit button
                    AppButton(
                      text: 'Submit Appraisal',
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
              imageUrl: _resolveUrl(photo.imagePath),
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

  Widget _buildStepIndicatorSummary(BuildContext context) {
    const steps = ['Info', 'Photos', 'Summary'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Container(height: 2, color: context.colorScheme.primary),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == 2;
        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isActive
                    ? AppText(
                        '3',
                        style: AppTextStyle.labelMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      )
                    : Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: context.colors.textOnPrimary,
                      ),
              ),
            ),
            const SizedBox(height: 4),
            AppText(
              steps[stepIndex],
              style: AppTextStyle.labelSmall,
              color: context.colorScheme.primary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ],
        );
      }),
    );
  }
}
