import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/l10n/app_localizations.dart';

extension NumExtension on num {
  /// Format number as IDR (Rupiah) currency string
  /// Example: 1500000.toRupiah() => "Rp 1.500.000"
  String toRupiah() {
    final formatter = _RupiahFormatter();
    return formatter.format(this);
  }

  /// Format number as IDR (Rupiah) currency string with short format
  /// Example:
  /// 1500000000.toRupiahShort() => "Rp 1.5M" (Miliar)
  /// 1500000.toRupiahShort() => "Rp 1.5jt" (Juta)
  /// 1500.toRupiahShort() => "Rp 1.5rb" (Ribu)
  String toRupiahShort() {
    String billionSuffix = 'M';
    String millionSuffix = 'jt';
    String thousandSuffix = 'rb';

    try {
      final l10n = LocalizationExtension.current;
      billionSuffix = l10n.currencyBillionSuffix;
      millionSuffix = l10n.currencyMillionSuffix;
      thousandSuffix = l10n.currencyThousandSuffix;
    } catch (_) {
      // Fallback
    }

    // Cek Miliar (1.000.000.000)
    if (this >= 1000000000) {
      double result = this / 1000000000;
      return 'Rp ${result.toStringAsFixed(1).replaceAll('.0', '')}$billionSuffix';
    }
    // Cek Juta (1.000.000)
    else if (this >= 1000000) {
      double result = this / 1000000;
      return 'Rp ${result.toStringAsFixed(1).replaceAll('.0', '')}$millionSuffix';
    }
    // Cek Ribu (1.000)
    else if (this >= 1000) {
      double result = this / 1000;
      return 'Rp ${result.toStringAsFixed(1).replaceAll('.0', '')}$thousandSuffix';
    }

    return 'Rp ${toStringAsFixed(0)}';
  }
}

class _RupiahFormatter {
  String format(num value) {
    final intValue = value.toInt();
    final stringValue = intValue.toString();
    return 'Rp ${_formatWithDots(stringValue)}';
  }

  String _formatWithDots(String value) {
    if (value.length <= 3) return value;

    final result = StringBuffer();
    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result.write('.');
      }
      result.write(value[i]);
      count++;
    }

    return result.toString().split('').reversed.join('');
  }
}
