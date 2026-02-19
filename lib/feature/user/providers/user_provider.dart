import 'dart:async';

import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/user/models/update_user_payload.dart';
import 'package:car_rongsok_app/feature/user/models/user.dart';
import 'package:car_rongsok_app/feature/user/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// USER PROFILE STATE
// ==========================================
class UserProfileState extends Equatable {
  final User? user;
  final ApiFailure<dynamic>? failure;

  // * Single mutation state — update profile
  final bool isMutating;
  final ApiFailure<dynamic>? mutationError;

  const UserProfileState({
    this.user,
    this.failure,
    this.isMutating = false,
    this.mutationError,
  });

  UserProfileState copyWith({
    User? Function()? user,
    ApiFailure<dynamic>? Function()? failure,
    bool? isMutating,
    ApiFailure<dynamic>? Function()? mutationError,
  }) {
    return UserProfileState(
      user: user != null ? user() : this.user,
      failure: failure != null ? failure() : this.failure,
      isMutating: isMutating ?? this.isMutating,
      mutationError: mutationError != null
          ? mutationError()
          : this.mutationError,
    );
  }

  @override
  List<Object?> get props => [user, failure, isMutating, mutationError];
}

// ==========================================
// USER PROFILE NOTIFIER
// ==========================================
final userProfileNotifierProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileState>(
      UserProfileNotifier.new,
    );

class UserProfileNotifier extends AsyncNotifier<UserProfileState> {
  late UserRepository _userRepository;

  @override
  FutureOr<UserProfileState> build() async {
    _userRepository = ref.read(userRepositoryProvider);

    final result = await _userRepository.getProfile().run();

    return result.fold(
      (failure) => UserProfileState(failure: failure),
      (success) => UserProfileState(user: success.data),
    );
  }

  /// Update profile — re-fetch dari server setelah sukses
  Future<void> updateProfile(UpdateUserPayload payload) async {
    final current = state.value;
    if (current == null) return;

    // * Mutation loading — data tetap visible, tidak hide ke AsyncLoading
    state = AsyncData(
      current.copyWith(isMutating: true, mutationError: () => null),
    );

    final result = await _userRepository.updateProfile(payload).run();

    result.fold(
      (failure) => state = AsyncData(
        current.copyWith(isMutating: false, mutationError: () => failure),
      ),
      // * Re-fetch fresh data from server
      (_) => ref.invalidateSelf(),
    );
  }
}
