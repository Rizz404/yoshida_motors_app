import 'dart:async';

import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/models/appraisal_request.dart';
import 'package:car_rongsok_app/feature/appraisal/models/create_appraisal_payload.dart';
import 'package:car_rongsok_app/feature/appraisal/models/get_appraisals_params.dart';
import 'package:car_rongsok_app/feature/appraisal/providers/latest_appraisal_provider.dart';
import 'package:car_rongsok_app/feature/appraisal/repositories/appraisal_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// APPRAISAL LIST STATE
// ==========================================
class AppraisalListState extends Equatable {
  final List<AppraisalRequest> items;
  final String? nextCursor;
  final bool hasMore;
  final GetAppraisalsParams params;
  final bool isLoadingMore;
  final ApiFailure<dynamic>? failure;

  // * Single mutation state — create & delete share one slot
  final bool isMutating;
  final ApiFailure<dynamic>? mutationError;

  const AppraisalListState({
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.params = const GetAppraisalsParams(),
    this.isLoadingMore = false,
    this.failure,
    this.isMutating = false,
    this.mutationError,
  });

  bool get isEmpty => items.isEmpty;

  AppraisalListState copyWith({
    List<AppraisalRequest>? items,
    String? Function()? nextCursor,
    bool? hasMore,
    GetAppraisalsParams? params,
    bool? isLoadingMore,
    ApiFailure<dynamic>? Function()? failure,
    bool? isMutating,
    ApiFailure<dynamic>? Function()? mutationError,
  }) {
    return AppraisalListState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      params: params ?? this.params,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure != null ? failure() : this.failure,
      isMutating: isMutating ?? this.isMutating,
      mutationError: mutationError != null
          ? mutationError()
          : this.mutationError,
    );
  }

  @override
  List<Object?> get props => [
    items,
    nextCursor,
    hasMore,
    params,
    isLoadingMore,
    failure,
    isMutating,
    mutationError,
  ];
}

// ==========================================
// APPRAISAL LIST NOTIFIER
// ==========================================
final appraisalListNotifierProvider =
    AsyncNotifierProvider<AppraisalListNotifier, AppraisalListState>(
      AppraisalListNotifier.new,
    );

class AppraisalListNotifier extends AsyncNotifier<AppraisalListState> {
  late AppraisalRepository _appraisalRepository;

  @override
  FutureOr<AppraisalListState> build() async {
    _appraisalRepository = ref.read(appraisalRepositoryProvider);
    return _fetchFirstPage(const GetAppraisalsParams());
  }

  Future<AppraisalListState> _fetchFirstPage(GetAppraisalsParams params) async {
    final result = await _appraisalRepository.getAppraisals(params).run();

    return result.fold(
      (failure) => AppraisalListState(params: params, failure: failure),
      (success) => AppraisalListState(
        items: success.items,
        nextCursor: success.meta.nextCursor,
        hasMore: success.meta.hasMore,
        params: params,
      ),
    );
  }

  /// Load more (infinite scroll) — append ke list yang sudah ada
  Future<void> fetchMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextParams = current.params.copyWith(cursor: current.nextCursor);
    final result = await _appraisalRepository.getAppraisals(nextParams).run();

    state = AsyncData(
      result.fold(
        (failure) =>
            current.copyWith(isLoadingMore: false, failure: () => failure),
        (success) => current.copyWith(
          items: [...current.items, ...success.items],
          nextCursor: () => success.meta.nextCursor,
          hasMore: success.meta.hasMore,
          isLoadingMore: false,
          failure: () => null,
        ),
      ),
    );
  }

  /// Terapkan filter baru — reset list dan fetch dari awal
  Future<void> applyFilter(GetAppraisalsParams params) async {
    state = const AsyncLoading<AppraisalListState>();
    state = AsyncData(await _fetchFirstPage(params));
  }

  /// Refresh dengan params yang sama — reset cursor ke awal
  Future<void> refresh() async {
    final current = state.value?.params ?? const GetAppraisalsParams();
    final freshParams = GetAppraisalsParams(
      search: current.search,
      status: current.status,
      yearMin: current.yearMin,
      yearMax: current.yearMax,
      sortBy: current.sortBy,
      sortDir: current.sortDir,
      perPage: current.perPage,
    );
    state = const AsyncLoading<AppraisalListState>();
    state = AsyncData(await _fetchFirstPage(freshParams));
  }

  /// Tambah appraisal baru — re-fetch dari server setelah sukses
  Future<void> createAppraisal(CreateAppraisalPayload payload) async {
    final current = state.value;
    if (current == null) return;

    // * Mutation loading — list tetap kelihatan
    state = AsyncData(
      current.copyWith(isMutating: true, mutationError: () => null),
    );

    final result = await _appraisalRepository.createAppraisal(payload).run();

    result.fold(
      (failure) => state = AsyncData(
        current.copyWith(isMutating: false, mutationError: () => failure),
      ),
      // * Re-fetch fresh data from server
      (_) {
        ref.invalidate(latestAppraisalNotifierProvider);
        ref.invalidateSelf();
      },
    );
  }

  /// Hapus appraisal — re-fetch dari server setelah sukses
  Future<void> deleteAppraisal(int id) async {
    final current = state.value;
    if (current == null) return;

    // * Mutation loading — list tetap kelihatan
    state = AsyncData(
      current.copyWith(isMutating: true, mutationError: () => null),
    );

    final result = await _appraisalRepository.deleteAppraisal(id).run();

    result.fold(
      (failure) => state = AsyncData(
        current.copyWith(isMutating: false, mutationError: () => failure),
      ),
      // * Re-fetch fresh data from server
      (_) {
        ref.invalidate(latestAppraisalNotifierProvider);
        ref.invalidateSelf();
      },
    );
  }
}
