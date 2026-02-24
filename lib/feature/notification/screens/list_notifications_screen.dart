import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/date_time_extension.dart';
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/feature/notification/models/notification.dart'
    as model;
import 'package:car_rongsok_app/feature/notification/providers/notification_provider.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ListNotificationsScreen extends ConsumerWidget {
  const ListNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listStateAsync = ref.watch(notificationListNotifierProvider);
    final notifier = ref.read(notificationListNotifierProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          listStateAsync.maybeWhen(
            data: (state) {
              if (state.unreadCount > 0) {
                return IconButton(
                  icon: Icon(
                    Icons.done_all_rounded,
                    color: context.colorScheme.primary,
                  ),
                  tooltip: 'Mark All Read',
                  onPressed: notifier.markAllAsRead,
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: ScreenWrapper(
        child: RefreshIndicator(
          onRefresh: notifier.refresh,
          child: listStateAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: AppText(
                'Failed to load notifications',
                color: context.semantic.error,
              ),
            ),
            data: (state) {
              if (state.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 64,
                            color: context.colors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          AppText(
                            'No notifications yet',
                            style: AppTextStyle.titleMedium,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      state.hasMore &&
                      !state.isLoadingMore) {
                    notifier.fetchMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _buildNotificationCard(
                      context,
                      notification: state.items[index],
                      onTap: () {
                        if (!state.items[index].isRead) {
                          notifier.markAsRead(state.items[index].id);
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required model.Notification notification,
    required VoidCallback onTap,
  }) {
    return Card(
      color: notification.isRead
          ? context.colors.card
          : context.colorScheme.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead
              ? context.colors.border
              : context.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2, right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? context.colors.surface
                      : context.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  size: 20,
                  color: notification.isRead
                      ? context.colors.textTertiary
                      : context.colorScheme.primary,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppText(
                            notification.title,
                            style: AppTextStyle.titleSmall,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          notification.createdAt.timeAgo,
                          style: AppTextStyle.labelMedium,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      notification.body,
                      style: AppTextStyle.bodyMedium,
                      color: notification.isRead
                          ? context.colors.textSecondary
                          : context.colors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
