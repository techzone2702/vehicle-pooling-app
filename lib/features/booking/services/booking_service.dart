import '../../../models/booking_model.dart';
import '../../rides/services/ride_service.dart';

/// Booking management service contract for ride requests, acceptance, rejection, and queries.
abstract class BookingService {
  Future<BookingModel> createBookingRequest({
    required String rideId,
    required String passengerId,
    required int seats,
    required double totalPrice,
    String? passengerName,
    String? passengerPhone,
    String? source,
    String? destination,
    DateTime? departureTime,
  });

  Future<BookingModel> acceptBookingRequest(String bookingId);
  Future<BookingModel> rejectBookingRequest(String bookingId);

  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });

  Future<List<BookingModel>> getBookingsForUser(String userId);
  Future<List<BookingModel>> getIncomingRequestsForDriver(String driverId);
  Future<List<BookingModel>> getRequestsForRide(String rideId);
  Future<bool> hasPendingRequestForRide({
    required String rideId,
    required String passengerId,
  });
}

/// Placeholder in-memory implementation of [BookingService].
class PlaceholderBookingService implements BookingService {
  /// Shared singleton instance for app-wide in-memory persistence.
  static final PlaceholderBookingService instance = PlaceholderBookingService();

  late final List<BookingModel> _bookings;

  PlaceholderBookingService() {
    _bookings = _generateDefaultMockBookings();
  }

  static List<BookingModel> _generateDefaultMockBookings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final futureToday1 = now.hour < 23
        ? DateTime(now.year, now.month, now.day, now.hour + 1, 15)
        : now.add(const Duration(minutes: 5));

    return [
      // 1. Sent request 1 by user u_1 (Pending)
      BookingModel(
        id: 'book_p1',
        rideId: 'ride_102',
        passengerId: 'u_1',
        passengerName: 'Rahul Sharma',
        passengerPhone: '+91 98765 43210',
        seatsBooked: 2,
        totalPrice: 280.0,
        status: BookingStatus.pending,
        source: 'Koramangala, Bengaluru',
        destination: 'Whitefield Tech Park',
        departureTime: futureToday1,
        requestedAt: now.subtract(const Duration(minutes: 30)),
      ),

      // 2. Sent request 2 by user u_1 (Accepted)
      BookingModel(
        id: 'book_p2',
        rideId: 'ride_104',
        passengerId: 'u_1',
        passengerName: 'Rahul Sharma',
        passengerPhone: '+91 98765 43210',
        seatsBooked: 1,
        totalPrice: 180.0,
        status: BookingStatus.accepted,
        source: 'Indiranagar 100ft Road',
        destination: 'Electronic City Phase 1',
        departureTime: futureToday1,
        requestedAt: now.subtract(const Duration(hours: 4)),
        respondedAt: now.subtract(const Duration(hours: 3)),
      ),

      // 3. Sent request 3 by user u_1 (Rejected history)
      BookingModel(
        id: 'book_p3',
        rideId: 'ride_105',
        passengerId: 'u_1',
        passengerName: 'Rahul Sharma',
        passengerPhone: '+91 98765 43210',
        seatsBooked: 1,
        totalPrice: 150.0,
        status: BookingStatus.rejected,
        source: 'Koramangala, Bengaluru',
        destination: 'Whitefield Tech Park',
        departureTime: DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          9,
          30,
        ),
        requestedAt: now.subtract(const Duration(days: 1)),
        respondedAt: now.subtract(const Duration(hours: 20)),
      ),

      // 4. Incoming request for driver u_1 on ride_101 (Pending)
      BookingModel(
        id: 'book_d1',
        rideId: 'ride_101',
        passengerId: 'u_2',
        passengerName: 'Ankit Mehra',
        passengerPhone: '+91 98112 34567',
        seatsBooked: 1,
        totalPrice: 150.0,
        status: BookingStatus.pending,
        source: 'Downtown Metro Station',
        destination: 'Tech Park Campus',
        departureTime: futureToday1,
        requestedAt: now.subtract(const Duration(minutes: 15)),
      ),

      // 5. Incoming request for driver u_1 on ride_101 (Accepted)
      BookingModel(
        id: 'book_d2',
        rideId: 'ride_101',
        passengerId: 'u_3',
        passengerName: 'Meera Nair',
        passengerPhone: '+91 97223 45678',
        seatsBooked: 1,
        totalPrice: 150.0,
        status: BookingStatus.accepted,
        source: 'Downtown Metro Station',
        destination: 'Tech Park Campus',
        departureTime: futureToday1,
        requestedAt: now.subtract(const Duration(hours: 2)),
        respondedAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }

  /// Restores or overwrites the mock booking list (useful for test resets).
  void resetMockBookings([List<BookingModel>? customBookings]) {
    _bookings.clear();
    _bookings.addAll(customBookings ?? _generateDefaultMockBookings());
  }

