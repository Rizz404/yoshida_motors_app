// import 'package:flutter/material.dart';
// import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
// import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
// import 'package:car_rongsok_app/shared/widgets/app_text.dart';

// /// Reusable widget untuk menampilkan validation errors
// /// Digunakan untuk menampilkan error dari backend validation
// class AppValidationErrors extends StatelessWidget {
//   final List<ValidationError>? errors;
//   final EdgeInsetsGeometry? padding;
//   final double spacing;

//   const AppValidationErrors({
//     super.key,
//     required this.errors,
//     this.padding,
//     this.spacing = 8,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // * Jangan tampilkan widget jika tidak ada errors
//     if (errors == null || errors!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       padding: padding ?? const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: context.semantic.error.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: context.semantic.error.withValues(alpha: 0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 color: context.semantic.error,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               AppText(
//                 context.l10n.sharedValidationErrors,
//                 style: AppTextStyle.bodyMedium,
//                 color: context.semantic.error,
//                 fontWeight: FontWeight.bold,
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...errors!.map(
//             (error) => Padding(
//               padding: EdgeInsets.only(bottom: spacing),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 6),
//                     width: 4,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: context.semantic.error,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: AppText(
//                       error.message,
//                       style: AppTextStyle.bodySmall,
//                       color: context.semantic.error,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Variant sederhana tanpa container
// class AppValidationErrorsList extends StatelessWidget {
//   final List<ValidationError>? errors;
//   final double spacing;

//   const AppValidationErrorsList({
//     super.key,
//     required this.errors,
//     this.spacing = 8,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (errors == null || errors!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: errors!
//           .map(
//             (error) => Padding(
//               padding: EdgeInsets.only(bottom: spacing),
//               child: AppText(
//                 error.message,
//                 style: AppTextStyle.bodySmall,
//                 color: context.semantic.error,
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
// }
