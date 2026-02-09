import 'package:car_rongsok_app/core/utils/logger.dart';

/// Simplified Extension methods for Clean Architecture logging
/// Only 4 main layers: Data, Domain, Presentation, Service
extension LoggerExtensions on Object {
  /// Get class name for context
  String get _className => runtimeType.toString();

  // MARK: - Basic Logging with Context

  /// Log info message with class context
  void logInfo(String message) {
    logger.info('[$_className] $message');
  }

  /// Log error message with class context
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger.error('[$_className] $message', error, stackTrace);
  }

  // MARK: - Clean Architecture Layers (Simplified)

  /// Data Layer - API, Database, Cache, Storage operations
  void logData(String message, [Object? error, StackTrace? stackTrace]) {
    logger.logData(
      '[$_className] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Domain Layer - Business logic, Use cases, Entities
  void logDomain(String message, [Object? error, StackTrace? stackTrace]) {
    logger.logDomain(
      '[$_className] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Presentation Layer - UI, Controllers, State management
  void logPresentation(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    logger.logPresentation(
      '[$_className] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Service Layer - External services, Utilities
  void logService(String message, [Object? error, StackTrace? stackTrace]) {
    logger.logService(
      '[$_className] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
