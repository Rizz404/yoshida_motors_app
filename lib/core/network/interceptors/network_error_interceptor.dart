import 'package:dio/dio.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/l10n/app_localizations.dart';
import 'package:car_rongsok_app/core/extensions/logger_extension.dart';
import 'package:car_rongsok_app/core/utils/toast_utils.dart';

/// Interceptor untuk menampilkan toast otomatis untuk network dan server errors
///
/// Menangani:
/// - Connection errors (DNS failure, no internet)
/// - Timeout errors (connection/receive timeout)
/// - Server errors (5xx)
///
/// Error lainnya (4xx, validation) tetap ditangani oleh repository/UI
class NetworkErrorInterceptor extends Interceptor {
  NetworkErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorInfo = _categorizeError(err);

    if (errorInfo != null) {
      logError(errorInfo.logMessage, err.message);

      // * Tampilkan toast dengan pesan user-friendly
      AppToast.serverError(errorInfo.userMessage);
    }

    // * Tetap pass error ke handler berikutnya
    super.onError(err, handler);
  }

  /// Kategorisasi error dan return pesan yang sesuai
  _ErrorInfo? _categorizeError(DioException err) {
    // ! Use try-catch to avoid breaking interceptor if context is missing
    L10n? l10n;
    try {
      l10n = LocalizationExtension.current;
    } catch (_) {
      // debugPrint('Localization context missing in interceptor');
    }

    // * Helper to safely get message
    String getMessage(String Function(L10n) localized, String fallback) {
      if (l10n != null) return localized(l10n);
      return fallback;
    }

    // * 1. Connection errors (DNS, no internet, etc)
    if (err.type == DioExceptionType.connectionError) {
      if (err.message?.contains('Failed host lookup') == true) {
        return _ErrorInfo(
          logMessage: 'DNS Failure',
          userMessage: getMessage(
            (l) => l.networkErrorDnsFailureUser,
            'Cannot connect to server',
          ),
        );
      }
      // * Generic connection error (socket exception, etc)
      return _ErrorInfo(
        logMessage: 'Connection Error',
        userMessage: getMessage(
          (l) => l.networkErrorConnectionUser,
          'Connection lost',
        ),
      );
    }

    // * 2. Timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return _ErrorInfo(
        logMessage: 'Connection Timeout',
        userMessage: getMessage(
          (l) => l.networkErrorTimeoutUser,
          'Connection timeout',
        ),
      );
    }

    if (err.type == DioExceptionType.receiveTimeout) {
      return _ErrorInfo(
        logMessage: 'Receive Timeout',
        userMessage: getMessage(
          (l) => l.networkErrorReceiveTimeoutUser,
          'Server took too long to respond',
        ),
      );
    }

    // * 3. Server errors (5xx)
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return _ErrorInfo(
        logMessage: 'Server Error ($statusCode)',
        userMessage: _getServerErrorMessage(statusCode, l10n),
      );
    }

    // * Return null untuk error lainnya (4xx, validation, etc)
    return null;
  }

  /// Generate pesan server error berdasarkan status code
  String _getServerErrorMessage(int statusCode, L10n? l10n) {
    if (l10n == null) return 'Server Error ($statusCode)';

    switch (statusCode) {
      case 500:
        return l10n.networkErrorServerUser;
      case 502:
        return l10n.networkErrorServer502User;
      case 503:
        return l10n.networkErrorServer503User;
      case 504:
        return l10n.networkErrorServer504User;
      default:
        return l10n.networkErrorServerUser;
    }
  }
}

/// Helper class untuk menyimpan info error
class _ErrorInfo {
  final String logMessage;
  final String userMessage;

  const _ErrorInfo({required this.logMessage, required this.userMessage});
}
