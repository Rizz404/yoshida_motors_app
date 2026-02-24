import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/di/auth_providers.dart';
import 'package:car_rongsok_app/di/common_providers.dart';
import 'package:car_rongsok_app/shared/widgets/app_image.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// * Navigation Drawer
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Drawer(
      child: authState.when(
        data: (state) {
          if (state.status != AuthStatus.authenticated) {
            return _buildUnauthenticatedDrawer(context);
          }
          return _buildAuthenticatedDrawer(context, ref, state);
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: context.colorScheme.primary),
        ),
        error: (_, __) => _buildUnauthenticatedDrawer(context),
      ),
    );
  }

  Widget _buildUnauthenticatedDrawer(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppText(
              context.l10n.appEndDrawerPleaseLoginFirst,
              style: AppTextStyle.bodyMedium,
              color: context.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedDrawer(
    BuildContext context,
    WidgetRef ref,
    AuthState state,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildUserInfo(context, state),
          const Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context: context,
                  icon: Icons.home_rounded,
                  title: 'Home',
                  route: const HomeRoute(),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.assignment_rounded,
                  title: 'Appraisal',
                  route: const ListAppraisalsRoute(),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.notifications_rounded,
                  title: 'Notification',
                  route: const ListNotificationsRoute(),
                ),
              ],
            ),
          ),
          const Divider(),
          _buildSettingsSection(context, ref),
          _buildLogoutButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: context.colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppImage(
                size: ImageSize.large,
                assetPath: 'assets/images/app-logo.png',
                backgroundColor: context.colorScheme.primaryContainer,
                shape: ImageShape.rectangle,
              ),
              const SizedBox(width: 8),
              AppText(
                context.l10n.appEndDrawerTitle,
                style: AppTextStyle.titleLarge,
                color: context.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, AuthState state) {
    final user = state.user;
    if (user == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        context.router.maybePop();
        context.router.push(const ProfileRoute());
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AppImage(
              size: ImageSize.large,
              shape: ImageShape.circle,
              placeholder: Icon(
                Icons.person,
                size: 24,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    user.name ?? 'No Name',
                    style: AppTextStyle.titleMedium,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    user.email ?? user.phoneNumber ?? '',
                    style: AppTextStyle.bodySmall,
                    color: context.colorScheme.onSurfaceVariant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required PageRouteInfo route,
  }) {
    final isActive = context.router.current.name == route.routeName;

    return ListTile(
      leading: Icon(
        icon,
        color: isActive
            ? context.colorScheme.primary
            : context.colorScheme.onSurface,
      ),
      title: AppText(
        title,
        style: AppTextStyle.bodyLarge,
        color: isActive ? context.colorScheme.primary : null,
        fontWeight: isActive ? FontWeight.bold : null,
      ),
      selected: isActive,
      selectedTileColor: context.colorScheme.primaryContainer.withOpacity(0.3),
      onTap: () {
        if (isActive) {
          context.router.maybePop();
        } else {
          context.router.maybePop();
          context.router.push(route);
        }
      },
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // * Theme Switcher
        ListTile(
          leading: Icon(
            Icons.brightness_6,
            color: context.colorScheme.onSurface,
          ),
          title: AppText(
            context.l10n.appEndDrawerTheme,
            style: AppTextStyle.bodyLarge,
          ),
          trailing: _buildThemeSwitch(context, ref),
        ),
        // * Language Switcher
        ListTile(
          leading: Icon(Icons.language, color: context.colorScheme.onSurface),
          title: AppText(
            context.l10n.appEndDrawerLanguage,
            style: AppTextStyle.bodyLarge,
          ),
          trailing: _buildLanguageDropdown(context, ref),
        ),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && context.isDarkMode);

    return Switch(
      value: isDark,
      onChanged: (value) {
        ref
            .read(themeProvider.notifier)
            .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
      },
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return DropdownButton<Locale>(
      value: currentLocale,
      underline: const SizedBox.shrink(),
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇬🇧'),
              const SizedBox(width: 8),
              AppText(
                context.l10n.appEndDrawerEnglish,
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
        DropdownMenuItem(
          value: const Locale('id'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇮🇩'),
              const SizedBox(width: 8),
              AppText(
                context.l10n.appEndDrawerIndonesian,
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
        DropdownMenuItem(
          value: const Locale('ja'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇯🇵'),
              const SizedBox(width: 8),
              AppText(
                context.l10n.appEndDrawerJapanese,
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          ref.read(localeProvider.notifier).changeLocale(newLocale);
        }
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            context.router.maybePop();
            ref.read(authNotifierProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout),
          label: Text(context.l10n.appEndDrawerLogout),
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
        ),
      ),
    );
  }
}
