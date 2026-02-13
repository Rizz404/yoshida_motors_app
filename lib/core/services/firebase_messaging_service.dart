import 'package:car_rongsok_app/core/extensions/logger_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging;

  FirebaseMessagingService(this._messaging);

  // * Request notification permissions (iOS)
  Future<bool> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (isGranted) {
        logService('Notification permission granted');
      } else {
        logService('Notification permission denied');
      }

      return isGranted;
    } catch (e, s) {
      logError('Failed to request notification permission', e, s);
      return false;
    }
  }

  // * Get FCM token
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        logService('FCM Token: $token');
      }
      return token;
    } catch (e, s) {
      logError('Failed to get FCM token', e, s);
      return null;
    }
  }

  // * Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      logService('Subscribed to topic: $topic');
    } catch (e, s) {
      logError('Failed to subscribe to topic: $topic', e, s);
    }
  }

  // * Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      logService('Unsubscribed from topic: $topic');
    } catch (e, s) {
      logError('Failed to unsubscribe from topic: $topic', e, s);
    }
  }

  // * Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      logService('FCM token deleted');
    } catch (e, s) {
      logError('Failed to delete FCM token', e, s);
    }
  }

  // * Setup foreground message handler
  void setupForegroundMessageHandler(void Function(RemoteMessage) onMessage) {
    FirebaseMessaging.onMessage.listen((message) {
      logService('Foreground message received: ${message.messageId}');
      onMessage(message);
    });
  }

  // * Setup notification opened app handler
  void setupNotificationOpenedAppHandler(
    void Function(RemoteMessage) onNotificationOpened,
  ) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      logService('Notification opened app: ${message.messageId}');
      onNotificationOpened(message);
    });
  }

  // * Get initial notification (when app opened from quit state)
  Future<RemoteMessage?> getInitialMessage() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) {
        logService('App opened from notification: ${message.messageId}');
      }
      return message;
    } catch (e, s) {
      logError('Failed to get initial message', e, s);
      return null;
    }
  }

  // * Enable/disable auto-initialization
  Future<void> setAutoInitEnabled(bool enabled) async {
    try {
      await _messaging.setAutoInitEnabled(enabled);
      logService('FCM auto-init ${enabled ? "enabled" : "disabled"}');
    } catch (e, s) {
      logError('Failed to set auto-init', e, s);
    }
  }
}
