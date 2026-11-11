import '../../../models/user_model.dart';

/// Authentication service contract prepared for future backend/Firebase integration.
abstract class AuthService {
  Future<UserModel?> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

/// Placeholder authentication service implementation.
class PlaceholderAuthService implements AuthService {
  UserModel? _currentUser;

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    _currentUser = UserModel(
      id: 'mock_user_1',
      name: 'Sample User',
      email: email,
      phoneNumber: '+1234567890',
      createdAt: DateTime.now(),
    );
    return _currentUser;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _currentUser = UserModel(
      id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(_currentUser);
}
