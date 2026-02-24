import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
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

  String _resolveUrl(String path) {
    if (path.startsWith('http')) return path;
    return 'https://yoshida-motors-admin.fts.biz.id/$path';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appraisalId = ref.watch(currentAppraisalIdProvider);
    if (appraisalId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final detailAsync = ref.watch(appraisalDetailNotifierProvider(appraisalId));

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Appraisal Result'),
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
                  'Failed to load appraisal',
                  color: context.semantic.error,
                  style: AppTextStyle.bodyMedium,
                ),
              ],
            ),
          ),
          data: (state) {
            final appraisal = state.appraisal;
            final isPriceDetermined = appraisal.status == 'price_determined';
            final isUnderAppraisal = appraisal.status == 'under_appraisal';

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
                        'Next Steps',
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      _buildNextSteps(context, isPriceDetermined),
                      const SizedBox(height: 20),
                    ],

                    // * Admin notes
                    if (appraisal.adminNotes?.isNotEmpty == true) ...[
                      AppText(
                        'Admin Notes',
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
                          appraisal.adminNotes!,
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // * Vehicle details
                    AppText(
                      'Vehicle Details',
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
                        'Photos (${appraisal.photos!.length})',
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
                        text: 'Contact Us',
                        variant: AppButtonVariant.outlined,
                        leadingIcon: Icon(
                          Icons.headset_mic_outlined,
                          color: context.colorScheme.primary,
                        ),
                        onPressed: () {},
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
    final isPriceDetermined = appraisal.status == 'price_determined';

    final bgColor = isPriceDetermined
        ? context.semantic.successLight
        : context.colors.accent.withValues(alpha: 0.12);
    final iconColor = isPriceDetermined
        ? context.semantic.success
        : context.colors.accent;
    final icon = isPriceDetermined
        ? Icons.check_circle_outline_rounded
        : Icons.access_time_rounded;
    final title = isPriceDetermined ? 'Review Complete!' : 'Under Review';
    final subtitle = isPriceDetermined
        ? 'Your appraisal has been reviewed and a price has been set.'
        : 'We\'ll notify you once the review is complete.';

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
    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    ).format(price);

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
            'Offered Purchase Price',
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
                'Valid until: $validUntil',
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
            'Review the offered price carefully.',
            'Contact our team to accept or negotiate.',
            'Bring your vehicle for a physical inspection.',
            'Complete the transaction and documentation.',
          ]
        : [
            'Our team will review your submission.',
            'You will receive a notification when done.',
            'You can contact us for updates at any time.',
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
      ('Brand', appraisal.vehicleBrand),
      ('Model', appraisal.vehicleModel),
      ('Year', '${appraisal.yearManufacture}'),
      if (appraisal.description?.isNotEmpty == true)
        ('Notes', appraisal.description!),
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
}
