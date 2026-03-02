import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_photo.dart';
import 'package:car_rongsok_app/feature/appraisal/models/update_appraisal_payload.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/appraisal_detail_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/validators/vehicle_info_validators.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
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
class EditAppraisalScreen extends ConsumerStatefulWidget {
  final int appraisalId;

  const EditAppraisalScreen({
    super.key,
    @PathParam('id') required this.appraisalId,
  });

  @override
  ConsumerState<EditAppraisalScreen> createState() =>
      _EditAppraisalScreenState();
}

class _EditAppraisalScreenState extends ConsumerState<EditAppraisalScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isInit = false;
  bool _isSubmitting = false;
  bool _isPickingImage = false;

  final List<AppraisalPhoto> _existingPhotos = [];
  final List<int> _deletePhotos = [];

  final List<String> _newPhotos = [];
  final List<String> _newPhotoLabels = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _initData();
    }
  }

  void _initData() {
    final detailAsync = ref.read(
      appraisalDetailNotifierProvider(widget.appraisalId),
    );
    final appraisal = detailAsync.value?.appraisal;

    if (appraisal != null) {
      _isInit = true;
      if (appraisal.photos != null) {
        _existingPhotos.addAll(appraisal.photos!);
      }
      // Populate form data later in initialValue of FormBuilder
    }
  }

  int get _totalPhotos => _existingPhotos.length + _newPhotos.length;

  Future<void> _handleUpload() async {
    if (_isPickingImage) return;
    if (_totalPhotos >= 7) {
      AppToast.error(context.l10n.photoCategoryMaxPhotos);
      return;
    }

    setState(() => _isPickingImage = true);
    final List<XFile> images;
    try {
      final picker = ImagePicker();
      images = await picker.pickMultiImage(imageQuality: 80);
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }

    if (images.isEmpty) return;

    final availableSlots = 7 - _totalPhotos;
    final imagesToAdd = images.take(availableSlots).toList();
    final imagesRejected = images.skip(availableSlots).toList();

    setState(() {
      for (final image in imagesToAdd) {
        _newPhotos.add(image.path);
        _newPhotoLabels.add(''); // Empty label by default
      }
    });

    if (imagesRejected.isNotEmpty) {
      final rejectedNames = imagesRejected.map((e) => e.name).join(', ');
      AppToast.error(
        'Maksimal 7 foto. Foto berikut tidak ditambahkan: $rejectedNames',
      );
    }
  }

  void _removeExistingPhoto(AppraisalPhoto photo) {
    setState(() {
      _existingPhotos.remove(photo);
      _deletePhotos.add(photo.id);
    });
  }

  void _removeNewPhoto(int idx) {
    setState(() {
      _newPhotos.removeAt(idx);
      _newPhotoLabels.removeAt(idx);
    });
  }

  void _updateNewPhotoLabel(int idx, String label) {
    _newPhotoLabels[idx] = label;
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    if (_totalPhotos == 0) {
      AppToast.error(context.l10n.editAppraisalErrorMinPhotos);
      return;
    }

    if (_newPhotoLabels.any((label) => label.trim().isEmpty)) {
      AppToast.error(context.l10n.editAppraisalErrorCategoryRequired);
      return;
    }

    setState(() => _isSubmitting = true);
    context.loaderOverlay.show();

    final formData = _formKey.currentState!.value;
    final mileageString = formData['mileage'] as String?;

    final payload = UpdateAppraisalPayload(
      vehicleBrand: (formData['vehicle_brand'] as String).trim(),
      vehicleModel: (formData['vehicle_model'] as String).trim(),
      yearManufacture: int.parse(
        (formData['year_manufacture'] as String).trim(),
      ),
      licensePlate: (formData['license_plate'] as String?)?.trim(),
      mileage: mileageString != null ? int.tryParse(mileageString) : null,
      description: (formData['description'] as String?)?.trim(),
      newPhotos: _newPhotos.isNotEmpty ? _newPhotos : null,
      newPhotoLabels: _newPhotoLabels.isNotEmpty ? _newPhotoLabels : null,
      deletePhotos: _deletePhotos.isNotEmpty ? _deletePhotos : null,
    );

    final result = await ref
        .read(appraisalRepositoryProvider)
        .updateAppraisal(widget.appraisalId, payload)
        .run();

    if (!mounted) return;
    context.loaderOverlay.hide();
    setState(() => _isSubmitting = false);

    result.fold((failure) => AppToast.error(failure.message), (success) {
      FocusScope.of(context).unfocus();
      AppToast.success(context.l10n.editAppraisalSuccess);
      // Refresh the detail provider
      ref.invalidate(appraisalDetailNotifierProvider(widget.appraisalId));
      context.router.maybePop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      appraisalDetailNotifierProvider(widget.appraisalId),
    );

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.editAppraisalTitle),
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: AppText(
              context.l10n.editAppraisalFailedToLoad,
              color: context.semantic.error,
            ),
          ),
          data: (state) {
            final appraisal = state.appraisal;
            if (!_isInit) {
              // Fallback if didChangeDependencies didn't fire in time
              _isInit = true;
              if (appraisal.photos != null) {
                _existingPhotos.addAll(appraisal.photos!);
              }
            }

            return ScreenWrapper(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    AppText(
                      context.l10n.editAppraisalVehicleInfoSection,
                      style: AppTextStyle.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    FormBuilder(
                      key: _formKey,
                      initialValue: {
                        'vehicle_brand': appraisal.vehicleBrand,
                        'vehicle_model': appraisal.vehicleModel,
                        'year_manufacture': appraisal.yearManufacture
                            .toString(),
                        'license_plate': appraisal.licensePlate,
                        'mileage': appraisal.mileage?.toString(),
                        'description': appraisal.description,
                      },
                      child: Column(
                        children: [
                          AppTextField(
                            name: 'vehicle_brand',
                            label: context.l10n.vehicleInfoBrandLabel,
                            placeHolder:
                                context.l10n.vehicleInfoBrandPlaceholder,
                            prefixIcon: Icon(
                              Icons.directions_car_outlined,
                              color: context.colors.primary,
                            ),
                            validator: VehicleInfoValidators.vehicleBrand(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'vehicle_model',
                            label: context.l10n.vehicleInfoModelLabel,
                            placeHolder:
                                context.l10n.vehicleInfoModelPlaceholder,
                            prefixIcon: Icon(
                              Icons.commute_outlined,
                              color: context.colors.primary,
                            ),
                            validator: VehicleInfoValidators.vehicleModel(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'year_manufacture',
                            label: context.l10n.vehicleInfoYearLabel,
                            placeHolder:
                                context.l10n.vehicleInfoYearPlaceholder,
                            type: AppTextFieldType.number,
                            prefixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: context.colors.primary,
                            ),
                            validator: VehicleInfoValidators.yearManufacture(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'license_plate',
                            label: context.l10n.vehicleInfoLicensePlateLabel,
                            placeHolder: 'B 1234 ABC',
                            prefixIcon: Icon(
                              Icons.pin_outlined,
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'mileage',
                            label: context.l10n.vehicleInfoMileageLabel,
                            placeHolder: '50000',
                            type: AppTextFieldType.number,
                            prefixIcon: Icon(
                              Icons.speed_outlined,
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'description',
                            label: context.l10n.vehicleInfoNotesLabel,
                            placeHolder:
                                context.l10n.vehicleInfoNotesPlaceholder,
                            type: AppTextFieldType.multiline,
                            maxLines: 4,
                            prefixIcon: Icon(
                              Icons.notes_outlined,
                              color: context.colors.primary,
                            ),
                            validator: VehicleInfoValidators.description(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          context.l10n.editAppraisalPhotosSection(_totalPhotos),
                          style: AppTextStyle.titleMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        if (_totalPhotos < 7)
                          TextButton.icon(
                            onPressed: _isPickingImage ? null : _handleUpload,
                            icon: Icon(
                              Icons.add_photo_alternate_outlined,
                              color: context.colorScheme.primary,
                            ),
                            label: AppText(
                              context.l10n.editAppraisalAddPhoto,
                              color: context.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_totalPhotos == 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: AppText(
                            context.l10n.editAppraisalNoPhotos,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          ..._existingPhotos.map(
                            (photo) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildExistingPhotoCard(context, photo),
                            ),
                          ),
                          ..._newPhotos.asMap().entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildNewPhotoCard(
                                context,
                                entry.key,
                                entry.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: context.l10n.editAppraisalSaveButton,
                      onPressed: _isSubmitting ? null : _handleSave,
                      leadingIcon: Icon(
                        Icons.save_outlined,
                        color: context.colors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExistingPhotoCard(BuildContext context, AppraisalPhoto photo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppImage(
              imageUrl: ApiConstant.resolveUrl(photo.imagePath),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              enablePreview: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppText(
              photo.categoryName,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isSubmitting ? null : () => _removeExistingPhoto(photo),
            icon: Icon(Icons.delete_outline, color: context.semantic.error),
            tooltip: context.l10n.appraisalRemovePhotoTooltip,
          ),
        ],
      ),
    );
  }

  Widget _buildNewPhotoCard(BuildContext context, int index, String imagePath) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppImage(
              imageFile: File(imagePath),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              enablePreview: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              initialValue: _newPhotoLabels[index],
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                labelText: context.l10n.cameraCaptureDialogCategoryLabel,
                hintText: context.l10n.appraisalPhotoCategoryHint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => _updateNewPhotoLabel(index, value),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isSubmitting ? null : () => _removeNewPhoto(index),
            icon: Icon(Icons.delete_outline, color: context.semantic.error),
            tooltip: context.l10n.appraisalRemovePhotoTooltip,
          ),
        ],
      ),
    );
  }
}
