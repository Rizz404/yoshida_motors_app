import 'dart:async';

import 'package:car_rongsok_app/core/network/api_wrapper.dart';
import 'package:car_rongsok_app/di/repository_providers.dart';
import 'package:car_rongsok_app/feature/notification/models/get_notifications_params.dart';
import 'package:car_rongsok_app/feature/notification/models/notification.dart';
import 'package:car_rongsok_app/feature/notification/repositories/notification_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// NOTIFICATION LIST STATE
// ==========================================
class NotificationListState extends Equatable {
  final List<Notification> items;
  final String? nextCursor;
  final bool hasMore;
  final GetNotificationsParams params;
  final bool isLoadingMore;
  final ApiFailure<dynamic>? failure;

  // Single mutation state
  final bool isMutating;
  final ApiFailure<dynamic>? mutationError;

  const NotificationListState({
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.params = const GetNotificationsParams(),
    this.isLoadingMore = false,
    this.failure,
    this.isMutating = false,
    this.mutationError,
  });

  bool get isEmpty => items.isEmpty;

  int get unreadCount => items.where((i) => !i.isRead).length;

  NotificationListState copyWith({
    List<Notification>? items,
    String? Function()? nextCursor,
    bool? hasMore,
    GetNotificationsParams? params,
    bool? isLoadingMore,
    ApiFailure<dynamic>? Function()? failure,
    bool? isMutating,
    ApiFailure<dynamic>? Function()? mutationError,
  }) {
    return NotificationListState(
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
// NOTIFICATION LIST NOTIFIER
// ==========================================
final notificationListNotifierProvider =
    AsyncNotifierProvider<NotificationListNotifier, NotificationListState>(
      NotificationListNotifier.new,
    );

class NotificationListNotifier extends AsyncNotifier<NotificationListState> {
  late NotificationRepository _notificationRepository;

  @override
  FutureOr<NotificationListState> build() async {
    _notificationRepository = ref.read(notificationRepositoryProvider);
    return _fetchFirstPage(const GetNotificationsParams());
  }

  Future<NotificationListState> _fetchFirstPage(
    GetNotificationsParams params,
  ) async {
    final result = await _notificationRepository.getNotifications(params).run();

    return result.fold(
      (failure) => NotificationListState(params: params, failure: failure),
      (success) => NotificationListState(
        items: success.items,
        nextCursor: success.meta.nextCursor,
        hasMore: success.meta.hasMore,
        params: params,
      ),
    );
  }

  /// Load more (infinite scroll)
  Future<void> fetchMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextParams = current.params.copyWith(cursor: current.nextCursor);
    final result = await _notificationRepository
        .getNotifications(nextParams)
        .run();

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

  /// Refresh — reset cursor ke awal
  Future<void> refresh() async {
    final currentParams = state.value?.params ?? const GetNotificationsParams();
    state = const AsyncLoading<NotificationListState>();
    state = AsyncData(
      await _fetchFirstPage(currentParams.copyWith(cursor: null)),
    );
  }

  /// Mark specific notification as read
  Future<void> markAsRead(int notificationId) async {
    final current = state.value;
    if (current == null) return;

    // Optimistic update
    final newItems = current.items.map((n) {
      if (n.id == notificationId) return n.copyWith(isRead: true);
      return n;
    }).toList();

    state = AsyncData(current.copyWith(items: newItems));

    final result = await _notificationRepository
        .markAsRead(notificationId)
        .run();

    // Revert if failed
    result.fold(
      (failure) {
        state = AsyncData(
          current.copyWith(mutationError: () => failure, items: current.items),
        );
      },
      (_) {}, // Success, keep optimistic update
    );
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(isMutating: true, mutationError: () => null),
    );

    // Optimistic update
    final newItems = current.items
        .map((n) => n.copyWith(isRead: true))
        .toList();
    state = AsyncData(current.copyWith(items: newItems, isMutating: true));

    final result = await _notificationRepository.markAllAsRead().run();

    result.fold(
      (failure) {
        // Revert if failed
        state = AsyncData(
          current.copyWith(
            isMutating: false,
            mutationError: () => failure,
            items: current.items,
          ),
        );
      },
      (_) {
        state = AsyncData(current.copyWith(isMutating: false));
        ref.invalidateSelf(); // Refresh to ensure sync with server
      },
    );
  }
}
