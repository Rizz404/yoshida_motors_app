// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
// import 'package:car_rongsok_app/core/utils/logging.dart';
// import 'package:car_rongsok_app/di/currency_providers.dart';
// import 'package:car_rongsok_app/shared/widgets/app_button.dart';
// import 'package:car_rongsok_app/shared/widgets/app_text.dart';
// import 'package:intl/intl.dart';

// enum CurrencyType { usd, jpy }

// enum _LoadingState { initial, loading, loaded, error }

// class AppCurrencyConverter extends ConsumerStatefulWidget {
//   final CurrencyType currencyType;
//   final void Function(String idrValue)? onApply;

//   const AppCurrencyConverter({
//     super.key,
//     required this.currencyType,
//     this.onApply,
//   });

//   static void show({
//     required BuildContext context,
//     required CurrencyType currencyType,
//     void Function(String idrValue)? onApply,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) =>
//           AppCurrencyConverter(currencyType: currencyType, onApply: onApply),
//     );
//   }

//   @override
//   ConsumerState<AppCurrencyConverter> createState() =>
//       _AppCurrencyConverterState();
// }

// class _AppCurrencyConverterState extends ConsumerState<AppCurrencyConverter> {
//   final TextEditingController _foreignController = TextEditingController();
//   String _idrResult = '0';
//   double? _currentRate;
//   _LoadingState _loadingState = _LoadingState.initial;

//   // * Fallback static rates if API fails
//   static const Map<CurrencyType, double> _fallbackRates = {
//     CurrencyType.usd: 15750.0,
//     CurrencyType.jpy: 105.0,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchExchangeRate();
//   }

//   Future<void> _fetchExchangeRate() async {
//     setState(() => _loadingState = _LoadingState.loading);

//     try {
//       final currencyService = ref.read(currencyServiceProvider);
//       final fromCurrency = widget.currencyType == CurrencyType.usd
//           ? 'USD'
//           : 'JPY';

//       final rate = await currencyService.getExchangeRate(
//         fromCurrency: fromCurrency,
//         toCurrency: 'IDR',
//       );

//       if (rate != null && mounted) {
//         setState(() {
//           _currentRate = rate;
//           _loadingState = _LoadingState.loaded;
//         });
//         this.logService('Loaded real-time rate: 1 $fromCurrency = $rate IDR');
//       } else {
//         throw Exception('Failed to fetch rate');
//       }
//     } catch (e, s) {
//       this.logError('Failed to fetch exchange rate, using fallback', e, s);
//       if (mounted) {
//         setState(() {
//           _currentRate = _fallbackRates[widget.currencyType];
//           _loadingState = _LoadingState.error;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _foreignController.dispose();
//     super.dispose();
//   }

//   void _convertToIDR(String foreignValue) {
//     try {
//       if (foreignValue.isEmpty || _currentRate == null) {
//         setState(() => _idrResult = '0');
//         return;
//       }

//       String cleanValue = foreignValue.replaceAll(RegExp(r'[^0-9.]'), '');
//       double amount = double.parse(cleanValue);
//       double idrAmount = amount * _currentRate!;

//       final formatter = NumberFormat.currency(
//         locale: 'id_ID',
//         symbol: '',
//         decimalDigits: 0,
//       );
//       setState(() {
//         _idrResult = formatter.format(idrAmount).trim();
//       });

//       this.logService(
//         'Converted ${widget.currencyType.name.toUpperCase()} $foreignValue to IDR $_idrResult',
//       );
//     } catch (e, s) {
//       this.logError('Failed to convert currency', e, s);
//       setState(() => _idrResult = '0');
//     }
//   }

//   String get _currencySymbol {
//     switch (widget.currencyType) {
//       case CurrencyType.usd:
//         return '\$';
//       case CurrencyType.jpy:
//         return '¥';
//     }
//   }

//   String get _currencyName {
//     switch (widget.currencyType) {
//       case CurrencyType.usd:
//         return 'USD';
//       case CurrencyType.jpy:
//         return 'JPY';
//     }
//   }

//   String get _currencyFullName {
//     switch (widget.currencyType) {
//       case CurrencyType.usd:
//         return 'US Dollar';
//       case CurrencyType.jpy:
//         return 'Japanese Yen';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       padding: EdgeInsets.only(
//         left: 24,
//         right: 24,
//         top: 24,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // * Header
//           Row(
//             children: [
//               Icon(Icons.currency_exchange, color: context.colors.primary),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       'Currency Converter',
//                       customStyle: context.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     AppText(
//                       '$_currencyFullName to Indonesian Rupiah',
//                       customStyle: context.textTheme.bodySmall?.copyWith(
//                         color: context.colors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // * Info rate
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: context.colors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: context.colors.primary.withOpacity(0.3),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.info_outline,
//                   size: 18,
//                   color: context.colors.primary,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _loadingState == _LoadingState.loading
//                       ? AppText(
//                           'Loading rate...',
//                           customStyle: context.textTheme.bodySmall,
//                         )
//                       : AppText(
//                           '1 $_currencyName = ${_currentRate != null ? NumberFormat.currency(locale: "id_ID", symbol: "Rp", decimalDigits: 0).format(_currentRate) : "-"}${_loadingState == _LoadingState.error ? " (fallback)" : " (live)"}',
//                           customStyle: context.textTheme.bodySmall,
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),

//           // * Input foreign currency
//           TextField(
//             controller: _foreignController,
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
//             ],
//             onChanged: _convertToIDR,
//             decoration: InputDecoration(
//               labelText: '$_currencyFullName Amount',
//               prefixText: '$_currencySymbol ',
//               hintText: '0',
//               filled: true,
//               fillColor: context.colors.surface,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: context.colors.border, width: 1),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: context.colors.border, width: 1),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: context.colors.primary, width: 2),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // * Arrow indicator
//           Center(
//             child: Icon(
//               Icons.arrow_downward,
//               color: context.colors.textSecondary,
//             ),
//           ),
//           const SizedBox(height: 16),

//           // * Result in IDR
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: context.colors.primaryContainer,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: context.colors.primary, width: 2),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   'Indonesian Rupiah (IDR)',
//                   customStyle: context.textTheme.bodySmall?.copyWith(
//                     color: context.colors.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: AppText(
//                         'Rp $_idrResult',
//                         customStyle: context.textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: context.colors.primary,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.copy, size: 20),
//                       onPressed: () {
//                         Clipboard.setData(ClipboardData(text: _idrResult));
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Copied to clipboard'),
//                             duration: Duration(seconds: 1),
//                           ),
//                         );
//                       },
//                       tooltip: 'Copy',
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // * Note
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: context.semantic.warning.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: context.semantic.warning.withOpacity(0.3),
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.warning_amber_outlined,
//                   size: 18,
//                   color: context.semantic.warning,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: AppText(
//                     'This is a reference converter using ${_loadingState == _LoadingState.loaded ? "real-time" : "fallback"} rates. Please verify and enter the IDR amount in the form.',
//                     customStyle: context.textTheme.bodySmall?.copyWith(
//                       color: context.colors.textSecondary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // * Apply button (optional)
//           if (widget.onApply != null)
//             AppButton(
//               text: 'Apply IDR Value',
//               onPressed: () {
//                 widget.onApply?.call(_idrResult);
//                 Navigator.pop(context);
//               },
//               isFullWidth: true,
//             ),
//         ],
//       ),
//     );
//   }
// }
