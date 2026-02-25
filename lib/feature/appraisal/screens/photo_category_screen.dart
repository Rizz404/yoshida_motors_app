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
import 'package:car_rongsok_app/feature/appraisal/widgets/appraisal_photo_card.dart';
import 'package:car_rongsok_app/feature/appraisal/widgets/appraisal_step_indicator.dart';
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 16),
                    const AppraisalStepIndicator(currentStep: 2),
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
                        const AppText(
                          'Add New Photo',
                          style: AppTextStyle.titleSmall,
                        ),
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
                    const AppText(
                      'Uploaded Photos',
                      style: AppTextStyle.titleSmall,
                    ),
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
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: photos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return AppraisalPhotoCard(
                            index: index,
                            imagePath: photos[index],
                            label: labels[index],
                            isLoading: _isSubmitting,
                          );
                        },
                      ),
                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
