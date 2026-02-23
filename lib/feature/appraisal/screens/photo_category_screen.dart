import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class PhotoCategoryScreen extends ConsumerStatefulWidget {
  const PhotoCategoryScreen({super.key});

  @override
  ConsumerState<PhotoCategoryScreen> createState() =>
      _PhotoCategoryScreenState();
}

class _PhotoCategoryScreenState extends ConsumerState<PhotoCategoryScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final formState = ref.read(appraisalFormProvider);
    if (formState == null) {
      AppToast.error('Appraisal form is not ready.');
      return;
    }

    setState(() => _isSubmitting = true);
    context.loaderOverlay.show();

    final result = await ref
        .read(appraisalRepositoryProvider)
        .createAppraisal(formState)
        .run();

    if (!mounted) return;
    context.loaderOverlay.hide();
    setState(() => _isSubmitting = false);

    result.fold((failure) => AppToast.error(failure.message), (success) {
      AppToast.success('Appraisal created successfully!');
      ref.read(currentAppraisalIdProvider.notifier).state = success.data.id;
      context.router.push(const SummaryRoute());
    });
  }

  Future<void> _handleCamera(String categoryName) async {
    if (categoryName.trim().isEmpty) {
      AppToast.error('Please enter a category name first');
      return;
    }
    ref.read(currentPhotoCategoryProvider.notifier).state = categoryName.trim();
    context.router.push(const CameraCaptureRoute());
  }

  Future<void> _handleUpload(String categoryName, int currentCount) async {
    if (categoryName.trim().isEmpty) {
      AppToast.error('Please enter a category name first');
      return;
    }

    final maxAllowed = 7 - currentCount;
    if (maxAllowed <= 0) {
      AppToast.error('Maximum 7 photos reached for this category');
      return;
    }

    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    if (images.isEmpty) return;

    if (images.length > maxAllowed) {
      AppToast.error(
        'You can only upload $maxAllowed more photos for this category',
      );
      return;
    }

    for (final image in images) {
      ref
          .read(appraisalFormProvider.notifier)
          .addPhoto(categoryName.trim(), image.path);
    }

    _formKey.currentState?.fields['new_category']?.didChange(null);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(appraisalFormProvider);

    // Group photos locally from the form state
    final photoGroups = <String, int>{};
    if (formState != null && formState.photoLabels != null) {
      for (final label in formState.photoLabels!) {
        photoGroups[label] = (photoGroups[label] ?? 0) + 1;
      }
    }

    final hasAnyPhotos = photoGroups.isNotEmpty;

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Take Photos'),
        body: ScreenWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildStepIndicatorPhotos(context),
              const SizedBox(height: 20),

              // * Warning Message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.semantic.warningLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.semantic.warning),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: context.semantic.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        'Peringatan: Pastikan foto yang diambil terlihat jelas, tidak blur, dan mencakup semua bagian yang diperlukan.',
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // * Add New Category Section
              AppText('Add New Category', style: AppTextStyle.titleSmall),
              const SizedBox(height: 12),
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    const AppTextField(
                      name: 'new_category',
                      label: 'Category Name',
                      placeHolder: 'e.g., Mesin Kanan, Interior Depan',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Camera',
                            variant: AppButtonVariant.outlined,
                            onPressed: () {
                              _formKey.currentState?.save();
                              final val =
                                  _formKey.currentState?.value['new_category']
                                      as String?;
                              _handleCamera(val ?? '');
                            },
                            leadingIcon: Icon(
                              Icons.camera_alt_outlined,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: 'Upload',
                            variant: AppButtonVariant.outlined,
                            onPressed: () {
                              _formKey.currentState?.save();
                              final val =
                                  _formKey.currentState?.value['new_category']
                                      as String?;
                              _handleUpload(val ?? '', 0);
                            },
                            leadingIcon: Icon(
                              Icons.upload_file_outlined,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // * Uploaded Categories List
              AppText('Uploaded Photos', style: AppTextStyle.titleSmall),
              const SizedBox(height: 12),

              if (photoGroups.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: AppText(
                      'No photos uploaded yet',
                      color: context.colors.textSecondary,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: photoGroups.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category = photoGroups.keys.elementAt(index);
                      final count = photoGroups[category]!;
                      return _buildCategoryCard(
                        context,
                        name: category,
                        count: count,
                        isLoading: _isSubmitting,
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              // * Continue button
              AppButton(
                text: 'Continue to Summary',
                onPressed: hasAnyPhotos && !_isSubmitting
                    ? () => _handleSubmit()
                    : null,
                trailingIcon: Icon(
                  Icons.arrow_forward_rounded,
                  color: context.colors.textOnPrimary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required int count,
    required bool isLoading,
  }) {
    final isFull = count >= 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFull ? context.semantic.successLight : context.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFull ? context.semantic.success : context.colors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isFull
                      ? context.semantic.success.withValues(alpha: 0.15)
                      : context.colors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isFull
                      ? Icons.check_circle_outline
                      : Icons.photo_library_outlined,
                  color: isFull
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isFull
                      ? context.semantic.success
                      : context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  '$count / 7',
                  style: AppTextStyle.labelSmall,
                  color: isFull
                      ? context.colors.textOnPrimary
                      : context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (!isFull) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: isLoading ? null : () => _handleCamera(name),
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 18,
                    color: context.colors.textSecondary,
                  ),
                  label: AppText(
                    'Camera',
                    style: AppTextStyle.labelMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => _handleUpload(name, count),
                  icon: Icon(
                    Icons.upload_file_outlined,
                    size: 18,
                    color: context.colors.textSecondary,
                  ),
                  label: AppText(
                    'Upload',
                    style: AppTextStyle.labelMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
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
