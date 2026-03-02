import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/extensions/api_result_extension.dart';
import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/core/network/dio_client.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:car_rongsok_app/feature/notification/models/get_notifications_params.dart';
import 'package:car_rongsok_app/feature/notification/models/notification.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotificationRepository {
  /// GET /notifications — cursor-paginated list of notifications
  TaskEither<ApiFailure<Notification>, ApiCursorSuccess<Notification>>
  getNotifications(GetNotificationsParams params);

  /// PUT /notifications/{id}/mark-read
  TaskEither<ApiFailure<Notification>, ApiSuccess<Notification>> markAsRead(
    int id,
  );

  /// PUT /notifications/mark-all-read
  TaskEither<ApiFailure<dynamic>, ApiSuccess<dynamic>> markAllAsRead();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final DioClient _dioClient;

  NotificationRepositoryImpl(this._dioClient);

  @override
  TaskEither<ApiFailure<Notification>, ApiCursorSuccess<Notification>>
  getNotifications(GetNotificationsParams params) {
    return TaskEither(() async {
      logService('Getting notification list...');
      try {
        final result = await _dioClient.get<Notification>(
          ApiConstant.getNotifications,
          queryParameters: params.toQueryParams(),
          fromJson: (json) =>
              Notification.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiCursorSuccess<Notification>) {
          logService('Notification list fetched successfully');
          return Right(result);
        }

        if (result is ApiFailure<Notification>) {
          logError('Failed to get notification list');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error getting notification list', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<Notification>, ApiSuccess<Notification>> markAsRead(
    int id,
  ) {
    return TaskEither(() async {
      logService('Marking notification as read (id: $id)...');
      try {
        final result = await _dioClient.patch<Notification>(
          ApiConstant.markNotificationRead(id.toString()),
          fromJson: (json) =>
              Notification.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<Notification>) {
          logService('Notification marked as read successfully');
          return Right(result);
        }

        if (result is ApiFailure<Notification>) {
          logError('Failed to mark notification as read');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error marking notification as read', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<dynamic>, ApiSuccess<dynamic>> markAllAsRead() {
    return TaskEither(() async {
      logService('Marking all notifications as read...');
      try {
        final result = await _dioClient.patch<dynamic>(
          ApiConstant.markAllNotificationsRead,
          fromJson: (json) => json,
        );

        logService('All notifications marked as read successfully');
        return result.toEither();
      } catch (e, s) {
        logError('Error marking all notifications as read', e, s);
        rethrow;
      }
    });
  }
}
