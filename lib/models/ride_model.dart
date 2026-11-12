/// Status enum representing the lifecycle of a ride.
enum RideStatus { scheduled, ongoing, completed, cancelled }

/// Represents a ride offered by a vehicle owner/driver.
class RideModel {
  final String id;
  final String driverId;
  final String vehicleId;
  final String source;
  final double? sourceLatitude;
  final double? sourceLongitude;
  final String destination;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final DateTime departureTime;
  final int availableSeats;
  final int totalSeats;
  final double pricePerSeat;
  final String? notes;
  final RideStatus status;
  final DateTime createdAt;
  final String? driverName;
  final double? driverRating;
  final String? vehicleInfo;

  const RideModel({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.source,
    this.sourceLatitude,
    this.sourceLongitude,
    required this.destination,
    this.destinationLatitude,
    this.destinationLongitude,
    required this.departureTime,
    required this.availableSeats,
    required this.totalSeats,
    required this.pricePerSeat,
    this.notes,
    this.status = RideStatus.scheduled,
    required this.createdAt,
    this.driverName,
    this.driverRating,
    this.vehicleInfo,
  });

  /// Check whether seats are still available
  bool get hasAvailableSeats => availableSeats > 0;

  RideModel copyWith({
    String? id,
    String? driverId,
    String? vehicleId,
    String? source,
    double? sourceLatitude,
    double? sourceLongitude,
    String? destination,
    double? destinationLatitude,
    double? destinationLongitude,
    DateTime? departureTime,
    int? availableSeats,
    int? totalSeats,
    double? pricePerSeat,
    String? notes,
    RideStatus? status,
    DateTime? createdAt,
    String? driverName,
    double? driverRating,
    String? vehicleInfo,
  }) {
    return RideModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      source: source ?? this.source,
      sourceLatitude: sourceLatitude ?? this.sourceLatitude,
      sourceLongitude: sourceLongitude ?? this.sourceLongitude,
      destination: destination ?? this.destination,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      driverName: driverName ?? this.driverName,
      driverRating: driverRating ?? this.driverRating,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driver_id': driverId,
      'vehicle_id': vehicleId,
      'source': source,
      'source_latitude': sourceLatitude,
      'source_longitude': sourceLongitude,
      'destination': destination,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'departure_time': departureTime.toIso8601String(),
      'available_seats': availableSeats,
      'total_seats': totalSeats,
      'price_per_seat': pricePerSeat,
      'notes': notes,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'driver_name': driverName,
      'driver_rating': driverRating,
      'vehicle_info': vehicleInfo,
    };
  }

  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      id: map['id'] as String? ?? '',
      driverId: map['driver_id'] as String? ?? '',
      vehicleId: map['vehicle_id'] as String? ?? '',
      source: map['source'] as String? ?? '',
      sourceLatitude: (map['source_latitude'] as num?)?.toDouble(),
      sourceLongitude: (map['source_longitude'] as num?)?.toDouble(),
      destination: map['destination'] as String? ?? '',
      destinationLatitude: (map['destination_latitude'] as num?)?.toDouble(),
      destinationLongitude: (map['destination_longitude'] as num?)?.toDouble(),
      departureTime: map['departure_time'] != null
          ? DateTime.tryParse(map['departure_time'] as String) ?? DateTime.now()
          : DateTime.now(),
      availableSeats: map['available_seats'] as int? ?? 1,
      totalSeats: map['total_seats'] as int? ?? 4,
      pricePerSeat: (map['price_per_seat'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'] as String?,
      status: RideStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RideStatus.scheduled,
      ),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      driverName: map['driver_name'] as String?,
      driverRating: (map['driver_rating'] as num?)?.toDouble(),
      vehicleInfo: map['vehicle_info'] as String?,
    );
  }
}
