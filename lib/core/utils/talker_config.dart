import 'package:car_rongsok_app/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

/// Talker configuration for the application
class TalkerConfig {
  static late final Talker talker;

  /// Initialize Talker with app-specific configuration
  static void initialize() {
    talker = TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: kDebugMode,
        maxHistoryItems: kDebugMode ? 1000 : 100,
        useHistory: true,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(enableColors: kDebugMode),
      ),
    );

    _logAppStart();
  }

  /// Get Riverpod logger observer
  static TalkerRiverpodObserver get riverpodObserver => TalkerRiverpodObserver(
    talker: AppLogger.instance.talker,
    settings: const TalkerRiverpodLoggerSettings(
      printProviderAdded: true,
      printProviderDisposed: true,
      printProviderUpdated: true,
    ),
  );

  /// Log application startup
  static void _logAppStart() {
    logger.info('🚀 Yoshida Motors App Started');
    logger.debug('Environment: ${kDebugMode ? 'DEBUG' : 'RELEASE'}');
    logger.debug('Platform: ${defaultTargetPlatform.name}');
  }

  /// Configure Talker for different environments
  static void configureForEnvironment(String environment) {
    switch (environment.toLowerCase()) {
      case 'development':
      case 'debug':
        _configureForDebug();
        break;
      case 'staging':
        _configureForStaging();
        break;
      case 'production':
      case 'release':
        _configureForProduction();
        break;
    }
  }

  static void _configureForDebug() {
    talker.configure(
      settings: talker.settings.copyWith(
        useConsoleLogs: true,
        maxHistoryItems: 1000,
        enabled: true,
      ),
    );
    logger.debug('Talker configured for DEBUG environment');
  }

  static void _configureForStaging() {
    talker.configure(
      settings: talker.settings.copyWith(
        useConsoleLogs: true,
        maxHistoryItems: 500,
        enabled: true,
      ),
    );
    logger.debug('Talker configured for STAGING environment');
  }

  static void _configureForProduction() {
    talker.configure(
      settings: talker.settings.copyWith(
        useConsoleLogs: false,
        maxHistoryItems: 100,
        enabled: true,
      ),
    );
    logger.info('Talker configured for PRODUCTION environment');
  }

  /// Get logs as formatted string for sharing/debugging
  static String getFormattedLogs() {
    return logger.exportLogs();
  }

  /// Clear all logs
  static void clearAllLogs() {
    logger.clearLogs();
    logger.info('All logs cleared');
  }
}
