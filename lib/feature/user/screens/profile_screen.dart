import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/feature/user/models/update_user_payload.dart';
import 'package:car_rongsok_app/feature/user/providers/user_provider.dart';
import 'package:car_rongsok_app/feature/user/validators/profile_validators.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
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

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final formData = _formKey.currentState!.value;
    final payload = UpdateUserPayload(
      name: formData['name'] as String?,
      email: formData['email'] as String?,
      address: formData['address'] as String?,
      fcmToken: null,
    );

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
            state.mutationError?.message ?? 'Failed to save profile',
          );
        } else {
          AppToast.success('Profile saved successfully');
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
              'Failed to load profile',
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

                    // * Avatar placeholder
                    Center(
                      child: CircleAvatar(
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
                          AppTextField(
                            name: 'name',
                            label: 'Full Name',
                            placeHolder: 'John Doe',
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
                            label: 'Email',
                            placeHolder: 'john@example.com',
                            initialValue: user?.email,
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
                            label: 'Address',
                            placeHolder: 'Jakarta Selatan',
                            initialValue: user?.address,
                            type: AppTextFieldType.multiline,
                            maxLines: 3,
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: context.colors.primary,
                            ),
                            validator: ProfileValidators.address(),
                          ),
                          const SizedBox(height: 32),
                          AppButton(
                            text: 'Save Profile',
                            isLoading: state.isMutating,
                            onPressed: state.isMutating ? null : _onSave,
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
