import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Simplified Logger for Clean Architecture
/// 4 Main Layers: Data, Domain, Presentation, Service
class AppLogger {
  static AppLogger? _instance;
  late final Talker _talker;

  AppLogger._internal() {
    _talker = TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: kDebugMode,
        maxHistoryItems: 1000,
        useHistory: true,
      ),
      logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: true)),
    );
  }

  /// Get singleton instance
  static AppLogger get instance {
    _instance ??= AppLogger._internal();
    return _instance!;
  }

  /// Get the Talker instance for advanced usage
  Talker get talker => _talker;

  // MARK: - Basic Logging Methods

  /// Log debug message
  void debug(String message, [Object? exception, StackTrace? stackTrace]) {
    _talker.debug(message, exception, stackTrace);
  }

  /// Log info message
  void info(String message, [Object? exception, StackTrace? stackTrace]) {
    _talker.info(message, exception, stackTrace);
  }

  /// Log warning message
  void warning(String message, [Object? exception, StackTrace? stackTrace]) {
    _talker.warning(message, exception, stackTrace);
  }

  /// Log error message
  void error(String message, [Object? exception, StackTrace? stackTrace]) {
    _talker.error(message, exception, stackTrace);
  }

  // MARK: - Clean Architecture Layers (4 Main Layers Only)

  /// Data Layer - All data operations (API, DB, Cache, Storage)
  void logData(String message, {Object? error, StackTrace? stackTrace}) {
    if (error != null) {
      _talker.logCustom(
        DataLog(
          message: 'Data: $message',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    } else {
      _talker.logCustom(DataLog(message: 'Data: $message'));
    }
  }

  /// Domain Layer - Business logic, use cases, entities
  void logDomain(String message, {Object? error, StackTrace? stackTrace}) {
    if (error != null) {
      _talker.logCustom(
        DomainLog(
          message: 'Domain: $message',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    } else {
      _talker.logCustom(DomainLog(message: 'Domain: $message'));
    }
  }

  /// Presentation Layer - UI, controllers, state management
  void logPresentation(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (error != null) {
      _talker.logCustom(
        PresentationLog(
          message: 'UI: $message',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    } else {
      _talker.logCustom(PresentationLog(message: 'UI: $message'));
    }
  }

  /// Service Layer - External services, utilities
  void logService(String message, {Object? error, StackTrace? stackTrace}) {
    if (error != null) {
      _talker.logCustom(
        ServiceLog(
          message: 'Service: $message',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    } else {
      _talker.logCustom(ServiceLog(message: 'Service: $message'));
    }
  }

  // MARK: - Utility Methods

  /// Get Dio logger interceptor
  TalkerDioLogger get dioLogger => TalkerDioLogger(
    talker: _talker,
    settings: TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: false,
      printRequestData: true,
      printResponseData: true,
      printResponseMessage: true,
      responseFilter: (response) {
        final headers = response.headers['content-type'];
        if (headers != null && headers.isNotEmpty) {
          final contentType = headers.first.toLowerCase();
          // Skip logging binary file responses (PDF, Excel)
          if (contentType == 'application/pdf' ||
              contentType == 'application/vnd.ms-excel' ||
              contentType ==
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
            return false;
          }
        }
        return true;
      },
    ),
  );

  /// Clear all logs
  void clearLogs() {
    _talker.cleanHistory();
  }

  /// Get all logs
  List<TalkerData> getLogs() {
    return _talker.history;
  }

  /// Export logs as string
  String exportLogs() {
    return _talker.history
        .map(
          (log) => '${log.displayTime} [${log.logLevel}] ${log.displayMessage}',
        )
        .join('\n');
  }
}

// MARK: - Simple Custom Log Types (4 Clean Architecture Layers)

class DataLog extends TalkerLog {
  final Object? logError;
  final StackTrace? _stackTrace;

  DataLog({required String message, Object? error, StackTrace? stackTrace})
    : logError = error,
      _stackTrace = stackTrace,
      super(message);

  @override
  String get title => 'DATA';

  @override
  StackTrace? get stackTrace => _stackTrace;

  @override
  AnsiPen get pen =>
      logError != null ? (AnsiPen()..red()) : (AnsiPen()..xterm(208)); // Orange
}

class DomainLog extends TalkerLog {
  final Object? logError;
  final StackTrace? _stackTrace;

  DomainLog({required String message, Object? error, StackTrace? stackTrace})
    : logError = error,
      _stackTrace = stackTrace,
      super(message);

  @override
  String get title => 'DOMAIN';

  @override
  StackTrace? get stackTrace => _stackTrace;

  @override
  AnsiPen get pen =>
      logError != null ? (AnsiPen()..red()) : (AnsiPen()..xterm(165)); // Purple
}

class PresentationLog extends TalkerLog {
  final Object? logError;
  final StackTrace? _stackTrace;

  PresentationLog({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) : logError = error,
       _stackTrace = stackTrace,
       super(message);

  @override
  String get title => 'UI';

  @override
  StackTrace? get stackTrace => _stackTrace;

  @override
  AnsiPen get pen =>
      logError != null ? (AnsiPen()..red()) : (AnsiPen()..xterm(81)); // Light Blue
}

class ServiceLog extends TalkerLog {
  final Object? logError;
  final StackTrace? _stackTrace;

  ServiceLog({required String message, Object? error, StackTrace? stackTrace})
    : logError = error,
      _stackTrace = stackTrace,
      super(message);

  @override
  String get title => 'SERVICE';

  @override
  StackTrace? get stackTrace => _stackTrace;

  @override
  AnsiPen get pen =>
      logError != null ? (AnsiPen()..red()) : (AnsiPen()..cyan());
}

/// Global logger instance for easy access
final logger = AppLogger.instance;
