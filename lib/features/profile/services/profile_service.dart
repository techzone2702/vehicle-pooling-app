import '../../../models/user_model.dart';

/// Profile service contract for reading and updating user profile data.
abstract class ProfileService {
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> updateProfile(UserModel user);
}

/// Placeholder implementation of [ProfileService].
class PlaceholderProfileService implements ProfileService {
  @override
  Future<UserModel> getUserProfile(String userId) async {
    return UserModel(
      id: userId,
      name: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1 555-0199',
      rating: 4.85,
      totalRidesAsDriver: 14,
      totalRidesAsPassenger: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    return user;
  }
}
