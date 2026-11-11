import '../../../models/booking_model.dart';

/// Booking management service contract for ride requests, acceptance, and cancellation.
abstract class BookingService {
  Future<BookingModel> createBookingRequest({
    required String rideId,
    required String passengerId,
    required int seats,
    required double totalPrice,
  });
  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });
  Future<List<BookingModel>> getBookingsForUser(String userId);
  Future<List<BookingModel>> getRequestsForRide(String rideId);
}

/// Placeholder implementation of [BookingService].
class PlaceholderBookingService implements BookingService {
  final List<BookingModel> _bookings = [];

  @override
  Future<BookingModel> createBookingRequest({
    required String rideId,
    required String passengerId,
    required int seats,
    required double totalPrice,
  }) async {
    final booking = BookingModel(
      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
      rideId: rideId,
      passengerId: passengerId,
      seatsBooked: seats,
      totalPrice: totalPrice,
      status: BookingStatus.pending,
      requestedAt: DateTime.now(),
    );
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
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
  Future<List<BookingModel>> getRequestsForRide(String rideId) async {
    return _bookings.where((b) => b.rideId == rideId).toList();
  }
}
