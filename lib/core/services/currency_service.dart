// import 'package:dio/dio.dart';
// import 'package:car_rongsok_app/core/utils/logging.dart';

// class CurrencyService {
//   final Dio _dio;
//   static const String _baseUrl = 'https://api.frankfurter.dev/v1';

//   CurrencyService(this._dio);

//   /// Fetch latest exchange rate from base currency to IDR
//   /// Returns rate or null if failed
//   Future<double?> getExchangeRate({
//     required String fromCurrency,
//     String toCurrency = 'IDR',
//   }) async {
//     try {
//       logService('Fetching exchange rate: $fromCurrency -> $toCurrency');

//       final response = await _dio.get(
//         '$_baseUrl/latest',
//         queryParameters: {'base': fromCurrency, 'symbols': toCurrency},
//       );

//       if (response.statusCode == 200 && response.data != null) {
//         final rates = response.data['rates'] as Map<String, dynamic>?;
//         final rate = rates?[toCurrency] as num?;

//         if (rate != null) {
//           final rateDouble = rate.toDouble();
//           logService('Rate: 1 $fromCurrency = $rateDouble $toCurrency');
//           return rateDouble;
//         }
//       }

//       logError('Failed to parse exchange rate', null, null);
//       return null;
//     } catch (e, s) {
//       logError('Error fetching exchange rate', e, s);
//       return null;
//     }
//   }

//   /// Get multiple currency rates at once
//   Future<Map<String, double>?> getMultipleRates({
//     required String baseCurrency,
//     required List<String> targetCurrencies,
//   }) async {
//     try {
//       logService(
//         'Fetching rates: $baseCurrency -> ${targetCurrencies.join(", ")}',
//       );

//       final response = await _dio.get(
//         '$_baseUrl/latest',
//         queryParameters: {
//           'base': baseCurrency,
//           'symbols': targetCurrencies.join(','),
//         },
//       );

//       if (response.statusCode == 200 && response.data != null) {
//         final rates = response.data['rates'] as Map<String, dynamic>?;

//         if (rates != null) {
//           final result = <String, double>{};
//           rates.forEach((key, value) {
//             if (value is num) {
//               result[key] = value.toDouble();
//             }
//           });

//           logData('Fetched rates', result);
//           return result;
//         }
//       }

//       logError('Failed to parse exchange rates', null, null);
//       return null;
//     } catch (e, s) {
//       logError('Error fetching exchange rates', e, s);
//       return null;
//     }
//   }
// }
