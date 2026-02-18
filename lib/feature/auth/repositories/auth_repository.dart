import 'package:car_rongsok_app/core/constants/api_constants.dart';
import 'package:car_rongsok_app/core/extensions/api_result_extension.dart';
import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/core/network/dio_client.dart';
import 'package:car_rongsok_app/core/services/auth_service.dart';
import 'package:car_rongsok_app/core/utils/logging.dart';
import 'package:car_rongsok_app/feature/auth/models/auth_response.dart';
import 'package:car_rongsok_app/feature/auth/models/email_register_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/login_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/register_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/update_profile_payload.dart';
import 'package:car_rongsok_app/feature/user/models/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>> register(
    RegisterPayload params,
  );
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>> login(
    LoginPayload params,
  );
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>
  registerWithEmail(EmailRegisterPayload params);
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>> loginWithEmail(
    LoginPayload params,
  );
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>
  loginWithGoogle(LoginPayload params);
  TaskEither<ApiFailure<User>, ApiSuccess<User>> getProfile();
  TaskEither<ApiFailure<User>, ApiSuccess<User>> updateProfile(
    UpdateProfilePayload params,
  );
  TaskEither<ApiFailure<dynamic>, ApiSuccess<dynamic>> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final AuthService _authService;

  AuthRepositoryImpl(this._dioClient, this._authService);

  @override
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>> register(
    RegisterPayload params,
  ) {
    return TaskEither(() async {
      logService('Registering user...');
      try {
        final result = await _dioClient.post<AuthResponse>(
          ApiConstant.authRegister,
          data: params.toMap(),
          fromJson: (json) =>
              AuthResponse.fromMap(json as Map<String, dynamic>),
        );

        // Handle success case
        if (result is ApiSuccess<AuthResponse>) {
          // Save token & user to storage
          await _authService.saveAccessToken(result.data.token);
          await _authService.saveUser(result.data.user);
          logService('User registered successfully');
          return Right<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>(
            result,
          );
        }

        // Handle failure case
        if (result is ApiFailure<AuthResponse>) {
          logError('Registration failed');
          return Left<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>(
            result,
          );
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error during registration', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>> login(
    LoginPayload params,
  ) {
    return TaskEither(() async {
      logService('Logging in user...');
      try {
        final result = await _dioClient.post<AuthResponse>(
          ApiConstant.authLogin,
          data: params.toMap(),
          fromJson: (json) =>
              AuthResponse.fromMap(json as Map<String, dynamic>),
        );

        // Handle success case
        if (result is ApiSuccess<AuthResponse>) {
          // Save token & user to storage
          await _authService.saveAccessToken(result.data.token);
          await _authService.saveUser(result.data.user);
          logService('User logged in successfully');
          return Right<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>(
            result,
          );
        }

        // Handle failure case
        if (result is ApiFailure<AuthResponse>) {
          logError('Login failed');
          return Left<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>(
            result,
          );
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error during login', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>
  registerWithEmail(EmailRegisterPayload params) {
    return TaskEither(() async {
      logService('Registering user with email...');
      try {
        final result = await _dioClient.post<AuthResponse>(
          ApiConstant.authRegisterEmail,
          data: params.toMap(),
          fromJson: (json) =>
              AuthResponse.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AuthResponse>) {
          await _authService.saveAccessToken(result.data.token);
          await _authService.saveUser(result.data.user);
          logService('Email registration successful');
          return Right(result);
        }

        if (result is ApiFailure<AuthResponse>) {
          logError('Email registration failed');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error during email registration', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>> loginWithEmail(
    LoginPayload params,
  ) {
    return TaskEither(() async {
      logService('Logging in with email...');
      try {
        final result = await _dioClient.post<AuthResponse>(
          ApiConstant.authLoginEmail,
          data: params.toMap(),
          fromJson: (json) =>
              AuthResponse.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AuthResponse>) {
          await _authService.saveAccessToken(result.data.token);
          await _authService.saveUser(result.data.user);
          logService('Email login successful');
          return Right(result);
        }

        if (result is ApiFailure<AuthResponse>) {
          logError('Email login failed');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error during email login', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<AuthResponse>, ApiSuccess<AuthResponse>>
  loginWithGoogle(LoginPayload params) {
    return TaskEither(() async {
      logService('Logging in with Google...');
      try {
        final result = await _dioClient.post<AuthResponse>(
          ApiConstant.authLoginGoogle,
          data: params.toMap(),
          fromJson: (json) =>
              AuthResponse.fromMap(json as Map<String, dynamic>),
        );

        if (result is ApiSuccess<AuthResponse>) {
          await _authService.saveAccessToken(result.data.token);
          await _authService.saveUser(result.data.user);
          logService('Google login successful');
          return Right(result);
        }

        if (result is ApiFailure<AuthResponse>) {
          logError('Google login failed');
          return Left(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error during Google login', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<User>, ApiSuccess<User>> getProfile() {
    return TaskEither(() async {
      logService('Getting user profile...');
      try {
        // * Check token first — no token means not authenticated, skip API call
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

        // Handle success case
        if (result is ApiSuccess<User>) {
          // Update cached user
          await _authService.saveUser(result.data);
          logService('Profile fetched successfully');
          return Right<ApiFailure<User>, ApiSuccess<User>>(result);
        }

        // Handle failure case
        if (result is ApiFailure<User>) {
          logError('Failed to get profile');
          return Left<ApiFailure<User>, ApiSuccess<User>>(result);
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
    UpdateProfilePayload params,
  ) {
    return TaskEither(() async {
      logService('Updating user profile...');
      try {
        final result = await _dioClient.put<User>(
          ApiConstant.authProfile,
          data: params.toMap(),
          fromJson: (json) => User.fromMap(json as Map<String, dynamic>),
        );

        // Handle success case
        if (result is ApiSuccess<User>) {
          // Update cached user
          await _authService.saveUser(result.data);
          logService('Profile updated successfully');
          return Right<ApiFailure<User>, ApiSuccess<User>>(result);
        }

        // Handle failure case
        if (result is ApiFailure<User>) {
          logError('Failed to update profile');
          return Left<ApiFailure<User>, ApiSuccess<User>>(result);
        }

        throw UnimplementedError('Unknown ApiResult type');
      } catch (e, s) {
        logError('Error updating profile', e, s);
        rethrow;
      }
    });
  }

  @override
  TaskEither<ApiFailure<dynamic>, ApiSuccess<dynamic>> logout() {
    return TaskEither(() async {
      logService('Logging out...');
      try {
        final result = await _dioClient.post<dynamic>(
          ApiConstant.authLogout,
          fromJson: (json) => json,
        );

        // * Clear auth data regardless of API response
        await _authService.clearAuth();
        logService('User logged out successfully');

        return result.toEither();
      } catch (e, s) {
        logError('Error during logout', e, s);
        rethrow;
      }
    });
  }
}
