import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// * Background notification tap handler - must be top-level function
@pragma('vm:entry-point')
void onBackgroundNotificationTap(NotificationResponse response) {
  // ! Background handler tidak punya akses ke context/providers
  // * Data akan disimpan dan diproses saat app dibuka
  logger.info('Background notification tapped: ${response.payload}');
}

/// Service untuk handle native local notifications
class LocalNotificationService {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  // * Notification channel config for Android
  // ! IMPORTANT: Sound files must be .ogg or .wav format in android/app/src/main/res/raw/
  // ! Reference by name WITHOUT extension
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'car_rongsok_app_default', // id
        'Default Notifications', // name
        description: 'General notifications from Sigma Asset',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        showBadge: true,
        sound: RawResourceAndroidNotificationSound(
          'notification_sound',
        ), // * No .ogg extension
      );

  static const AndroidNotificationChannel _highPriorityChannel =
      AndroidNotificationChannel(
        'car_rongsok_app_high_priority', // id
        'High Priority Notifications', // name
        description: 'Important notifications that require immediate attention',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        showBadge: true,
        sound: RawResourceAndroidNotificationSound(
          'high_priority_sound',
        ), // * No .ogg extension
      );

  // * Initialize plugin
  Future<void> initialize({
    void Function(NotificationResponse)? onNotificationTap,
  }) async {
    try {
      // Android settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS/macOS settings
      const darwinSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _plugin.initialize(
        settings: initSettings,

        onDidReceiveNotificationResponse: onNotificationTap,
        // * Handler untuk notification tap saat app di background/terminated
        onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTap,
      );

      // Create Android notification channels
      await _createNotificationChannels();

      // Request permissions
      await _requestPermissions();

      logService('Local notification service initialized');
    } catch (e, s) {
      logError('Failed to initialize local notification service', e, s);
    }
  }

  // * Check if app was launched from notification tap
  Future<NotificationAppLaunchDetails?> getAppLaunchDetails() async {
    try {
      return await _plugin.getNotificationAppLaunchDetails();
    } catch (e, s) {
      logError('Failed to get notification app launch details', e, s);
      return null;
    }
  }

  // * Create notification channels (Android 8+)
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_defaultChannel);
      await androidPlugin.createNotificationChannel(_highPriorityChannel);
      logInfo('Notification channels created');
    }
  }

  // * Request notification permissions
  Future<void> _requestPermissions() async {
    // Android 13+ permission
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      logInfo('Android notification permission: $granted');
    }

    // iOS permission
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      logInfo('iOS notification permission: $granted');
    }
  }

  // * Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool highPriority = false,
  }) async {
    try {
      final channel = highPriority ? _highPriorityChannel : _defaultChannel;

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
        enableVibration: channel.enableVibration,
        playSound: channel.playSound,
        sound: channel.sound,
        showWhen: true,
        ticker: body,
        styleInformation: BigTextStyleInformation(body),
      );

      // ! iOS sound must be .caf format in ios/Runner/Resources/
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // * iOS will use default sound if file not found
        interruptionLevel: InterruptionLevel.active,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );

      logInfo('Notification shown - ID: $id, Title: $title');
    } catch (e, s) {
      logError('Failed to show notification', e, s);
    }
  }

  // * Show notification with custom data
  Future<void> showNotificationWithData({
    required int id,
    required String title,
    required String body,
    required Map<String, String> data,
    bool highPriority = false,
  }) async {
    // Encode data as JSON string for payload
    final payload = data.entries.map((e) => '${e.key}=${e.value}').join('&');

    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      highPriority: highPriority,
    );
  }

  // * Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    bool highPriority = false,
  }) async {
    try {
      final channel = highPriority ? _highPriorityChannel : _defaultChannel;

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
        sound: channel.sound,
      );

      // ! iOS sound must be .caf format in ios/Runner/Resources/
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // * iOS will use default sound if file not found
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      logInfo('Notification scheduled - ID: $id at $scheduledDate');
    } catch (e, s) {
      logError('Failed to schedule notification', e, s);
    }
  }

  // * Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id: id);
      logInfo('Notification cancelled - ID: $id');
    } catch (e, s) {
      logError('Failed to cancel notification', e, s);
    }
  }

  // * Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      logInfo('All notifications cancelled');
    } catch (e, s) {
      logError('Failed to cancel all notifications', e, s);
    }
  }

  // * Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _plugin.pendingNotificationRequests();
    } catch (e, s) {
      logError('Failed to get pending notifications', e, s);
      return [];
    }
  }

  // * Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        return await androidPlugin.getActiveNotifications();
      }
      return [];
    } catch (e, s) {
      logError('Failed to get active notifications', e, s);
      return [];
    }
  }
}
