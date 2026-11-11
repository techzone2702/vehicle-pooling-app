/// Lifecycle status of a ride joining/booking request.
enum BookingStatus { pending, accepted, rejected, cancelled }

/// Represents a booking / joining request made by a passenger for a ride.
class BookingModel {
  final String id;
  final String rideId;
  final String passengerId;
  final int seatsBooked;
  final double totalPrice;
  final BookingStatus status;
  final DateTime requestedAt;
  final DateTime? respondedAt;

  const BookingModel({
    required this.id,
    required this.rideId,
    required this.passengerId,
    required this.seatsBooked,
    required this.totalPrice,
    this.status = BookingStatus.pending,
    required this.requestedAt,
    this.respondedAt,
  });

  bool get isPending => status == BookingStatus.pending;
  bool get isAccepted => status == BookingStatus.accepted;
  bool get isRejected => status == BookingStatus.rejected;
  bool get isCancelled => status == BookingStatus.cancelled;

  BookingModel copyWith({
    String? id,
    String? rideId,
    String? passengerId,
    int? seatsBooked,
    double? totalPrice,
    BookingStatus? status,
    DateTime? requestedAt,
    DateTime? respondedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      rideId: rideId ?? this.rideId,
      passengerId: passengerId ?? this.passengerId,
      seatsBooked: seatsBooked ?? this.seatsBooked,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ride_id': rideId,
      'passenger_id': passengerId,
      'seats_booked': seatsBooked,
      'total_price': totalPrice,
      'status': status.name,
      'requested_at': requestedAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as String? ?? '',
      rideId: map['ride_id'] as String? ?? '',
      passengerId: map['passenger_id'] as String? ?? '',
      seatsBooked: map['seats_booked'] as int? ?? 1,
      totalPrice: (map['total_price'] as num?)?.toDouble() ?? 0.0,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      requestedAt: map['requested_at'] != null
          ? DateTime.tryParse(map['requested_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      respondedAt: map['responded_at'] != null
          ? DateTime.tryParse(map['responded_at'] as String)
          : null,
    );
  }
}
