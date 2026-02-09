// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:car_rongsok_app/core/enums/model_entity_enums.dart';
// import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
// import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
// import 'package:car_rongsok_app/shared/widgets/app_image.dart';
// import 'package:car_rongsok_app/shared/widgets/app_text.dart';

// /// * End Drawer dengan konten berbeda berdasarkan role user
// class AppEndDrawer extends ConsumerWidget {
//   const AppEndDrawer({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authNotifierProvider);

//     return Drawer(
//       child: authState.when(
//         data: (state) {
//           if (state.status != AuthStatus.authenticated) {
//             return _buildUnauthenticatedDrawer(context);
//           }

//           final isAdmin = state.user?.role == UserRole.admin;
//           final isStaff = state.user?.role == UserRole.staff;

//           if (isAdmin) {
//             return _buildAdminDrawer(context, ref, state);
//           } else if (isStaff) {
//             return _buildStaffDrawer(context, ref, state);
//           } else {
//             return _buildUserDrawer(context, ref, state);
//           }
//         },
//         loading: () => Center(
//           child: CircularProgressIndicator(color: context.colorScheme.primary),
//         ),
//         error: (_, __) => _buildUnauthenticatedDrawer(context),
//       ),
//     );
//   }

//   Widget _buildUnauthenticatedDrawer(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildDrawerHeader(context),
//           const Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: AppText(
//               context.l10n.appEndDrawerPleaseLoginFirst,
//               style: AppTextStyle.bodyMedium,
//               color: context.colorScheme.onSurface,
//             ),
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserDrawer(
//     BuildContext context,
//     WidgetRef ref,
//     AuthState state,
//   ) {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildDrawerHeader(context),
//           _buildUserInfo(context, state),
//           const Divider(),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.home,
//                   title: context.l10n.appEndDrawerHome,
//                   route: RouteConstant.home,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.qr_code_scanner,
//                   title: context.l10n.appEndDrawerScanAsset,
//                   route: RouteConstant.scanAsset,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.inventory_2,
//                   title: context.l10n.appEndDrawerMyAssets,
//                   route: RouteConstant.myAssets,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.notifications,
//                   title: context.l10n.appEndDrawerNotifications,
//                   route: RouteConstant.myNotifications,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.report_problem,
//                   title: context.l10n.appEndDrawerMyIssueReports,
//                   route: RouteConstant.myIssueReports,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.person,
//                   title: context.l10n.appEndDrawerProfile,
//                   route: RouteConstant.userDetailProfile,
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           _buildSettingsSection(context, ref),
//           _buildLogoutButton(context, ref),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdminDrawer(
//     BuildContext context,
//     WidgetRef ref,
//     AuthState state,
//   ) {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildDrawerHeader(context),
//           _buildUserInfo(context, state),
//           const Divider(),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.dashboard,
//                   title: context.l10n.appEndDrawerDashboard,
//                   route: RouteConstant.adminDashboard,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.qr_code_scanner,
//                   title: context.l10n.appEndDrawerScanAsset,
//                   route: RouteConstant.adminScanAsset,
//                 ),
//                 const Divider(),
//                 // * Management Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//                   child: AppText(
//                     context.l10n.appEndDrawerManagementSection,
//                     style: AppTextStyle.labelSmall,
//                     color: context.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.inventory_2,
//                   title: context.l10n.appEndDrawerAssets,
//                   route: RouteConstant.adminAssets,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.swap_horiz,
//                   title: context.l10n.appEndDrawerAssetMovements,
//                   route: RouteConstant.adminAssetMovements,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.category,
//                   title: context.l10n.appEndDrawerCategories,
//                   route: RouteConstant.adminCategories,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.location_on,
//                   title: context.l10n.appEndDrawerLocations,
//                   route: RouteConstant.adminLocations,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.people,
//                   title: context.l10n.appEndDrawerUsers,
//                   route: RouteConstant.adminUsers,
//                 ),
//                 const Divider(),
//                 // * Maintenance Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//                   child: AppText(
//                     context.l10n.appEndDrawerMaintenanceSection,
//                     style: AppTextStyle.labelSmall,
//                     color: context.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.schedule,
//                   title: context.l10n.appEndDrawerMaintenanceSchedules,
//                   route: RouteConstant.adminMaintenanceSchedules,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.history,
//                   title: context.l10n.appEndDrawerMaintenanceRecords,
//                   route: RouteConstant.adminMaintenanceRecords,
//                 ),
//                 const Divider(),
//                 // * Reports Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//                   child: AppText(
//                     context.l10n.appEndDrawerReports,
//                     style: AppTextStyle.labelSmall,
//                     color: context.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.report_problem,
//                   title: context.l10n.appEndDrawerIssueReports,
//                   route: RouteConstant.adminIssueReports,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.history_toggle_off,
//                   title: context.l10n.appEndDrawerScanLogs,
//                   route: RouteConstant.adminScanLogs,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.notifications,
//                   title: context.l10n.appEndDrawerNotifications,
//                   route: RouteConstant.adminNotifications,
//                 ),
//                 const Divider(),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.person,
//                   title: context.l10n.appEndDrawerProfile,
//                   route: RouteConstant.adminUserDetailProfile,
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           _buildSettingsSection(context, ref),
//           _buildLogoutButton(context, ref),
//         ],
//       ),
//     );
//   }

//   Widget _buildStaffDrawer(
//     BuildContext context,
//     WidgetRef ref,
//     AuthState state,
//   ) {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildDrawerHeader(context),
//           _buildUserInfo(context, state),
//           const Divider(),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.dashboard,
//                   title: context.l10n.appEndDrawerDashboard,
//                   route: RouteConstant.staffDashboard,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.qr_code_scanner,
//                   title: context.l10n.appEndDrawerScanAsset,
//                   route: RouteConstant.staffScanAsset,
//                 ),
//                 const Divider(),
//                 // * Management Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//                   child: AppText(
//                     context.l10n.appEndDrawerManagementSection,
//                     style: AppTextStyle.labelSmall,
//                     color: context.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.inventory_2,
//                   title: context.l10n.appEndDrawerAssets,
//                   route: RouteConstant.staffAssets,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.swap_horiz,
//                   title: context.l10n.appEndDrawerAssetMovements,
//                   route: RouteConstant.staffAssetMovements,
//                 ),
//                 const Divider(),
//                 // * Maintenance Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//                   child: AppText(
//                     context.l10n.appEndDrawerMaintenanceSection,
//                     style: AppTextStyle.labelSmall,
//                     color: context.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.schedule,
//                   title: context.l10n.appEndDrawerMaintenanceSchedules,
//                   route: RouteConstant.staffMaintenanceSchedules,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.history,
//                   title: context.l10n.appEndDrawerMaintenanceRecords,
//                   route: RouteConstant.staffMaintenanceRecords,
//                 ),
//                 const Divider(),
//                 // * Reports Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//                   child: AppText(
//                     context.l10n.appEndDrawerReports,
//                     style: AppTextStyle.labelSmall,
//                     color: context.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.report_problem,
//                   title: context.l10n.appEndDrawerIssueReports,
//                   route: RouteConstant.staffIssueReports,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.history_toggle_off,
//                   title: context.l10n.appEndDrawerScanLogs,
//                   route: RouteConstant.staffScanLogs,
//                 ),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.notifications,
//                   title: context.l10n.appEndDrawerNotifications,
//                   route: RouteConstant.staffNotifications,
//                 ),
//                 const Divider(),
//                 _buildDrawerTile(
//                   context: context,
//                   icon: Icons.person,
//                   title: context.l10n.appEndDrawerProfile,
//                   route: RouteConstant.staffUserDetailProfile,
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           _buildSettingsSection(context, ref),
//           _buildLogoutButton(context, ref),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(color: context.colorScheme.primaryContainer),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               AppImage(
//                 size: ImageSize.large,
//                 assetPath: 'assets/images/app-logo.png',
//                 backgroundColor: context.colorScheme.primaryContainer,
//                 shape: ImageShape.rectangle,
//               ),
//               const SizedBox(width: 8),
//               AppText(
//                 context.l10n.appEndDrawerTitle,
//                 style: AppTextStyle.titleLarge,
//                 color: context.colorScheme.onPrimaryContainer,
//                 fontWeight: FontWeight.bold,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo(BuildContext context, AuthState state) {
//     final user = state.user;
//     if (user == null) return const SizedBox.shrink();

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           AppImage(
//             size: ImageSize.large,
//             imageUrl: user.avatarUrl,
//             shape: ImageShape.circle,
//             placeholder: Icon(
//               Icons.person,
//               size: 24,
//               color: context.colorScheme.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   user.name,
//                   style: AppTextStyle.titleMedium,
//                   fontWeight: FontWeight.bold,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 AppText(
//                   user.email,
//                   style: AppTextStyle.bodySmall,
//                   color: context.colorScheme.onSurfaceVariant,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String route,
//   }) {
//     final currentLocation = GoRouterState.of(context).uri.path;
//     final isActive = currentLocation == route;

//     return ListTile(
//       leading: Icon(
//         icon,
//         color: isActive
//             ? context.colorScheme.primary
//             : context.colorScheme.onSurface,
//       ),
//       title: AppText(
//         title,
//         style: AppTextStyle.bodyLarge,
//         color: isActive ? context.colorScheme.primary : null,
//         fontWeight: isActive ? FontWeight.bold : null,
//       ),
//       selected: isActive,
//       selectedTileColor: context.colorScheme.primaryContainer.withOpacity(0.3),
//       onTap: () {
//         if (isActive) {
//           // * Close drawer saja jika sudah di route yang sama
//           context.pop();
//         } else {
//           // * Navigate ke route baru
//           context.pop();
//           context.push(route);
//         }
//       },
//     );
//   }

//   Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
//     return Column(
//       children: [
//         // * Theme Switcher
//         ListTile(
//           leading: Icon(
//             Icons.brightness_6,
//             color: context.colorScheme.onSurface,
//           ),
//           title: AppText(
//             context.l10n.appEndDrawerTheme,
//             style: AppTextStyle.bodyLarge,
//           ),
//           trailing: _buildThemeSwitch(context, ref),
//         ),
//         // * Language Switcher
//         ListTile(
//           leading: Icon(Icons.language, color: context.colorScheme.onSurface),
//           title: AppText(
//             context.l10n.appEndDrawerLanguage,
//             style: AppTextStyle.bodyLarge,
//           ),
//           trailing: _buildLanguageDropdown(context, ref),
//         ),
//       ],
//     );
//   }

//   Widget _buildThemeSwitch(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);
//     final isDark =
//         themeMode == ThemeMode.dark ||
//         (themeMode == ThemeMode.system && context.isDarkMode);

//     return Switch(
//       value: isDark,
//       onChanged: (value) {
//         ref
//             .read(themeProvider.notifier)
//             .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
//       },
//     );
//   }

//   Widget _buildLanguageDropdown(BuildContext context, WidgetRef ref) {
//     final currentLocale = ref.watch(localeProvider);

//     return DropdownButton<Locale>(
//       value: currentLocale,
//       underline: const SizedBox.shrink(),
//       items: [
//         DropdownMenuItem(
//           value: const Locale('en'),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('🇬🇧'),
//               const SizedBox(width: 8),
//               AppText(
//                 context.l10n.appEndDrawerEnglish,
//                 style: AppTextStyle.bodyMedium,
//               ),
//             ],
//           ),
//         ),
//         DropdownMenuItem(
//           value: const Locale('id'),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('🇮🇩'),
//               const SizedBox(width: 8),
//               AppText(
//                 context.l10n.appEndDrawerIndonesian,
//                 style: AppTextStyle.bodyMedium,
//               ),
//             ],
//           ),
//         ),
//         DropdownMenuItem(
//           value: const Locale('ja'),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('🇯🇵'),
//               const SizedBox(width: 8),
//               AppText(
//                 context.l10n.appEndDrawerJapanese,
//                 style: AppTextStyle.bodyMedium,
//               ),
//             ],
//           ),
//         ),
//       ],
//       onChanged: (Locale? newLocale) {
//         if (newLocale != null) {
//           ref.read(localeProvider.notifier).changeLocale(newLocale);
//         }
//       },
//     );
//   }

//   Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.infinity,
//         child: FilledButton.icon(
//           onPressed: () {
//             Navigator.of(context).pop();
//             ref.read(authNotifierProvider.notifier).logout();
//           },
//           icon: const Icon(Icons.logout),
//           label: Text(context.l10n.appEndDrawerLogout),
//           style: FilledButton.styleFrom(
//             backgroundColor: context.colorScheme.error,
//             foregroundColor: context.colorScheme.onError,
//           ),
//         ),
//       ),
//     );
//   }
// }
