import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_list_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_rongsok_app/core/extensions/num_extension.dart';

@RoutePage()
class ListAppraisalsScreen extends ConsumerWidget {
  const ListAppraisalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listStateAsync = ref.watch(appraisalListNotifierProvider);
    final notifier = ref.read(appraisalListNotifierProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Appraisals'),
      body: ScreenWrapper(
        child: RefreshIndicator(
          onRefresh: notifier.refresh,
          child: listStateAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: AppText(
                'Failed to load appraisals',
                color: context.semantic.error,
              ),
            ),
            data: (state) {
              if (state.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: context.colors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          AppText(
                            'No appraisals found',
                            style: AppTextStyle.titleMedium,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      state.hasMore &&
                      !state.isLoadingMore) {
                    notifier.fetchMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _buildAppraisalCard(
                      context,
                      appraisal: state.items[index],
                      onViewDetails: () {
                        ref.read(currentAppraisalIdProvider.notifier).state =
                            state.items[index].id;
                        context.router.push(const AppraisalResultRoute());
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppraisalCard(
    BuildContext context, {
    required AppraisalRequest appraisal,
    required VoidCallback onViewDetails,
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
                        '${appraisal.yearManufacture} • ${appraisal.licensePlate}',
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
                    color: statusColor.withOpacity(0.12),
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

  Color _statusColor(BuildContext context, AppraisalStatus status) {
    switch (status) {
      case AppraisalStatus.draft:
        return context.colors.textTertiary;
      case AppraisalStatus.submitted:
        return context.colorScheme.primary;
      case AppraisalStatus.underReview:
        return context.colors.accent;
      case AppraisalStatus.completed:
        return context.semantic.success;
    }
  }

  String _statusLabel(AppraisalStatus status) => status.label;
}
