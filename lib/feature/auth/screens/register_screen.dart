import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';
import 'package:car_rongsok_app/di/auth_providers.dart';
import 'package:car_rongsok_app/di/common_providers.dart';
import 'package:car_rongsok_app/di/service_providers.dart';
import 'package:car_rongsok_app/feature/auth/models/email_register_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/login_payload.dart';
import 'package:car_rongsok_app/feature/auth/validators/register_validators.dart';
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
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _emailFormKey = GlobalKey<FormBuilderState>();
  late TabController _tabController;
  String? _password;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _registerWithEmail() async {
    if (!(_emailFormKey.currentState?.saveAndValidate() ?? false)) return;

    final formData = _emailFormKey.currentState!.value;
    final email = formData['email'] as String;
    final password = formData['password'] as String;
    final name = formData['name'] as String?;
    final address = formData['address'] as String?;

    final emailAuthService = ref.read(emailAuthServiceProvider);
    final fcmService = ref.read(firebaseMessagingServiceProvider);

    context.loaderOverlay.show();

    final idToken = await emailAuthService.registerWithEmail(
      email: email,
      password: password,
      onError: (error) {
        if (!mounted) return;
        context.loaderOverlay.hide();
        AppToast.error(error);
      },
    );

    if (!mounted) return;
    if (idToken == null) {
      context.loaderOverlay.hide();
      return;
    }

    final fcmToken = await fcmService.getToken();
    final payload = EmailRegisterPayload(
      idToken: idToken,
      name: name?.isNotEmpty == true ? name : null,
      address: address?.isNotEmpty == true ? address : null,
      fcmToken: fcmToken,
    );

    await ref.read(authNotifierProvider.notifier).registerWithEmail(payload);

    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  Future<void> _registerWithGoogle() async {
    final googleAuthService = ref.read(googleAuthServiceProvider);
    final fcmService = ref.read(firebaseMessagingServiceProvider);

    context.loaderOverlay.show();

    final idToken = await googleAuthService.signInWithGoogle(
      onError: (error) {
        if (!mounted) return;
        context.loaderOverlay.hide();
        AppToast.error(error);
      },
    );

    if (!mounted) return;
    if (idToken == null) {
      context.loaderOverlay.hide();
      return;
    }

    final fcmToken = await fcmService.getToken();
    final payload = LoginPayload(idToken: idToken, fcmToken: fcmToken);

    // * Google auto register+login via /auth/login/google
    await ref.read(authNotifierProvider.notifier).loginWithGoogle(payload);

    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  void _handleAuthStateChange(
    AsyncValue<AuthState>? previous,
    AsyncValue<AuthState> next,
  ) {
    if (previous?.isLoading == true) {
      next.whenData((authState) {
        if (authState.status == AuthStatus.authenticated) {
          AppToast.success('Registration successful');
        } else if (authState.failure != null) {
          final message = authState.failure?.message ?? 'Registration failed';
          AppToast.error(message);

          // * If user already exists, suggest login
          if (message.contains('already registered')) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) context.router.replace(const LoginRoute());
            });
          }
        }
      });
      if (next is AsyncError) {
        AppToast.error('Registration error: ${next.error}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(
      authNotifierProvider,
      _handleAuthStateChange,
    );

    return AppLoaderOverlay(
      child: Scaffold(
        body: ScreenWrapper(
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
                  'Register to get started',
                  style: AppTextStyle.bodyLarge,
                  color: context.colors.textSecondary,
                ),
                const SizedBox(height: 32),

                // * Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: context.colors.textOnPrimary,
                    unselectedLabelColor: context.colors.textSecondary,
                    tabs: const [
                      Tab(text: 'Email'),
                      Tab(text: 'Phone OTP'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // * Tab Content
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEmailRegisterForm(context),
                      _buildPhoneRegisterInfo(context),
                    ],
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
                    onPressed: () => context.router.replace(const LoginRoute()),
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
    );
  }

  Widget _buildEmailRegisterForm(BuildContext context) {
    return FormBuilder(
      key: _emailFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppTextField(
              name: 'email',
              label: 'Email',
              placeHolder: 'john@example.com',
              type: AppTextFieldType.email,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.colors.primary,
              ),
              validator: RegisterValidators.emailRequired(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              name: 'password',
              label: 'Password',
              placeHolder: '••••••',
              type: AppTextFieldType.password,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: context.colors.primary,
              ),
              validator: RegisterValidators.password(),
              onChanged: (val) => setState(() => _password = val),
            ),
            const SizedBox(height: 12),
            AppTextField(
              name: 'confirm_password',
              label: 'Confirm Password',
              placeHolder: '••••••',
              type: AppTextFieldType.password,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: context.colors.primary,
              ),
              validator: RegisterValidators.confirmPassword(_password),
            ),
            const SizedBox(height: 12),

            // * Optional fields
            AppTextField(
              name: 'name',
              label: 'Full Name (Optional)',
              placeHolder: 'John Doe',
              type: AppTextFieldType.text,
              prefixIcon: Icon(
                Icons.person_outline,
                color: context.colors.primary,
              ),
              validator: RegisterValidators.fullName(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              name: 'address',
              label: 'Address (Optional)',
              placeHolder: 'Jakarta Selatan',
              type: AppTextFieldType.text,
              maxLines: 2,
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: context.colors.primary,
              ),
              validator: RegisterValidators.address(),
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'Register',
              onPressed: _registerWithEmail,
              leadingIcon: Icon(
                Icons.person_add,
                color: context.colors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'Continue with Google',
              onPressed: _registerWithGoogle,
              variant: AppButtonVariant.outlined,
              leadingIcon: const Icon(Icons.g_mobiledata_rounded, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneRegisterInfo(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.phone_disabled_outlined,
            size: 48,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 16),
          AppText(
            'Phone OTP Temporarily Disabled',
            style: AppTextStyle.titleMedium,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AppText(
            'Please use Email or Google Sign-In to continue.',
            style: AppTextStyle.bodyMedium,
            color: context.colors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
