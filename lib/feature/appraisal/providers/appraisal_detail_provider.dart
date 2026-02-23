import 'dart:async';

import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/models/update_appraisal_payload.dart';
import 'package:car_rongsok_app/feature/appraisal/repositories/appraisal_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// APPRAISAL DETAIL STATE
// ==========================================
class AppraisalDetailState extends Equatable {
  final AppraisalRequest appraisal;
  final ApiFailure<dynamic>? failure;

  // * Single mutation state — update, submit, photo share one slot
  final bool isMutating;
  final ApiFailure<dynamic>? mutationError;

  const AppraisalDetailState({
    required this.appraisal,
    this.failure,
    this.isMutating = false,
    this.mutationError,
  });

  AppraisalDetailState copyWith({
    AppraisalRequest? appraisal,
    ApiFailure<dynamic>? Function()? failure,
    bool? isMutating,
    ApiFailure<dynamic>? Function()? mutationError,
  }) {
    return AppraisalDetailState(
      appraisal: appraisal ?? this.appraisal,
      failure: failure != null ? failure() : this.failure,
      isMutating: isMutating ?? this.isMutating,
      mutationError: mutationError != null
          ? mutationError()
          : this.mutationError,
    );
  }

  @override
  List<Object?> get props => [appraisal, failure, isMutating, mutationError];
}

// ==========================================
// APPRAISAL DETAIL NOTIFIER (family by id)
// ==========================================
// * Riverpod 3: arg dioper via constructor, bukan FamilyAsyncNotifier
final appraisalDetailNotifierProvider =
    AsyncNotifierProvider.family<
      AppraisalDetailNotifier,
      AppraisalDetailState,
      int
    >(AppraisalDetailNotifier.new);

class AppraisalDetailNotifier extends AsyncNotifier<AppraisalDetailState> {
  final int _id;

  AppraisalDetailNotifier(this._id);

  late AppraisalRepository _appraisalRepository;

  @override
  FutureOr<AppraisalDetailState> build() async {
    _appraisalRepository = ref.read(appraisalRepositoryProvider);

    final result = await _appraisalRepository.getAppraisalById(_id).run();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (success) => AppraisalDetailState(appraisal: success.data),
    );
  }

  /// Update appraisal — re-fetch dari server setelah sukses
  Future<void> updateAppraisal(UpdateAppraisalPayload payload) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(isMutating: true, mutationError: () => null),
    );

    final result = await _appraisalRepository
        .updateAppraisal(_id, payload)
        .run();

    result.fold(
      (failure) => state = AsyncData(
        current.copyWith(isMutating: false, mutationError: () => failure),
      ),
      (_) => ref.invalidateSelf(),
    );
  }

  /// Submit appraisal — re-fetch dari server setelah sukses
  Future<void> submitAppraisal() async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(isMutating: true, mutationError: () => null),
    );

    final result = await _appraisalRepository.submitAppraisal(_id).run();

    result.fold(
      (failure) => state = AsyncData(
        current.copyWith(isMutating: false, mutationError: () => failure),
      ),
      (_) => ref.invalidateSelf(),
    );
  }
}
