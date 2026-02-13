import 'package:car_rongsok_app/core/services/auth_service.dart';
import 'package:car_rongsok_app/core/services/fcm_token_manager.dart';
import 'package:car_rongsok_app/core/services/firebase_messaging_service.dart';
import 'package:car_rongsok_app/core/services/language_storage_service.dart';
import 'package:car_rongsok_app/core/services/local_notification_service.dart';
import 'package:car_rongsok_app/core/services/notification_navigation_service.dart';
import 'package:car_rongsok_app/core/services/theme_storage_service.dart';
import 'package:car_rongsok_app/di/common_providers.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPreferencesWithCache = ref.watch(
    sharedPreferencesWithCacheProvider,
  );
  return AuthServiceImpl(secureStorage, sharedPreferencesWithCache);
});

final languageStorageServiceProvider = Provider<LanguageStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LanguageStorageServiceImpl(_sharedPreferences);
});

final themeStorageServiceProvider = Provider<ThemeStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return ThemeStorageServiceImpl(_sharedPreferences);
});

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return FirebaseMessagingService(messaging);
});

// * Flutter Local Notifications Plugin provider
final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
      return FlutterLocalNotificationsPlugin();
    });

// * Local Notification Service provider
final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  final plugin = ref.watch(flutterLocalNotificationsPluginProvider);
  return LocalNotificationService(plugin);
});

// * FCM Token Manager provider
final fcmTokenManagerProvider = Provider<FcmTokenManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final messagingService = ref.watch(firebaseMessagingServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return FcmTokenManager(prefs, messagingService, authRepository);
});

// * Notification Navigation Service provider
final notificationNavigationServiceProvider =
    Provider<NotificationNavigationService>((ref) {
      return const NotificationNavigationService();
    });
