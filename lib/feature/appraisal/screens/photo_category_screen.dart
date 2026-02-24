import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
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
  bool _isSubmitting = false;
  bool _isAddPhotoVisible = true;

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

    final labels = formState.photoLabels ?? [];
    if (labels.isEmpty) {
      AppToast.error('Please add at least one photo.');
      return;
    }

    if (labels.any((label) => label.trim().isEmpty)) {
      AppToast.error('Please enter a category name for all photos.');
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

  Future<void> _handleCamera() async {
    final formState = ref.read(appraisalFormProvider);
    final currentPhotosCount = formState?.photos?.length ?? 0;

    if (currentPhotosCount >= 7) {
      AppToast.error('Maksimal 7 foto telah tercapai.');
      return;
    }

    ref.read(currentPhotoCategoryProvider.notifier).state = '';
    context.router.push(const CameraCaptureRoute());
  }

  Future<void> _handleUpload() async {
    final formState = ref.read(appraisalFormProvider);
    final currentPhotosCount = formState?.photos?.length ?? 0;

    if (currentPhotosCount >= 7) {
      AppToast.error('Maksimal 7 foto telah tercapai.');
      return;
    }

    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    if (images.isEmpty) return;

    final availableSlots = 7 - currentPhotosCount;
    final imagesToAdd = images.take(availableSlots).toList();
    final imagesRejected = images.skip(availableSlots).toList();

    for (final image in imagesToAdd) {
      ref.read(appraisalFormProvider.notifier).addPhoto('', image.path);
    }

    if (imagesRejected.isNotEmpty) {
      final rejectedNames = imagesRejected.map((e) => e.name).join(', ');
      AppToast.error(
        'Maksimal 7 foto. Foto berikut tidak ditambahkan: $rejectedNames',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(appraisalFormProvider);

    final photos = formState?.photos ?? [];
    final labels = formState?.photoLabels ?? [];
    final hasAnyPhotos = photos.isNotEmpty;

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
                      color: context.semantic.warningDark,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        'Warning: Ensure the photos taken are clear, not blurry, and cover all necessary parts.',
                        style: AppTextStyle.bodySmall,
                        color: context.semantic.warningDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText('Add New Photo', style: AppTextStyle.titleSmall),
                  if (photos.length < 7)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isAddPhotoVisible = !_isAddPhotoVisible;
                        });
                      },
                      icon: Icon(
                        _isAddPhotoVisible
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: context.colors.textSecondary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (photos.length < 7 && _isAddPhotoVisible) ...[
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Camera',
                        variant: AppButtonVariant.outlined,
                        onPressed: _handleCamera,
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
                        onPressed: _handleUpload,
                        leadingIcon: Icon(
                          Icons.upload_file_outlined,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              const Divider(),
              const SizedBox(height: 16),

              // * Uploaded Photos List
              const AppText('Uploaded Photos', style: AppTextStyle.titleSmall),
              const SizedBox(height: 12),

              if (photos.isEmpty)
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
                    itemCount: photos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _PhotoCard(
                        index: index,
                        imagePath: photos[index],
                        label: labels[index],
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
                    ? _handleSubmit
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

class _PhotoCard extends ConsumerStatefulWidget {
  final int index;
  final String imagePath;
  final String label;
  final bool isLoading;

  const _PhotoCard({
    required this.index,
    required this.imagePath,
    required this.label,
    required this.isLoading,
  });

  @override
  ConsumerState<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends ConsumerState<_PhotoCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.label);
  }

  @override
  void didUpdateWidget(covariant _PhotoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.label != widget.label && _controller.text != widget.label) {
      _controller.text = widget.label;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with preview button
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppImage(
                  imageFile: File(widget.imagePath),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  enablePreview: true,
                ),
              ),
              IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Category Name Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _controller,
                  enabled: !widget.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g., Mesin Kanan',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    ref
                        .read(appraisalFormProvider.notifier)
                        .updatePhotoLabel(widget.index, value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Remove Button
          IconButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    ref
                        .read(appraisalFormProvider.notifier)
                        .removePhoto(widget.index);
                  },
            icon: Icon(Icons.delete_outline, color: context.semantic.error),
            tooltip: 'Remove Photo',
          ),
        ],
      ),
    );
  }
}
