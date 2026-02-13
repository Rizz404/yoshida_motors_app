import 'package:go_router/go_router.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';

/// Service untuk handle navigation dari notification tap
class NotificationNavigationService {
  const NotificationNavigationService();

  /// Handle navigation berdasarkan notification data
  /// * entityType/related_entity_type: asset, category, location, user, asset_movement, maintenance_schedule, maintenance_record, issue_report, scan_log
  /// * entityId/related_entity_id: ID dari entity yang bersangkutan
  void handleNotificationNavigation(GoRouter router, Map<String, String> data) {
    try {
      // * Support both formats: camelCase (legacy) and snake_case (FCM)
      final entityType = data['entityType'] ?? data['related_entity_type'];
      final entityId = data['entityId'] ?? data['related_entity_id'];

      if (entityType == null || entityId == null) {
        logger.info('No navigation data in notification: $data');
        return;
      }

      logger.info('Navigating to $entityType with ID: $entityId');

      // * Mapping entity type ke route dengan path parameter
      switch (entityType.toLowerCase()) {
        case 'asset':
          router.push('/asset/$entityId');
          break;

        case 'category':
          router.push('/category/$entityId');
          break;

        case 'location':
          router.push('/location/$entityId');
          break;

        case 'user':
          router.push('/user/$entityId');
          break;

        case 'asset_movement':
          router.push('/asset-movement/$entityId');
          break;

        case 'maintenance_schedule':
          router.push('/maintenance-schedule/$entityId');
          break;

        case 'maintenance_record':
          router.push('/maintenance-record/$entityId');
          break;

        case 'issue_report':
          router.push('/issue-report/$entityId');
          break;

        case 'scan_log':
          router.push('/scan-log/$entityId');
          break;

        default:
          logger.info('Unknown entity type: $entityType');
      }
    } catch (e, s) {
      logger.error('Failed to navigate from notification', e, s);
    }
  }

  /// Parse payload dari local notification
  /// Format: entityType=asset&entityId=123&assetId=456
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
