import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/extensions/api_result_extension.dart';
import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/core/network/dio_client.dart';
import 'package:car_rongsok_app/core/services/auth_service.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:car_rongsok_app/feature/user/models/update_user_payload.dart';
import 'package:car_rongsok_app/feature/user/models/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  TaskEither<ApiFailure<User>, ApiSuccess<User>> getProfile();
  TaskEither<ApiFailure<User>, ApiSuccess<User>> updateProfile(
    UpdateUserPayload params,
  );
}

class UserRepositoryImpl implements UserRepository {
  final DioClient _dioClient;
  final AuthService _authService;

  UserRepositoryImpl(this._dioClient, this._authService);

  @override
  TaskEither<ApiFailure<User>, ApiSuccess<User>> getProfile() {
    return TaskEither(() async {
      logService('Getting user profile...');
      try {
        final token = await _authService.getAccessToken();
        if (token == null) {
          logService('No auth token found, user is unauthenticated');
          return const Left(ApiFailure(message: 'No auth token'));
        }

        // * Try get from storage first
        final cachedUser = await _authService.getUser();
        if (cachedUser != null) {
          logService('Profile loaded from cache');
          return Right(
            ApiSuccess(data: cachedUser, message: 'Profile loaded from cache'),
          );
        }

        // * Fetch from API if token exists but no cached user
        logService('Fetching profile from API...');
        final result = await _dioClient.get<User>(
          ApiConstant.authProfile,
          fromJson: (json) => User.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<User>) {
          await _authService.saveUser(result.data);
          logService('Profile fetched successfully');
          return Right(result);
        }

        if (result is ApiFailure<User>) {
          logError('Failed to get profile');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error getting profile', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<User>, ApiSuccess<User>> updateProfile(
    UpdateUserPayload params,
  ) {
    return TaskEither(() async {
      logService('Updating user profile...');
      try {
        final result = await _dioClient.put<User>(
          ApiConstant.authProfile,
          data: params.toMap(),
          fromJson: (json) => User.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<User>) {
          await _authService.saveUser(result.data);
          logService('Profile updated successfully');
          return Right(result);
        }

        if (result is ApiFailure<User>) {
          logError('Failed to update profile');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error updating profile', e, s);
        rethrow;
      }
    });
  }
}
