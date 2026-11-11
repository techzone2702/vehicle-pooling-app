/// Represents an application user (both vehicle owners/drivers and passengers).
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? bio;
  final double rating;
  final int totalRidesAsDriver;
  final int totalRidesAsPassenger;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.bio,
    this.rating = 5.0,
    this.totalRidesAsDriver = 0,
    this.totalRidesAsPassenger = 0,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? bio,
    double? rating,
    int? totalRidesAsDriver,
    int? totalRidesAsPassenger,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalRidesAsDriver: totalRidesAsDriver ?? this.totalRidesAsDriver,
      totalRidesAsPassenger:
          totalRidesAsPassenger ?? this.totalRidesAsPassenger,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'rating': rating,
      'total_rides_as_driver': totalRidesAsDriver,
      'total_rides_as_passenger': totalRidesAsPassenger,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      profileImageUrl: map['profile_image_url'] as String?,
      bio: map['bio'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      totalRidesAsDriver: map['total_rides_as_driver'] as int? ?? 0,
      totalRidesAsPassenger: map['total_rides_as_passenger'] as int? ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
