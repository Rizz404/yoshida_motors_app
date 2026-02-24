import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/router/routes.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';

/// Service untuk handle navigation dari notification tap
class NotificationNavigationService {
  const NotificationNavigationService();

  /// Handle navigation berdasarkan notification data (FCM payload)
  /// * type: appraisal_created, appraisal_updated, appraisal_submitted
  /// * appraisal_id: ID dari appraisal yang bersangkutan
  void handleNotificationNavigation(
    StackRouter router,
    Map<String, String> data, {
    void Function(int appraisalId)? onSetAppraisalId,
  }) {
    try {
      final type = data['type'];

      if (type == null) {
        logger.info('No notification type in data: $data');
        return;
      }

      logger.info('Handling notification type: $type');

      switch (type) {
        case 'appraisal_created':
        case 'appraisal_updated':
        case 'appraisal_submitted':
          _navigateToAppraisalResult(router, data, onSetAppraisalId);
          break;

        default:
          logger.info('Unknown notification type: $type');
      }
    } catch (e, s) {
      logger.error('Failed to navigate from notification', e, s);
    }
  }

  // * Navigate ke AppraisalResultScreen
  void _navigateToAppraisalResult(
    StackRouter router,
    Map<String, String> data,
    void Function(int appraisalId)? onSetAppraisalId,
  ) {
    final appraisalIdStr = data['appraisal_id'];

    if (appraisalIdStr == null) {
      logger.info('No appraisal_id in notification data');
      return;
    }

    final appraisalId = int.tryParse(appraisalIdStr);

    if (appraisalId == null) {
      logger.info('Invalid appraisal_id: $appraisalIdStr');
      return;
    }

    // * Set appraisal ID via callback sebelum navigate
    onSetAppraisalId?.call(appraisalId);

    router.push(const AppraisalResultRoute());
    logger.info('Navigated to AppraisalResultScreen with ID: $appraisalId');
  }

  /// Parse payload dari local notification
  /// Format: type=appraisal_updated&appraisal_id=123
  Map<String, String> parsePayload(String? payload) {
    if (payload == null || payload.isEmpty) return {};

    try {
      return Uri.splitQueryString(payload);
    } catch (e, s) {
      logger.error('Failed to parse notification payload', e, s);
      return {};
    }
  }
}
