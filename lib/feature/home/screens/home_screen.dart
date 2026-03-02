import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/num_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/latest_appraisal_provider.dart';
import 'package:car_rongsok_app/feature/user/providers/user_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final latestAppraisalAsync = ref.watch(latestAppraisalNotifierProvider);

    final userName = profileAsync.value?.user?.name ?? 'User';
    final latestAppraisal = latestAppraisalAsync.value?.appraisal;
    final isRefreshingAppraisal =
        latestAppraisalAsync.isLoading || latestAppraisalAsync.isRefreshing;

    return Scaffold(
      // * NOTE: AppBar dan Drawer sekarang di-handle oleh AppShellScreen (routes.dart)
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
                        context.l10n.homeGreeting(userName),
                        style: AppTextStyle.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        context.l10n.homeReadyForAppraisal,
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textOnPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // * Active status card
                if (latestAppraisal != null || isRefreshingAppraisal) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        context.l10n.homeLatestAppraisal,
                        style: AppTextStyle.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: isRefreshingAppraisal
                                ? null
                                : () => ref.refresh(
                                    latestAppraisalNotifierProvider.future,
                                  ),
                            icon: isRefreshingAppraisal
                                ? SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: context.colors.textTertiary,
                                    ),
                                  )
                                : Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                    color: context.colorScheme.primary,
                                  ),
                            label: AppText(
                              context.l10n.homeRefresh,
                              style: AppTextStyle.bodySmall,
                              color: isRefreshingAppraisal
                                  ? context.colors.textTertiary
                                  : context.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.router.push(
                              const ListAppraisalsRoute(),
                            ),
                            child: AppText(
                              context.l10n.homeSeeAll,
                              style: AppTextStyle.bodySmall,
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (latestAppraisal != null)
                    _buildAppraisalStatusCard(
                      context,
                      appraisal: latestAppraisal,
                      isLoading: isRefreshingAppraisal,
                      onViewDetails: () {
                        ref.read(currentAppraisalIdProvider.notifier).state =
                            latestAppraisal.id;
                        context.router.push(const AppraisalResultRoute());
                      },
                    )
                  else
                    Card(
                      color: context.colors.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: context.colors.border),
                      ),
                      elevation: 0,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],

                // * Start new appraisal
                AppButton(
                  text: context.l10n.homeStartNewAppraisal,
                  onPressed: () {
                    final user = profileAsync.value?.user;
                    final isProfileComplete =
                        user?.name != null &&
                        user?.name?.isNotEmpty == true &&
                        user?.address != null &&
                        user?.address?.isNotEmpty == true &&
                        user?.gender != null &&
                        user?.birthDate != null;

                    if (!isProfileComplete) {
                      AppToast.error(context.l10n.homeIncompleteProfileError);
                      return;
                    }

                    context.router.push(const VehicleInfoRoute());
                  },
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
    bool isLoading = false,
  }) {
    final statusColor = _statusColor(context, appraisal.status);
    final priceFormatted = appraisal.finalPrice?.toYen();

    return Card(
      color: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      elevation: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Opacity(
              opacity: isLoading ? 0.3 : 1.0,
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
                    text: context.l10n.homeViewDetails,
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
          ),
          if (isLoading)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, AppraisalStatus status) =>
      switch (status) {
        AppraisalStatus.draft => context.colors.textTertiary,
        AppraisalStatus.submitted => context.colorScheme.primary,
        AppraisalStatus.underReview => context.colors.accent,
        AppraisalStatus.completed => context.semantic.success,
      };

  String _statusLabel(AppraisalStatus status) => status.label;
}
