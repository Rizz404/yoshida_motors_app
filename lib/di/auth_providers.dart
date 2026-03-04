import 'dart:async';

import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/auth/models/email_register_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/login_payload.dart';
import 'package:car_rongsok_app/feature/auth/models/register_payload.dart';
import 'package:car_rongsok_app/feature/auth/repositories/auth_repository.dart';
import 'package:car_rongsok_app/feature/user/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// AUTH STATE
// ==========================================
enum AuthStatus { authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final ApiFailure<dynamic>? failure;

  const AuthState._({required this.status, this.user, this.failure});

  const AuthState.authenticated({required User user})
    : this._(status: AuthStatus.authenticated, user: user, failure: null);

  const AuthState.unauthenticated({ApiFailure<dynamic>? failure})
    : this._(status: AuthStatus.unauthenticated, user: null, failure: failure);

  AuthState copyWith({
    AuthStatus? status,
    User? Function()? user,
    ApiFailure<dynamic>? Function()? failure,
  }) {
    return AuthState._(
      status: status ?? this.status,
      user: user != null ? user() : this.user,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}

// ==========================================
// AUTH NOTIFIER
// ==========================================
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  late AuthRepository _authRepository;

  @override
  FutureOr<AuthState> build() async {
    _authRepository = ref.read(authRepositoryProvider);

    // * Timeout 5 detik untuk mencegah ANR saat server lambat/error
    try {
      final result = await _authRepository.getProfile().run().timeout(
        const Duration(seconds: 5),
      );

      return result.fold(
        (failure) => AuthState.unauthenticated(failure: failure),
        (success) => AuthState.authenticated(user: success.data),
      );
    } catch (e) {
      return const AuthState.unauthenticated();
    }
  }

  Future<void> register(RegisterPayload payload) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.register(payload).run();

      return result.fold(
        (failure) => AuthState.unauthenticated(failure: failure),
        (success) {
          // * Token & user already saved by repository
          return AuthState.authenticated(user: success.data.user);
        },
      );
    });
  }

  Future<void> loginWithPhone(LoginPayload payload) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.loginWithPhone(payload).run();

      return result.fold(
        (failure) => AuthState.unauthenticated(failure: failure),
        (success) {
          // * Token & user already saved by repository
          return AuthState.authenticated(user: success.data.user);
        },
      );
    });
  }

  Future<void> registerWithEmail(EmailRegisterPayload payload) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.registerWithEmail(payload).run();

      return result.fold(
        (failure) => AuthState.unauthenticated(failure: failure),
        (success) => AuthState.authenticated(user: success.data.user),
      );
    });
  }

  Future<void> loginWithEmail(LoginPayload payload) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.loginWithEmail(payload).run();

      return result.fold(
        (failure) => AuthState.unauthenticated(failure: failure),
        (success) => AuthState.authenticated(user: success.data.user),
      );
    });
  }

  Future<void> loginWithGoogle(LoginPayload payload) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.loginWithGoogle(payload).run();

      return result.fold(
        (failure) => AuthState.unauthenticated(failure: failure),
        (success) => AuthState.authenticated(user: success.data.user),
      );
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.logout().run();

      return result.fold(
        (failure) {
          // * Auth already cleared by repository
          return AuthState.unauthenticated(failure: failure);
        },
        (success) {
          // * Auth already cleared by repository
          return const AuthState.unauthenticated();
        },
      );
    });
  }

  /// Update user data in auth state (called after profile update)
  Future<void> refreshProfile() async {
    final currentState = await future;

    if (currentState.status != AuthStatus.authenticated) return;

    state = await AsyncValue.guard(() async {
      final result = await _authRepository.getProfile().run();

      return result.fold((failure) {
        // * Keep current state on failure
        return currentState;
      }, (success) => AuthState.authenticated(user: success.data));
    });
  }

  /// Manually update user in state (for optimistic updates)
  void updateUserData(User updatedUser) {
    state.whenData((authState) {
      if (authState.status == AuthStatus.authenticated) {
        state = AsyncData(AuthState.authenticated(user: updatedUser));
      }
    });
  }
}
