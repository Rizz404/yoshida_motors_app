import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/num_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_photo.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
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
import 'package:intl/intl.dart';

@RoutePage()
class AppraisalResultScreen extends ConsumerWidget {
  const AppraisalResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appraisalId = ref.watch(currentAppraisalIdProvider);
    if (appraisalId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final detailAsync = ref.watch(appraisalDetailNotifierProvider(appraisalId));

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.appraisalResultTitle),
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: context.semantic.error,
                ),
                const SizedBox(height: 12),
                AppText(
                  context.l10n.appraisalResultFailedToLoad,
                  color: context.semantic.error,
                  style: AppTextStyle.bodyMedium,
                ),
              ],
            ),
          ),
          data: (state) {
            final appraisal = state.appraisal;
            final isPriceDetermined =
                appraisal.status == AppraisalStatus.completed;
            final isUnderAppraisal =
                appraisal.status == AppraisalStatus.underReview;
            final isDraft = appraisal.status == AppraisalStatus.draft;
            final isRejected = appraisal.status == AppraisalStatus.rejected;

            return ScreenWrapper(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // * Status banner
                    _buildStatusBanner(context, appraisal),
                    const SizedBox(height: 20),

                    // * Price card — only if price_determined
                    if (isPriceDetermined && appraisal.finalPrice != null) ...[
                      _buildPriceCard(
                        context,
                        appraisal.finalPrice!,
                        appraisal.updatedAt,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // * Next steps
                    if (isUnderAppraisal || isPriceDetermined) ...[
                      AppText(
                        context.l10n.appraisalResultNextStepsSection,
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      _buildNextSteps(context, isPriceDetermined),
                      const SizedBox(height: 20),
                    ],

                    // * Rejection Reason
                    if (isRejected &&
                        appraisal.adminNote?.isNotEmpty == true) ...[
                      AppText(
                        context.l10n.appraisalResultRejectionReason,
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: AppText(
                          appraisal.adminNote!,
                          style: AppTextStyle.bodySmall,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else if (!isRejected &&
                        appraisal.adminNote?.isNotEmpty == true) ...[
                      AppText(
                        context.l10n.appraisalResultAdminNotesSection,
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.semantic.infoLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.semantic.info.withValues(alpha: 0.3),
                          ),
                        ),
                        child: AppText(
                          appraisal.adminNote!,
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // * Vehicle details
                    AppText(
                      context.l10n.appraisalResultVehicleDetailsSection,
                      style: AppTextStyle.titleSmall,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    _buildVehicleDetails(context, appraisal),
                    const SizedBox(height: 24),

                    // * Photos
                    if (appraisal.photos != null &&
                        appraisal.photos!.isNotEmpty) ...[
                      AppText(
                        context.l10n.appraisalResultPhotos(
                          appraisal.photos!.length,
                        ),
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
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
                        itemCount: appraisal.photos!.length,
                        itemBuilder: (context, index) => _buildPhotoThumbnail(
                          context,
                          photo: appraisal.photos![index],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // * Contact us (if under appraisal)
                    if (isUnderAppraisal)
                      AppButton(
                        text: context.l10n.appraisalResultContactUs,
                        variant: AppButtonVariant.outlined,
                        leadingIcon: Icon(
                          Icons.headset_mic_outlined,
                          color: context.colorScheme.primary,
                        ),
                        onPressed: () {},
                      ),

                    // * Edit Appraisal (if draft)
                    if (isDraft)
                      AppButton(
                        text: context.l10n.appraisalResultEditAppraisal,
                        variant: AppButtonVariant.outlined,
                        leadingIcon: Icon(
                          Icons.edit_outlined,
                          color: context.colorScheme.primary,
                        ),
                        onPressed: () {
                          context.router.push(
                            EditAppraisalRoute(appraisalId: appraisalId),
                          );
                        },
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

  Widget _buildStatusBanner(BuildContext context, AppraisalRequest appraisal) {
    final isPriceDetermined = appraisal.status == AppraisalStatus.completed;
    final isRejected = appraisal.status == AppraisalStatus.rejected;

    final bgColor = isPriceDetermined
        ? context.semantic.successLight
        : isRejected
        ? const Color(0xFFFFE4E6)
        : context.colors.accent.withValues(alpha: 0.12);
    final iconColor = isPriceDetermined
        ? context.semantic.success
        : isRejected
        ? const Color(0xFFEF4444)
        : context.colors.accent;
    final icon = isPriceDetermined
        ? Icons.check_circle_outline_rounded
        : isRejected
        ? Icons.cancel_outlined
        : Icons.access_time_rounded;
    final title = isPriceDetermined
        ? context.l10n.appraisalResultStatusCompleteTitle
        : isRejected
        ? context.l10n.appraisalResultStatusRejectedTitle
        : context.l10n.appraisalResultStatusUnderReviewTitle;
    final subtitle = isPriceDetermined
        ? context.l10n.appraisalResultStatusCompleteSubtitle
        : isRejected
        ? context.l10n.appraisalResultStatusRejectedSubtitle
        : context.l10n.appraisalResultStatusUnderReviewSubtitle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.titleSmall,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  subtitle,
                  style: AppTextStyle.bodySmall,
                  color: iconColor.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    BuildContext context,
    double price,
    DateTime updatedAt,
  ) {
    final formatted = price.toYen();

    final validUntil = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(updatedAt.add(const Duration(days: 30)));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.appraisalResultOfferedPrice,
            style: AppTextStyle.labelMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            formatted,
            style: AppTextStyle.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: context.colors.textTertiary,
              ),
              const SizedBox(width: 6),
              AppText(
                context.l10n.appraisalResultValidUntil(validUntil),
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps(BuildContext context, bool isPriceDetermined) {
    final steps = isPriceDetermined
        ? [
            context.l10n.appraisalResultNextStepComplete1,
            context.l10n.appraisalResultNextStepComplete2,
            context.l10n.appraisalResultNextStepComplete3,
            context.l10n.appraisalResultNextStepComplete4,
          ]
        : [
            context.l10n.appraisalResultNextStepPending1,
            context.l10n.appraisalResultNextStepPending2,
            context.l10n.appraisalResultNextStepPending3,
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: steps.map((step) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: BoxDecoration(
                    color: context.colors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: AppText(
                    step,
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVehicleDetails(
    BuildContext context,
    AppraisalRequest appraisal,
  ) {
    final rows = [
      (context.l10n.appraisalResultBrandLabel, appraisal.vehicleBrand),
      (context.l10n.appraisalResultModelLabel, appraisal.vehicleModel),
      (context.l10n.appraisalResultYearLabel, '${appraisal.yearManufacture}'),
      if (appraisal.licensePlate?.isNotEmpty == true)
        (
          context.l10n.appraisalResultLicensePlateLabel,
          appraisal.licensePlate!,
        ),
      if (appraisal.mileage != null)
        (context.l10n.appraisalResultMileageLabel, '${appraisal.mileage} km'),
      if (appraisal.description?.isNotEmpty == true)
        (context.l10n.appraisalResultNotesLabel, appraisal.description!),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: rows.indexed.map((entry) {
          final (index, row) = entry;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: AppText(
                        row.$1,
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        row.$2,
                        style: AppTextStyle.bodySmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < rows.length - 1)
                Divider(color: context.colors.divider, height: 1),
            ],
          );
        }).toList(),
      ),
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
