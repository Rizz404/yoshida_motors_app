import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/di/auth_providers.dart';
import 'package:car_rongsok_app/di/common_providers.dart';
import 'package:car_rongsok_app/di/service_providers.dart';
import 'package:car_rongsok_app/feature/auth/models/register_payload.dart';
import 'package:car_rongsok_app/feature/auth/validators/register_validators.dart';
import 'package:car_rongsok_app/shared/widgets/app_button.dart';
import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/app_text_field.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? _verificationId;
  bool _isOtpSent = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendOTP() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final phoneNumber = _formKey.currentState!.value['phone'] as String;
    final phoneAuthService = ref.read(phoneAuthServiceProvider);

    context.loaderOverlay.show();

    await phoneAuthService.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        if (!mounted) return;
        context.loaderOverlay.hide();
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
        AppToast.success('OTP sent to $phoneNumber');
      },
      onError: (error) {
        if (!mounted) return;
        context.loaderOverlay.hide();
        AppToast.error(error);
      },
      onAutoVerified: () async {
        // * Auto-verification success (Android only)
        await _verifyAndRegister(isAutoVerified: true);
      },
    );
  }

  Future<void> _verifyAndRegister({bool isAutoVerified = false}) async {
    if (!isAutoVerified) {
      if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    }

    if (_verificationId == null) {
      AppToast.error('Please request OTP first');
      return;
    }

    final otpCode = isAutoVerified
        ? ''
        : _formKey.currentState!.value['otp'] as String;

    if (!isAutoVerified && otpCode.length != 6) {
      AppToast.error('OTP must be 6 digits');
      return;
    }

    final phoneAuthService = ref.read(phoneAuthServiceProvider);
    final fcmService = ref.read(firebaseMessagingServiceProvider);

    context.loaderOverlay.show();

    // * Verify OTP and get ID Token
    String? idToken;

    if (isAutoVerified) {
      // * For auto-verified, get token directly from current user
      final currentUser = phoneAuthService.currentUser;
      idToken = await currentUser?.getIdToken();
    } else {
      idToken = await phoneAuthService.verifyOTP(
        verificationId: _verificationId!,
        otpCode: otpCode,
        onError: (error) {
          if (!mounted) return;
          context.loaderOverlay.hide();
          AppToast.error(error);
        },
      );
    }

    if (!mounted) return;
    if (idToken == null) {
      context.loaderOverlay.hide();
      return;
    }

    // * Get form data
    final formData = _formKey.currentState!.value;
    final phoneNumber = formData['phone'] as String;
    final name = formData['name'] as String?;
    final email = formData['email'] as String?;
    final address = formData['address'] as String?;

    // * Get FCM token
    final fcmToken = await fcmService.getToken();

    // * Register to backend
    final payload = RegisterPayload(
      idToken: idToken,
      phoneNumber: phoneNumber,
      name: name?.isNotEmpty == true ? name : null,
      email: email?.isNotEmpty == true ? email : null,
      address: address?.isNotEmpty == true ? address : null,
      fcmToken: fcmToken,
    );

    await ref.read(authNotifierProvider.notifier).register(payload);

    if (!mounted) return;
    context.loaderOverlay.hide();

    // * Handle register result
    ref.listen(authNotifierProvider, (previous, next) {
      next.when(
        data: (authState) {
          if (authState.status == AuthStatus.authenticated) {
            AppToast.success('Registration successful');
          } else if (authState.failure != null) {
            final message = authState.failure?.message ?? 'Registration failed';
            AppToast.error(message);

            // * If user already exists, suggest login
            if (message.contains('already registered')) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  const LoginRoute().go(context);
                }
              });
            }
          }
        },
        error: (error, stack) {
          AppToast.error('Registration error: $error');
        },
        loading: () {},
      );
    });
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isOtpSent = false;
      _verificationId = null;
    });

    // * Clear OTP field
    _formKey.currentState?.fields['otp']?.didChange('');

    await _sendOTP();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoaderOverlay(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: ScreenWrapper(
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // * Title
                  AppText(
                    'Create Account',
                    style: AppTextStyle.headlineLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    'Register with your phone number',
                    style: AppTextStyle.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 40),

                  // * Phone Number Field
                  AppTextField(
                    name: 'phone',
                    label: 'Phone Number',
                    placeHolder: '+628123456789',
                    type: AppTextFieldType.phone,
                    enabled: !_isOtpSent,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: context.colors.primary,
                    ),
                    validator: RegisterValidators.phoneNumber(),
                  ),
                  const SizedBox(height: 24),

                  // * OTP Field (only show after OTP sent)
                  if (_isOtpSent) ...[
                    AppTextField(
                      name: 'otp',
                      label: 'OTP Code',
                      placeHolder: '123456',
                      type: AppTextFieldType.number,
                      maxLines: 1,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: context.colors.primary,
                      ),
                      validator: RegisterValidators.otpCode(),
                    ),
                    const SizedBox(height: 16),

                    // * Resend OTP Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _resendOTP,
                        child: AppText(
                          'Resend OTP',
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // * Optional Info Section
                    AppText(
                      'Additional Information (Optional)',
                      style: AppTextStyle.titleMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 16),

                    // * Name Field
                    AppTextField(
                      name: 'name',
                      label: 'Full Name',
                      placeHolder: 'John Doe',
                      type: AppTextFieldType.text,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // * Email Field
                    AppTextField(
                      name: 'email',
                      label: 'Email',
                      placeHolder: 'john@example.com',
                      type: AppTextFieldType.email,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: context.colors.primary,
                      ),
                      validator: RegisterValidators.email(),
                    ),
                    const SizedBox(height: 16),

                    // * Address Field
                    AppTextField(
                      name: 'address',
                      label: 'Address',
                      placeHolder: 'Jakarta Selatan',
                      type: AppTextFieldType.text,
                      maxLines: 3,
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // * Action Button
                  AppButton(
                    text: _isOtpSent ? 'Register' : 'Send OTP',
                    onPressed: _isOtpSent ? _verifyAndRegister : _sendOTP,
                    leadingIcon: Icon(
                      _isOtpSent ? Icons.person_add : Icons.send,
                      color: context.colors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // * Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: context.colors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppText(
                          'OR',
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Expanded(child: Divider(color: context.colors.border)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // * Login Link
                  Center(
                    child: TextButton(
                      onPressed: () => const LoginRoute().go(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            'Already have an account? ',
                            style: AppTextStyle.bodyMedium,
                          ),
                          AppText(
                            'Login',
                            style: AppTextStyle.bodyMedium,
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
