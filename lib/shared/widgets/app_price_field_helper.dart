// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
// import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
// import 'package:car_rongsok_app/di/common_providers.dart';
// import 'package:car_rongsok_app/shared/widgets/app_currency_converter.dart';
// import 'package:car_rongsok_app/shared/widgets/app_text.dart';

// /// Helper widget untuk field price yang menampilkan converter berdasarkan locale
// class AppPriceFieldHelper extends ConsumerWidget {
//   final void Function(String idrValue)? onApply;

//   const AppPriceFieldHelper({super.key, this.onApply});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = ref.watch(localeProvider);

//     // * Kalau bahasa Indonesia, tidak perlu converter
//     if (context.isIndonesian) {
//       return const SizedBox.shrink();
//     }

//     // * Tentukan currency type berdasarkan locale
//     CurrencyType? currencyType;
//     String helperText = '';

//     if (context.isEnglish) {
//       currencyType = CurrencyType.usd;
//       helperText = 'Need to convert from USD? Tap here';
//     } else if (context.isJapanese) {
//       currencyType = CurrencyType.jpy;
//       helperText = 'Need to convert from JPY? Tap here';
//     }

//     if (currencyType == null) {
//       return const SizedBox.shrink();
//     }

//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: InkWell(
//         onTap: () {
//           AppCurrencyConverter.show(
//             context: context,
//             currencyType: currencyType!,
//             onApply: onApply,
//           );
//         },
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           decoration: BoxDecoration(
//             color: context.colors.primary.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: context.colors.primary.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.calculate_outlined,
//                 size: 16,
//                 color: context.colors.primary,
//               ),
//               const SizedBox(width: 8),
//               AppText(
//                 helperText,
//                 customStyle: context.textTheme.bodySmall?.copyWith(
//                   color: context.colors.primary,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 12,
//                 color: context.colors.primary,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
