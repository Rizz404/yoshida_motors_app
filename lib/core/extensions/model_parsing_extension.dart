import 'package:car_rongsok_app/core/utils/logging.dart';

/// Extension untuk parsing model dengan type safety dan logging informatif
///
/// Contoh penggunaan:
/// ```dart
/// factory UserModel.fromMap(Map<String, dynamic> map) {
///   return UserModel(
///     id: map.getField<String>('id'),
///     email: map.getFieldOrNull<String>('email'),
///     createdAt: map.getField<DateTime>('createdAt'),
///     purchasePrice: map.getFieldOrNull<double>('purchasePrice'),
///   );
/// }
/// ```
extension SafeMap on Map<String, dynamic> {
  /// Get field dengan type checking dan auto-conversion untuk DateTime & double
  T getField<T>(String key) {
    try {
      final value = this[key];

      if (value == null) {
        logError('Field "$key" is null or missing');
        throw Exception('Field "$key" is null or missing');
      }

      // DateTime handling: String (ISO), int (timestamp), atau DateTime
      if (T == DateTime) {
        if (value is String) {
          final parsed = DateTime.parse(value);
          return (parsed.isUtc ? parsed.toLocal() : parsed) as T;
        }
        if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value) as T;
        }
        if (value is DateTime) {
          return (value.isUtc ? value.toLocal() : value) as T;
        }

        logError(
          'Field "$key" cannot be converted to DateTime\n'
          '   Got: ${value.runtimeType}\n'
          '   Value: $value',
        );
        throw Exception('Field "$key" cannot be converted to DateTime');
      }

      // double handling: double atau int dari backend
      if (T == double) {
        if (value is double) return value as T;
        if (value is int) return value.toDouble() as T;

        logError(
          'Field "$key" cannot be converted to double\n'
          '   Got: ${value.runtimeType}\n'
          '   Value: $value',
        );
        throw Exception('Field "$key" cannot be converted to double');
      }

      // Standard type checking
      if (value is! T) {
        logError(
          'Field "$key" has wrong type\n'
          '   Expected: $T\n'
          '   Got: ${value.runtimeType}\n'
          '   Value: $value',
        );
        throw Exception(
          'Field "$key" has wrong type. Expected $T but got ${value.runtimeType}',
        );
      }

      return value;
    } catch (e) {
      logError(
        'Error at field "$key": $e\n'
        '   📦 Available keys: ${keys.toList()}\n'
        '   🔍 Value: ${this[key]}',
      );
      rethrow;
    }
  }

  /// Get field nullable dengan auto-conversion untuk DateTime & double
  T? getFieldOrNull<T>(String key) {
    try {
      final value = this[key];
      if (value == null) return null;

      // DateTime handling
      if (T == DateTime) {
        if (value is String) {
          final parsed = DateTime.parse(value);
          return (parsed.isUtc ? parsed.toLocal() : parsed) as T?;
        }
        if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value) as T?;
        }
        if (value is DateTime) {
          return (value.isUtc ? value.toLocal() : value) as T?;
        }

        logData(
          'Field "$key" cannot be converted to DateTime (returning null)\n'
          '   Got: ${value.runtimeType}',
        );
        return null;
      }

      // double handling
      if (T == double) {
        if (value is double) return value as T?;
        if (value is int) return value.toDouble() as T?;

        logData(
          'Field "$key" cannot be converted to double (returning null)\n'
          '   Got: ${value.runtimeType}',
        );
        return null;
      }

      // Standard type checking
      if (value is! T) {
        logData(
          'Field "$key" type mismatch (returning null)\n'
          '   Expected: $T\n'
          '   Got: ${value.runtimeType}',
        );
        return null;
      }

      return value as T?;
    } catch (e) {
      logData('Warning at field "$key": $e');
      return null;
    }
  }
}
