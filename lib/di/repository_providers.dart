import 'package:car_rongsok_app/di/common_providers.dart';
import 'package:car_rongsok_app/di/service_providers.dart';
import 'package:car_rongsok_app/feature/appraisal/repositories/appraisal_repository.dart';
import 'package:car_rongsok_app/feature/auth/repositories/auth_repository.dart';
import 'package:car_rongsok_app/feature/notification/repositories/notification_repository.dart';
import 'package:car_rongsok_app/feature/user/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// REPOSITORY PROVIDERS
// ==========================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(dioClient, authService);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final _dioClient = ref.watch(dioClientProvider);
  final _authService = ref.watch(authServiceProvider);

  return UserRepositoryImpl(_dioClient, _authService);
});

final appraisalRepositoryProvider = Provider<AppraisalRepository>((ref) {
  final _dioClient = ref.watch(dioClientProvider);

  return AppraisalRepositoryImpl(_dioClient);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final _dioClient = ref.watch(dioClientProvider);

  return NotificationRepositoryImpl(_dioClient);
});