  /// Read-only snapshot of all stored bookings.
  List<BookingModel> get allBookings => List.unmodifiable(_bookings);

  @override
  Future<BookingModel> createBookingRequest({
    required String rideId,
    required String passengerId,
    required int seats,
    required double totalPrice,
    String? passengerName,
    String? passengerPhone,
    String? source,
    String? destination,
    DateTime? departureTime,
  }) async {
    if (seats <= 0) {
      throw ArgumentError('Requested seats must be greater than zero.');
    }

    final ride = await PlaceholderRideService.instance.getRideById(rideId);
    if (ride == null) {
      throw Exception('Ride not found.');
    }

    if (ride.driverId == passengerId) {
      throw Exception('You cannot request to join your own ride.');
    }

    if (seats > ride.availableSeats) {
      throw Exception(
        'Requested seats ($seats) exceed available capacity (${ride.availableSeats}).',
      );
    }

    final alreadyPending = _bookings.any(
      (b) =>
          b.rideId == rideId &&
          b.passengerId == passengerId &&
          b.status == BookingStatus.pending,
    );
    if (alreadyPending) {
      throw Exception('You already have a pending join request for this ride.');
    }

    final booking = BookingModel(
      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
      rideId: rideId,
      passengerId: passengerId,
      seatsBooked: seats,
      totalPrice: totalPrice,
      status: BookingStatus.pending,
      requestedAt: DateTime.now(),
      passengerName: passengerName ?? 'Passenger',
      passengerPhone: passengerPhone ?? '+91 98765 00000',
      source: source ?? ride.source,
      destination: destination ?? ride.destination,
      departureTime: departureTime ?? ride.departureTime,
    );

    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<BookingModel> acceptBookingRequest(String bookingId) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) {
      throw Exception('Booking request not found.');
    }

    final booking = _bookings[index];
    if (booking.status == BookingStatus.accepted) {
      throw Exception('This request has already been accepted.');
    }
    if (booking.status == BookingStatus.rejected) {
      throw Exception('Cannot accept a rejected request.');
    }

    final ride = await PlaceholderRideService.instance.getRideById(
      booking.rideId,
    );
    if (ride == null) {
      throw Exception('Associated ride not found.');
    }

    if (ride.availableSeats < booking.seatsBooked) {
      throw Exception(
        'Insufficient remaining seats on this ride (Requested: ${booking.seatsBooked}, Available: ${ride.availableSeats}).',
      );
    }

    final seatUpdated = await PlaceholderRideService.instance
        .updateAvailableSeats(
          rideId: ride.id,
          seatsToDeduct: booking.seatsBooked,
        );
    if (!seatUpdated) {
      throw Exception('Failed to update remaining seat capacity on ride.');
    }

    final accepted = booking.copyWith(
      status: BookingStatus.accepted,
      respondedAt: DateTime.now(),
    );
    _bookings[index] = accepted;
    return accepted;
  }

  @override
  Future<BookingModel> rejectBookingRequest(String bookingId) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) {
      throw Exception('Booking request not found.');
    }

    final booking = _bookings[index];
    if (booking.status != BookingStatus.pending) {
      throw Exception('This request has already been processed.');
    }

    final rejected = booking.copyWith(
      status: BookingStatus.rejected,
      respondedAt: DateTime.now(),
    );
    _bookings[index] = rejected;
    return rejected;
  }

  @override
  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    if (status == BookingStatus.accepted) {
      return acceptBookingRequest(bookingId);
    }
    if (status == BookingStatus.rejected) {
      return rejectBookingRequest(bookingId);
    }

    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final updated = _bookings[index].copyWith(
        status: status,
        respondedAt: DateTime.now(),
      );
      _bookings[index] = updated;
      return updated;
    }
    throw Exception('Booking not found');
  }

  @override
  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    return _bookings.where((b) => b.passengerId == userId).toList();
  }

  @override
  Future<List<BookingModel>> getIncomingRequestsForDriver(
    String driverId,
  ) async {
    final driverRides = await PlaceholderRideService.instance
        .getRidesOfferedByDriver(driverId);
    final rideIds = driverRides.map((r) => r.id).toSet();
    return _bookings.where((b) => rideIds.contains(b.rideId)).toList();
  }

  @override
  Future<List<BookingModel>> getRequestsForRide(String rideId) async {
    return _bookings.where((b) => b.rideId == rideId).toList();
  }

  /// Synchronous check for pending request against the current in-memory store.
  bool hasPendingRequestForRideSync({
    required String rideId,
    required String passengerId,
  }) {
    return _bookings.any(
      (b) =>
          b.rideId == rideId &&
          b.passengerId == passengerId &&
          b.status == BookingStatus.pending,
    );
  }

  @override
  Future<bool> hasPendingRequestForRide({
    required String rideId,
    required String passengerId,
  }) async {
    return hasPendingRequestForRideSync(
      rideId: rideId,
      passengerId: passengerId,
    );
  }
}
