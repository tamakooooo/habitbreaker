import 'package:habit_breaker_app/models/user.dart';

class AuthService {
  User? _currentUser;

  // Get current user
  User? get currentUser => _currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  // Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    // In a real implementation, you would call an API here
    // For now, we'll create a mock user
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: email.split('@').first,
    );

    return _currentUser!;
  }

  // Sign up with email and password
  Future<User> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    // In a real implementation, you would call an API here
    // For now, we'll create a mock user
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
    );

    return _currentUser!;
  }

  // Sign out
  Future<void> signOut() async {
    // In a real implementation, you would call an API here
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  // Sign in anonymously
  Future<User> signInAnonymously() async {
    // In a real implementation, you would call an API here
    // For now, we'll create a mock anonymous user
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: 'anonymous_${DateTime.now().millisecondsSinceEpoch}',
      email: 'anonymous@example.com',
      name: 'Anonymous User',
    );

    return _currentUser!;
  }
}
