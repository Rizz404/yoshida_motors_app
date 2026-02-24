import 'dart:async';

import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/repositories/appraisal_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// LATEST APPRAISAL STATE
// ==========================================
class LatestAppraisalState extends Equatable {
  final AppraisalRequest? appraisal;
  final ApiFailure<dynamic>? failure;

  const LatestAppraisalState({this.appraisal, this.failure});

  LatestAppraisalState copyWith({
    AppraisalRequest? Function()? appraisal,
    ApiFailure<dynamic>? Function()? failure,
  }) {
    return LatestAppraisalState(
      appraisal: appraisal != null ? appraisal() : this.appraisal,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [appraisal, failure];
}

// ==========================================
// LATEST APPRAISAL NOTIFIER
// ==========================================
final latestAppraisalNotifierProvider =
    AsyncNotifierProvider<LatestAppraisalNotifier, LatestAppraisalState>(
      LatestAppraisalNotifier.new,
    );

class LatestAppraisalNotifier extends AsyncNotifier<LatestAppraisalState> {
  late AppraisalRepository _appraisalRepository;

  @override
  FutureOr<LatestAppraisalState> build() async {
    _appraisalRepository = ref.read(appraisalRepositoryProvider);
    return _fetchLatest();
  }

  Future<LatestAppraisalState> _fetchLatest() async {
    final result = await _appraisalRepository.getLatestAppraisal().run();

    return result.fold(
      (failure) => LatestAppraisalState(failure: failure),
      (success) => LatestAppraisalState(appraisal: success.data),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchLatest);
  }
}
