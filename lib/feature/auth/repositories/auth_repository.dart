import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/feature/auth/models/auth_response.dart';
import 'package:car_rongsok_app/feature/auth/models/login_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/register_payload.dart';

abstract class AuthRepository {
  Future<ApiSuccess<AuthResponse>> register(RegisterPayload params);
  Future<ApiSuccess<AuthResponse>> login(LoginPayload params);
  Future<ApiSuccess<Null>> logout();
}
