import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/latest_appraisal_provider.dart';
import 'package:car_rongsok_app/feature/user/providers/user_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final latestAppraisalAsync = ref.watch(latestAppraisalNotifierProvider);

    final userName = profileAsync.value?.user?.name ?? 'User';
    final latestAppraisal = latestAppraisalAsync.value?.appraisal;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.directions_car_filled_rounded,
              color: context.colors.textOnPrimary,
              size: 28,
            ),
            const SizedBox(width: 8),
            AppText(
              'Yoshida Motors',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textOnPrimary,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: AppText(
                userName,
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w600,
                color: context.colors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
      body: ScreenWrapper(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(latestAppraisalNotifierProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // * Greeting banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colorScheme.primary,
                        context.colors.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Hello, $userName!',
                        style: AppTextStyle.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        'Ready for your appraisal?',
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textOnPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // * Active status card
                if (latestAppraisal != null) ...[
                  AppText(
                    'Latest Appraisal',
                    style: AppTextStyle.titleSmall,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  _buildAppraisalStatusCard(
                    context,
                    appraisal: latestAppraisal,
                    onViewDetails: () {
                      ref.read(currentAppraisalIdProvider.notifier).state =
                          latestAppraisal.id;
                      context.router.push(const AppraisalResultRoute());
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // * Start new appraisal
                AppButton(
                  text: 'Start New Appraisal',
                  onPressed: () =>
                      context.router.push(const VehicleInfoRoute()),
                  leadingIcon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: context.colors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppraisalStatusCard(
    BuildContext context, {
    required AppraisalRequest appraisal,
    required VoidCallback onViewDetails,
  }) {
    final statusColor = _statusColor(context, appraisal.status);
    final priceFormatted = appraisal.finalPrice != null
        ? NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
          ).format(appraisal.finalPrice)
        : null;

    return Card(
      color: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        '${appraisal.vehicleBrand} ${appraisal.vehicleModel}',
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        '${appraisal.yearManufacture}',
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    _statusLabel(appraisal.status),
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            if (priceFormatted != null) ...[
              const SizedBox(height: 12),
              AppText(
                priceFormatted,
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
                color: context.semantic.success,
              ),
            ],
            const SizedBox(height: 12),
            AppButton(
              text: 'View Details',
              onPressed: onViewDetails,
              size: AppButtonSize.small,
              variant: AppButtonVariant.outlined,
              isFullWidth: false,
              trailingIcon: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) => switch (status) {
    'draft' => context.colors.textTertiary,
    'submitted' => context.colorScheme.primary,
    'under_appraisal' => context.colors.accent,
    'price_determined' => context.semantic.success,
    _ => context.colors.textTertiary,
  };

  String _statusLabel(String status) => switch (status) {
    'draft' => 'Draft',
    'submitted' => 'Submitted',
    'under_appraisal' => 'Under Appraisal',
    'price_determined' => 'Price Determined',
    _ => status,
  };
}
