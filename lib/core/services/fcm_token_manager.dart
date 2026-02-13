import 'package:car_rongsok_app/core/constants/storage_key_constant.dart';
import 'package:car_rongsok_app/core/extensions/logger_extension.dart';
import 'package:car_rongsok_app/core/services/firebase_messaging_service.dart';
import 'package:car_rongsok_app/feature/auth/models/update_profile_payload.dart';
import 'package:car_rongsok_app/feature/auth/repositories/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk manage FCM token lifecycle
/// Token akan di-sync ke backend hanya saat:
/// 1. User login pertama kali
/// 2. Token berubah (onTokenRefresh)
/// 3. Token berbeda dengan yang tersimpan di local storage
class FcmTokenManager {
  final SharedPreferences _prefs;
  final FirebaseMessagingService _messagingService;
  final AuthRepository _authRepository;

  static const _syncCooldown = Duration(hours: 1); // * Prevent spam sync

  FcmTokenManager(this._prefs, this._messagingService, this._authRepository);

  // * Initialize FCM token management
  Future<void> initialize() async {
    logService('Initializing FCM token manager');

    // * Request permission first
    final isGranted = await _messagingService.requestPermission();

    if (!isGranted) {
      logService('Notification permission not granted, skipping FCM setup');
      return;
    }

    // * Get current token
    final currentToken = await _messagingService.getToken();
    if (currentToken == null) {
      logError('Failed to get FCM token');
      return;
    }

    // * Check if token needs sync
    await _syncTokenIfNeeded(currentToken);

    // * Listen for token refresh
    _setupTokenRefreshListener();
  }

  // * Setup listener untuk token refresh
  void _setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) async {
        logService('FCM token refreshed: $newToken');
        await _syncTokenToBackend(newToken, forceSync: true);
      },
      onError: (Object error, StackTrace stackTrace) {
        logError('FCM token refresh error', error, stackTrace);
      },
    );
  }

  // * Sync token hanya jika diperlukan
  Future<void> _syncTokenIfNeeded(String currentToken) async {
    try {
      final savedToken = _prefs.getString(StorageKeyConstant.tokenKey);
      final lastSync = _prefs.getString(StorageKeyConstant.lastSyncKey);

      // * Token sama dan baru sync, skip
      if (savedToken == currentToken && lastSync != null) {
        final lastSyncTime = DateTime.parse(lastSync);
        final now = DateTime.now();

        if (now.difference(lastSyncTime) < _syncCooldown) {
          logService('Token unchanged and recently synced, skipping');
          return;
        }
      }

      // * Token berbeda atau belum pernah sync, sync sekarang
      await _syncTokenToBackend(currentToken);
    } catch (e, s) {
      logError('Failed to check token sync status', e, s);
    }
  }

  // * Sync token ke backend
  Future<void> _syncTokenToBackend(
    String token, {
    bool forceSync = false,
  }) async {
    try {
      if (!forceSync) {
        // * Check cooldown untuk prevent spam
        final lastSync = _prefs.getString(StorageKeyConstant.lastSyncKey);

        if (lastSync != null) {
          final lastSyncTime = DateTime.parse(lastSync);
          final now = DateTime.now();

          if (now.difference(lastSyncTime) < _syncCooldown) {
            logService('Token sync on cooldown, skipping');
            return;
          }
        }
      }

      logService('Syncing FCM token to backend...');

      final result = await _authRepository
          .updateProfile(UpdateProfilePayload(fcmToken: token))
          .run();

      await result.fold(
        (failure) {
          logError('Failed to sync FCM token', failure);
        },
        (success) async {
          logService('FCM token synced successfully');

          // * Save token & timestamp to local storage
          await _prefs.setString(StorageKeyConstant.tokenKey, token);
          await _prefs.setString(
            StorageKeyConstant.lastSyncKey,
            DateTime.now().toIso8601String(),
          );
        },
      );
    } catch (e, s) {
      logError('Exception while syncing FCM token', e, s);
    }
  }

  // * Manual sync (dipanggil saat login berhasil)
  Future<void> syncAfterLogin() async {
    logService('Manual token sync after login');

    final token = await _messagingService.getToken();

    if (token != null) {
      await _syncTokenToBackend(token, forceSync: true);
    }
  }

  // * Clear token saat logout
  Future<void> clearToken() async {
    try {
      logService('Clearing FCM token');

      await _prefs.remove(StorageKeyConstant.tokenKey);
      await _prefs.remove(StorageKeyConstant.lastSyncKey);

      // * Optional: Delete token dari Firebase
      await _messagingService.deleteToken();
    } catch (e, s) {
      logError('Failed to clear FCM token', e, s);
    }
  }

  // * Get saved token dari local storage
  String? getSavedToken() {
    try {
      return _prefs.getString(StorageKeyConstant.tokenKey);
    } catch (e, s) {
      logError('Failed to get saved token', e, s);
      return null;
    }
  }
}
