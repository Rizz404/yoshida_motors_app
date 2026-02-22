import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_detail_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// * Kategori foto yang wajib diambil
const _kPhotoCategories = [
  (name: 'Front View', icon: Icons.directions_car_rounded),
  (name: 'Rear View', icon: Icons.directions_car_rounded),
  (name: 'Left Side', icon: Icons.swap_horiz_rounded),
  (name: 'Right Side', icon: Icons.swap_horiz_rounded),
  (name: 'Interior', icon: Icons.airline_seat_recline_normal_rounded),
  (name: 'Engine', icon: Icons.settings_rounded),
];

@RoutePage()
class PhotoCategoryScreen extends ConsumerWidget {
  const PhotoCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appraisalId = ref.watch(currentAppraisalIdProvider);
    if (appraisalId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final detailAsync = ref.watch(appraisalDetailNotifierProvider(appraisalId));

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Take Photos'),
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: AppText('Failed to load', color: context.semantic.error),
          ),
          data: (state) {
            final uploadedCategories =
                state.appraisal.photos?.map((p) => p.categoryName).toSet() ??
                {};
            final completedCount = _kPhotoCategories
                .where((c) => uploadedCategories.contains(c.name))
                .length;
            final allDone = completedCount == _kPhotoCategories.length;
            final progress = completedCount / _kPhotoCategories.length;

            return ScreenWrapper(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildStepIndicatorPhotos(context),
                  const SizedBox(height: 20),

                  // * Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            'Photos uploaded',
                            style: AppTextStyle.labelMedium,
                            color: context.colors.textSecondary,
                          ),
                          AppText(
                            '$completedCount / ${_kPhotoCategories.length}',
                            style: AppTextStyle.labelMedium,
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: context.colors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // * Category list
                  Expanded(
                    child: ListView.separated(
                      itemCount: _kPhotoCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final category = _kPhotoCategories[index];
                        final isDone = uploadedCategories.contains(
                          category.name,
                        );
                        return _buildCategoryCard(
                          context,
                          name: category.name,
                          icon: category.icon,
                          isDone: isDone,
                          isLoading: state.isMutating,
                          onTap: () {
                            ref
                                    .read(currentPhotoCategoryProvider.notifier)
                                    .state =
                                category.name;
                            context.router.push(const CameraCaptureRoute());
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // * Continue button
                  AppButton(
                    text: 'Continue to Summary',
                    onPressed: allDone
                        ? () => context.router.push(const SummaryRoute())
                        : null,
                    trailingIcon: Icon(
                      Icons.arrow_forward_rounded,
                      color: context.colors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required IconData icon,
    required bool isDone,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone ? context.semantic.successLight : context.colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? context.semantic.success : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDone
                    ? context.semantic.success.withValues(alpha: 0.15)
                    : context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDone
                    ? context.semantic.success
                    : context.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppText(
                name,
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              isDone ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
              color: isDone
                  ? context.semantic.success
                  : context.colorScheme.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicatorPhotos(BuildContext context) {
    const steps = ['Info', 'Photos', 'Summary'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isDone = stepIndex < 1;
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
        final isActive = stepIndex == 1;
        final isDone = stepIndex < 1;
        return _buildDot(
          context,
          label: steps[stepIndex],
          number: stepIndex + 1,
          isActive: isActive,
          isDone: isDone,
        );
      }),
    );
  }

  Widget _buildDot(
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
                    color: isActive
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
