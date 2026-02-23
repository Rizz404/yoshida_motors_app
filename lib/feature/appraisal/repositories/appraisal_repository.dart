import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/extensions/api_result_extension.dart';
import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/core/network/dio_client.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/models/create_appraisal_payload.dart';
import 'package:car_rongsok_app/feature/appraisal/models/get_appraisals_params.dart';
import 'package:car_rongsok_app/feature/appraisal/models/update_appraisal_payload.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class AppraisalRepository {
  /// GET /appraisals — cursor-paginated list with optional filters
  TaskEither<ApiFailure<AppraisalRequest>, ApiCursorSuccess<AppraisalRequest>>
  getAppraisals(GetAppraisalsParams params);

  /// POST /appraisals
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  createAppraisal(CreateAppraisalPayload params);

  /// GET /appraisals/{id}
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  getAppraisalById(int id);

  /// GET /appraisals/latest
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  getLatestAppraisal();

  /// PUT /appraisals/{id}
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  updateAppraisal(int id, UpdateAppraisalPayload params);

  /// DELETE /appraisals/{id}
  TaskEither<ApiFailure<dynamic>, ApiSuccess<dynamic>> deleteAppraisal(int id);

  /// POST /appraisals/{id}/submit
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  submitAppraisal(int id);
}

class AppraisalRepositoryImpl implements AppraisalRepository {
  final DioClient _dioClient;

  AppraisalRepositoryImpl(this._dioClient);

  @override
  TaskEither<ApiFailure<AppraisalRequest>, ApiCursorSuccess<AppraisalRequest>>
  getAppraisals(GetAppraisalsParams params) {
    return TaskEither(() async {
      logService('Getting appraisal list...');
      try {
        final result = await _dioClient.get<AppraisalRequest>(
          ApiConstant.getAppraisals,
          queryParameters: params.toQueryParams(),
          fromJson: (json) =>
              AppraisalRequest.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiCursorSuccess<AppraisalRequest>) {
          logService('Appraisal list fetched successfully');
          return Right(result);
        }

        if (result is ApiFailure<AppraisalRequest>) {
          logError('Failed to get appraisal list');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error getting appraisal list', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  createAppraisal(CreateAppraisalPayload params) {
    return TaskEither(() async {
      logService('Creating appraisal request...');
      try {
        final result = await _dioClient.post<AppraisalRequest>(
          ApiConstant.createAppraisal,
          data: await params.toFormData(),
          options: Options(
            contentType: 'multipart/form-data',
            receiveTimeout: const Duration(
              milliseconds: ApiConstant.longOperationTimeout,
            ),
          ),
          fromJson: (json) =>
              AppraisalRequest.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AppraisalRequest>) {
          logService('Appraisal created successfully');
          return Right(result);
        }

        if (result is ApiFailure<AppraisalRequest>) {
          logError('Failed to create appraisal');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error creating appraisal', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  getAppraisalById(int id) {
    return TaskEither(() async {
      logService('Getting appraisal detail (id: $id)...');
      try {
        final result = await _dioClient.get<AppraisalRequest>(
          ApiConstant.getAppraisalById(id.toString()),
          fromJson: (json) =>
              AppraisalRequest.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AppraisalRequest>) {
          logService('Appraisal detail fetched successfully');
          return Right(result);
        }

        if (result is ApiFailure<AppraisalRequest>) {
          logError('Failed to get appraisal detail');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error getting appraisal detail', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  getLatestAppraisal() {
    return TaskEither(() async {
      logService('Getting latest appraisal...');
      try {
        final result = await _dioClient.get<AppraisalRequest>(
          ApiConstant.getLatestAppraisal,
          fromJson: (json) =>
              AppraisalRequest.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AppraisalRequest>) {
          logService('Latest appraisal fetched successfully');
          return Right(result);
        }

        if (result is ApiFailure<AppraisalRequest>) {
          logError('Failed to get latest appraisal');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error getting latest appraisal', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  updateAppraisal(int id, UpdateAppraisalPayload params) {
    return TaskEither(() async {
      logService('Updating appraisal (id: $id)...');
      try {
        final result = await _dioClient.post<AppraisalRequest>(
          ApiConstant.updateAppraisal(id.toString()),
          data: await params.toFormData(),
          options: Options(
            contentType: 'multipart/form-data',
            receiveTimeout: const Duration(
              milliseconds: ApiConstant.longOperationTimeout,
            ),
          ),
          fromJson: (json) =>
              AppraisalRequest.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AppraisalRequest>) {
          logService('Appraisal updated successfully');
          return Right(result);
        }

        if (result is ApiFailure<AppraisalRequest>) {
          logError('Failed to update appraisal');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error updating appraisal', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<dynamic>, ApiSuccess<dynamic>> deleteAppraisal(int id) {
    return TaskEither(() async {
      logService('Deleting appraisal (id: $id)...');
      try {
        final result = await _dioClient.delete<dynamic>(
          ApiConstant.deleteAppraisal(id.toString()),
          fromJson: (json) => json,
        );

        logService('Appraisal deleted successfully');
        return result.toEither();
      } catch (e, s) {
        logError('Error deleting appraisal', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AppraisalRequest>, ApiSuccess<AppraisalRequest>>
  submitAppraisal(int id) {
    return TaskEither(() async {
      logService('Submitting appraisal (id: $id)...');
      try {
        final result = await _dioClient.post<AppraisalRequest>(
          ApiConstant.submitAppraisal(id.toString()),
          fromJson: (json) =>
              AppraisalRequest.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AppraisalRequest>) {
          logService('Appraisal submitted successfully');
          return Right(result);
        }

        if (result is ApiFailure<AppraisalRequest>) {
          logError('Failed to submit appraisal');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error submitting appraisal', e, s);
        rethrow;
      }
    });
  }
}
