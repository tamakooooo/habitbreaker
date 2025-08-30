import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_breaker_app/core/services/auth_service.dart';
import 'package:habit_breaker_app/models/user.dart';

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provider for the current user
final userProvider = StateProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

// Provider for authentication state
final authStateProvider = StateProvider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isAuthenticated;
});
