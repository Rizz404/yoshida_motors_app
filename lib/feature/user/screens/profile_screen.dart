import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/user/models/update_user_payload.dart';
import 'package:car_rongsok_app/feature/user/models/user.dart'
    as car_rongsok_user;
import 'package:car_rongsok_app/feature/user/providers/user_provider.dart';
import 'package:car_rongsok_app/feature/user/validators/profile_validators.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_date_time_picker.dart';
import 'package:car_rongsok_app/shared/widgets/app_dropdown.dart';
import 'package:car_rongsok_app/shared/widgets/app_file_picker.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _filePickerKey = GlobalKey<AppFilePickerState>();

  Future<void> _onSave(car_rongsok_user.User user) async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final formData = _formKey.currentState!.value;

    final profilePhotos = formData['profilePhotoPath'] as List<PlatformFile>?;
    final String? photoPath = profilePhotos?.isNotEmpty == true
        ? profilePhotos!.first.path
        : null;

    final payload = UpdateUserPayload.fromChanges(
      original: user,
      name: formData['name'] as String?,
      phoneNumber: formData['phoneNumber'] as String?,
      email: formData['email'] as String?,
      address: formData['address'] as String?,
      gender: formData['gender'] as String?,
      birthDate: formData['birthDate'] as DateTime?,
      fcmToken: null,
      profilePhotoPath: photoPath,
    );

    if (payload.isEmpty) {
      AppToast.success(context.l10n.profileSaveSuccess);
      return;
    }

    await ref.read(userProfileNotifierProvider.notifier).updateProfile(payload);
  }

  void _handleProfileStateChange(
    AsyncValue<UserProfileState>? previous,
    AsyncValue<UserProfileState> next,
  ) {
    next.whenData((state) {
      if (state.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (previous?.value?.isMutating == true && !state.isMutating) {
        if (state.mutationError != null) {
          AppToast.error(
            state.mutationError?.message ?? context.l10n.profileSaveFailed,
          );
        } else {
          FocusScope.of(context).unfocus();
          _filePickerKey.currentState?.reset();
          AppToast.success(context.l10n.profileSaveSuccess);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileNotifierProvider);

    ref.listen<AsyncValue<UserProfileState>>(
      userProfileNotifierProvider,
      _handleProfileStateChange,
    );

    return AppLoaderOverlay(
      child: Scaffold(
        // * NOTE: AppBar dan Drawer sekarang di-handle oleh AppShellScreen (routes.dart)
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: AppText(
              context.l10n.profileFailedToLoad,
              color: context.semantic.error,
            ),
          ),
          data: (state) {
            final user = state.user;

            return ScreenWrapper(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // * Avatar
                    Center(
                      child: user?.profilePhoto != null
                          ? AppImage(
                              imageUrl: ApiConstant.resolveUrl(
                                user!.profilePhoto!,
                              ),
                              width: 96,
                              height: 96,
                              shape: ImageShape.circle,
                              fit: BoxFit.cover,
                            )
                          : CircleAvatar(
                              radius: 48,
                              backgroundColor: context.colors.primaryContainer,
                              child: Icon(
                                Icons.person_outline_rounded,
                                size: 52,
                                color: context.colors.primary,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    if (user != null)
                      Center(
                        child: AppText(
                          user.email ?? user.phoneNumber ?? '',
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 32),

                    // * Form
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppFilePicker(
                            key: _filePickerKey,
                            name: 'profilePhotoPath',
                            label: context.l10n.profileUpdatePhotoLabel,
                            hintText: context.l10n.profileUpdatePhotoHint,
                            fileType: FileType.image,
                            allowMultiple: false,
                            maxFiles: 1,
                            maxSizeInMB: 2,
                            allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'name',
                            label: context.l10n.profileFullNameLabel,
                            placeHolder:
                                context.l10n.profileFullNamePlaceholder,
                            initialValue: user?.name,
                            type: AppTextFieldType.text,
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: context.colors.primary,
                            ),
                            validator: ProfileValidators.fullName(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'email',
                            label: context.l10n.profileEmailLabel,
                            placeHolder: context.l10n.profileEmailPlaceholder,
                            initialValue: user?.email,
                            enabled:
                                user?.authProvider != AuthProvider.google &&
                                user?.authProvider != AuthProvider.email,
                            type: AppTextFieldType.email,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: context.colors.primary,
                            ),
                            validator: ProfileValidators.email(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'address',
                            label: context.l10n.profileAddressLabel,
                            placeHolder: context.l10n.profileAddressPlaceholder,
                            initialValue: user?.address,
                            type: AppTextFieldType.multiline,
                            maxLines: 3,
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: context.colors.primary,
                            ),
                            validator: ProfileValidators.address(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            name: 'phoneNumber',
                            label: context.l10n.profilePhoneLabel,
                            placeHolder: context.l10n.profilePhonePlaceholder,
                            initialValue: user?.phoneNumber,
                            enabled: user?.authProvider != AuthProvider.phone,
                            type: AppTextFieldType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppDropdown<String>(
                            name: 'gender',
                            label: context.l10n.profileGenderLabel,
                            hintText: context.l10n.profileGenderPlaceholder,
                            initialValue: user?.gender,
                            prefixIcon: Icon(
                              Icons.person_pin_circle_outlined,
                              color: context.colors.primary,
                            ),
                            items: [
                              AppDropdownItem(
                                value: 'male',
                                label: context.l10n.profileGenderMale,
                              ),
                              AppDropdownItem(
                                value: 'female',
                                label: context.l10n.profileGenderFemale,
                              ),
                              AppDropdownItem(
                                value: 'other',
                                label: context.l10n.profileGenderOther,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppDateTimePicker(
                            name: 'birthDate',
                            label: context.l10n.profileBirthDateLabel,
                            initialValue: user?.birthDate,
                            inputType: InputType.date,
                            icon: Icons.calendar_today_outlined,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ),
                          const SizedBox(height: 32),
                          AppButton(
                            text: context.l10n.profileSaveButton,
                            isLoading: state.isMutating,
                            onPressed: state.isMutating || user == null
                                ? null
                                : () => _onSave(user),
                            leadingIcon: Icon(
                              Icons.save_outlined,
                              color: context.colors.textOnPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
