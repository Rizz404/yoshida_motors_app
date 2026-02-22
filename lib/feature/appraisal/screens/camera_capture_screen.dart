import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/appraisal/models/upload_photo_payload.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_detail_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class CameraCaptureScreen extends ConsumerStatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  ConsumerState<CameraCaptureScreen> createState() =>
      _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends ConsumerState<CameraCaptureScreen> {
  File? _capturedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // * Auto-open camera on entry
    WidgetsBinding.instance.addPostFrameCallback((_) => _openCamera());
  }

  Future<void> _openCamera() async {
    final result = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (result == null) {
      if (mounted) await context.router.maybePop();
      return;
    }

    setState(() => _capturedImage = File(result.path));
  }

  Future<void> _usePhoto() async {
    final image = _capturedImage;
    final appraisalId = ref.read(currentAppraisalIdProvider);
    final category = ref.read(currentPhotoCategoryProvider);

    if (image == null || appraisalId == null || category == null) return;

    context.loaderOverlay.show();

    await ref
        .read(appraisalDetailNotifierProvider(appraisalId).notifier)
        .uploadPhoto(
          UploadPhotoPayload(categoryName: category, imagePath: image.path),
        );

    if (!mounted) return;
    context.loaderOverlay.hide();

    final state = ref.read(appraisalDetailNotifierProvider(appraisalId)).value;
    if (state?.mutationError != null) {
      AppToast.error(state!.mutationError!.message ?? 'Upload failed');
    } else {
      AppToast.success('Photo uploaded');
      context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(currentPhotoCategoryProvider) ?? 'Photo';

    return AppLoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: AppText(
            'Take Photo: $category',
            style: AppTextStyle.titleSmall,
            color: Colors.white,
          ),
        ),
        body: _capturedImage == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      'Opening camera...',
                      color: Colors.white54,
                      style: AppTextStyle.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: _openCamera,
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                      label: const AppText('Open Camera', color: Colors.white),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // * Photo preview
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: Image.file(_capturedImage!, fit: BoxFit.contain),
                    ),
                  ),

                  // * Action buttons
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Retake',
                            variant: AppButtonVariant.outlined,
                            onPressed: _openCamera,
                            leadingIcon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppButton(
                            text: 'Use This Photo',
                            onPressed: _usePhoto,
                            leadingIcon: Icon(
                              Icons.check_rounded,
                              color: context.colors.textOnPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
