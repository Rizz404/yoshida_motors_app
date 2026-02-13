import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:car_rongsok_app/core/constants/storage_key_constant.dart';
import 'package:car_rongsok_app/core/themes/app_theme.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:car_rongsok_app/di/auth_providers.dart';
import 'package:car_rongsok_app/di/common_providers.dart';
import 'package:car_rongsok_app/di/service_providers.dart';
import 'package:car_rongsok_app/firebase_options.dart';
import 'package:car_rongsok_app/l10n/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;

// * Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  logger.info('Background FCM message: ${message.messageId}');

  // * Notifikasi akan otomatis ditampilkan oleh sistem saat app di background/terminated
  // * FCM SDK akan handle notifikasi secara native jika ada notification payload
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // * Initialize Talker logger
  TalkerConfig.initialize();

  try {
    // * Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // * Setup Firebase Messaging background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // * Initialize timezone database for scheduled notifications
    tz.initializeTimeZones();

    // * Pre-cache main font selagi splash screen
    await GoogleFonts.pendingFonts();

    // * Storage
    const secureStorage = FlutterSecureStorage();
    final preferencesWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {StorageKeyConstant.userKey},
      ),
    );
    final preferences = await SharedPreferences.getInstance();

    // * Jangan remove splash dulu, tunggu auth state selesai loading
    // * Splash akan di-remove otomatis oleh CarRongsokApp setelah auth check

    runApp(
      ProviderScope(
        overrides: [
          secureStorageProvider.overrideWithValue(secureStorage),
          sharedPreferencesWithCacheProvider.overrideWithValue(
            preferencesWithCache,
          ),
          sharedPreferencesProvider.overrideWithValue(preferences),
        ],
        observers: [TalkerConfig.riverpodObserver],
        child: const CarRongsokApp(),
      ),
    );
  } catch (e) {
    FlutterNativeSplash.remove();
    logger.error('Error initializing app', e);

    runApp(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(body: Center(child: Text('Error initializing app'))),
        ),
      ),
    );
  }
}

class CarRongsokApp extends ConsumerStatefulWidget {
  const CarRongsokApp({super.key});

  @override
  ConsumerState<CarRongsokApp> createState() => _CarRongsokAppState();
}

class _CarRongsokAppState extends ConsumerState<CarRongsokApp> {
  @override
  void initState() {
    super.initState();
    // * Initialize local notification service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalNotifications();
    });
  }

  Future<void> _initializeLocalNotifications() async {
    final localNotificationService = ref.read(localNotificationServiceProvider);
    await localNotificationService.initialize(
      onNotificationTap: _onNotificationTap,
    );

    // * Setup foreground message handler
    _setupForegroundMessageHandler();

    // * Setup notification opened app handler (background)
    _setupNotificationOpenedHandler();

    // * Check initial FCM message (terminated state)
    await _checkInitialMessage();

    // * Check if app was launched from local notification tap
    await _checkLocalNotificationAppLaunch();
  }

  // * Handle FCM message saat app di foreground
  void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.info('Foreground FCM message: ${message.messageId}');

      final notification = message.notification;
      final data = message.data.map((k, v) => MapEntry(k, v.toString()));

      if (notification != null) {
        // * Show local notification
        final localNotificationService = ref.read(
          localNotificationServiceProvider,
        );

        localNotificationService.showNotificationWithData(
          id: message.messageId.hashCode,
          title: notification.title ?? 'New Notification',
          body: notification.body ?? '',
          data: data,
          highPriority: true,
        );
      }
    });
  }

  // * Handle notification opened from background
  void _setupNotificationOpenedHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.info('Notification opened app: ${message.messageId}');
      _handleNotificationNavigation(message.data);
    });
  }

  // * Check initial message (app opened from terminated state)
  Future<void> _checkInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      logger.info('App opened from notification: ${initialMessage.messageId}');
      _handleNotificationNavigation(initialMessage.data);
    }
  }

  // * Handle notification navigation based on data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final dataString = data.map((k, v) => MapEntry(k, v.toString()));
    logger.info('Handling notification navigation with data: $dataString');

    // * Delay navigation sampai router ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = ref.read(routerProvider);
      final navigationService = ref.read(notificationNavigationServiceProvider);
      navigationService.handleNotificationNavigation(router, dataString);
    });
  }

  // * Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    logger.info('Local notification tapped: ${response.payload}');

    if (response.payload != null && response.payload!.isNotEmpty) {
      final navigationService = ref.read(notificationNavigationServiceProvider);
      final params = navigationService.parsePayload(response.payload);
      logger.info('Notification payload params: $params');

      // * Navigate to relevant screen
      final router = ref.read(routerProvider);
      navigationService.handleNotificationNavigation(router, params);
    }
  }

  // * Check if app was launched from local notification tap (terminated state)
  Future<void> _checkLocalNotificationAppLaunch() async {
    final localNotificationService = ref.read(localNotificationServiceProvider);
    final launchDetails = await localNotificationService.getAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails!.notificationResponse?.payload;
      logger.info('App launched from local notification: $payload');

      if (payload != null && payload.isNotEmpty) {
        final navigationService = ref.read(
          notificationNavigationServiceProvider,
        );
        final params = navigationService.parsePayload(payload);
        logger.info('Local notification launch params: $params');

        // * Delay navigation sampai router dan auth state ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final router = ref.read(routerProvider);
          navigationService.handleNotificationNavigation(router, params);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final botToastBuilder = BotToastInit();

    // * Remove native splash setelah auth state selesai loading
    ref.listen(authNotifierProvider, (previous, next) {
      if (!next.isLoading && (previous?.isLoading ?? true)) {
        FlutterNativeSplash.remove();
      }

      // * Handle FCM token based on auth state changes
      next.whenData((authState) {
        final previousUser = previous?.whenOrNull(data: (state) => state.user);
        final currentUser = authState.user;

        // * Initialize FCM token saat user berhasil login
        if (currentUser != null && previousUser == null) {
          final fcmTokenManager = ref.read(fcmTokenManagerProvider);
          fcmTokenManager.initialize();
        }
        // * Clear FCM token saat logout
        else if (currentUser == null && previousUser != null) {
          final fcmTokenManager = ref.read(fcmTokenManagerProvider);
          fcmTokenManager.clearToken();
        }
      });
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sigma Asset',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: botToastBuilder,

      // * Router Configuration
      routerConfig: router,

      // * Localization Configuration
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      locale: currentLocale,

      // * Locale Resolution Strategy
      localeResolutionCallback: (locale, supportedLocales) {
        // * If device locale is supported, use it
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          // * If exact match not found, try language code only
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }

        // * Fallback to first supported locale (should be 'en')
        return supportedLocales.first;
      },
    );
  }
}
