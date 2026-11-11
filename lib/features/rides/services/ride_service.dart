import '../../../models/ride_model.dart';

/// Ride management service contract for creating, searching, and managing ride offers.
abstract class RideService {
  Future<List<RideModel>> searchRides({
    required String source,
    required String destination,
    required DateTime date,
  });
  Future<RideModel> createRide(RideModel ride);
  Future<List<RideModel>> getRidesOfferedByDriver(String driverId);
  Future<RideModel?> getRideById(String rideId);
}

/// Placeholder implementation of [RideService].
class PlaceholderRideService implements RideService {
  /// Shared singleton instance for app-wide in-memory persistence.
  static final PlaceholderRideService instance = PlaceholderRideService();

  final List<RideModel> _mockRides = [
    RideModel(
      id: 'ride_101',
      driverId: 'u_1',
      vehicleId: 'v_1',
      source: 'Downtown Metro Station',
      destination: 'Tech Park Campus',
      departureTime: DateTime.now().add(const Duration(hours: 3)),
      availableSeats: 3,
      totalSeats: 4,
      pricePerSeat: 150.0,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<RideModel>> searchRides({
    required String source,
    required String destination,
    required DateTime date,
  }) async {
    return _mockRides;
  }

  @override
  Future<RideModel> createRide(RideModel ride) async {
    _mockRides.insert(0, ride);
    return ride;
  }

  @override
  Future<List<RideModel>> getRidesOfferedByDriver(String driverId) async {
    return _mockRides.where((r) => r.driverId == driverId).toList();
  }

  @override
  Future<RideModel?> getRideById(String rideId) async {
    try {
      return _mockRides.firstWhere((r) => r.id == rideId);
    } catch (_) {
      return null;
    }
  }
}
