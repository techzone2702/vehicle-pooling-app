/// Represents a vehicle registered by a vehicle owner for carpooling.
class VehicleModel {
  final String id;
  final String ownerId;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final String color;
  final int seatsCapacity;
  final String? fuelType;
  final bool isVerified;

  const VehicleModel({
    required this.id,
    required this.ownerId,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
    required this.seatsCapacity,
    this.fuelType,
    this.isVerified = false,
  });

  /// Readable display name (e.g., "Toyota Corolla (2022)")
  String get displayName => '$make $model ($year)';

  VehicleModel copyWith({
    String? id,
    String? ownerId,
    String? make,
    String? model,
    int? year,
    String? licensePlate,
    String? color,
    int? seatsCapacity,
    String? fuelType,
    bool? isVerified,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      color: color ?? this.color,
      seatsCapacity: seatsCapacity ?? this.seatsCapacity,
      fuelType: fuelType ?? this.fuelType,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'make': make,
      'model': model,
      'year': year,
      'license_plate': licensePlate,
      'color': color,
      'seats_capacity': seatsCapacity,
      'fuel_type': fuelType,
      'is_verified': isVerified,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] as String? ?? '',
      ownerId: map['owner_id'] as String? ?? '',
      make: map['make'] as String? ?? '',
      model: map['model'] as String? ?? '',
      year: map['year'] as int? ?? 2020,
      licensePlate: map['license_plate'] as String? ?? '',
      color: map['color'] as String? ?? '',
      seatsCapacity: map['seats_capacity'] as int? ?? 4,
      fuelType: map['fuel_type'] as String?,
      isVerified: map['is_verified'] as bool? ?? false,
    );
  }
}
