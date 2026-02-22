import 'package:flutter_riverpod/legacy.dart';

/// Holds the appraisalId for the current appraisal flow:
/// vehicle_info → photo_category → camera → summary → result
final currentAppraisalIdProvider = StateProvider<int?>((ref) => null);

/// Holds the category name when navigating to CameraCaptureScreen
final currentPhotoCategoryProvider = StateProvider<String?>((ref) => null);
