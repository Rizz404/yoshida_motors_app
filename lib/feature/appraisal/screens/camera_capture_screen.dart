import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_flow_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
    String? category = ref.read(currentPhotoCategoryProvider);

    if (image == null) return;

    ref
        .read(appraisalFormProvider.notifier)
        .addPhoto(category?.trim() ?? '', image.path);

    AppToast.success('Photo added');
    if (mounted) await context.router.maybePop();
  }

  Future<String?> _showCategoryNameDialog() async {
    final formKey = GlobalKey<FormBuilderState>();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: AppText('Enter Category Name', style: AppTextStyle.titleSmall),
        content: FormBuilder(
          key: formKey,
          child: const AppTextField(
            name: 'category_name',
            label: 'Category Name',
            placeHolder: 'e.g., Mesin Kanan, Interior Depan',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText('Cancel', color: context.colors.textSecondary),
          ),
          TextButton(
            onPressed: () {
              formKey.currentState?.save();
              final val =
                  formKey.currentState?.value['category_name'] as String?;
              if (val != null && val.trim().isNotEmpty) {
                Navigator.of(context).pop(val.trim());
              }
            },
            child: AppText('Save', color: context.colorScheme.primary),
          ),
        ],
      ),
    );
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
                      child: AppImage(
                        imageFile: _capturedImage!,
                        fit: BoxFit.contain,
                        size: ImageSize.fullWidth,
                        height: double.infinity,
                      ),
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
