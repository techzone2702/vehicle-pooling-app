import '../../../models/ride_model.dart';

/// Specific reason why a search returned zero rides.
enum RideSearchEmptyReason {
  none,
  noMatchingRoute,
  noRidesOnSelectedDate,
  allRidesFullyBooked,
  allRidesDeparted,
}

/// Detailed result container for a ride search query.
class RideSearchResult {
  final List<RideModel> rides;
  final RideSearchEmptyReason emptyReason;

  const RideSearchResult({
    required this.rides,
    this.emptyReason = RideSearchEmptyReason.none,
  });
}

/// Ride management service contract for creating, searching, and managing ride offers.
abstract class RideService {
  Future<List<RideModel>> searchRides({
    required String source,
    required String destination,
    required DateTime date,
    String? currentUserId,
  });

  Future<RideSearchResult> searchRidesDetailed({
    required String source,
    required String destination,
    required DateTime date,
    String? currentUserId,
  });

  Future<RideModel> createRide(RideModel ride);
  Future<List<RideModel>> getRidesOfferedByDriver(String driverId);
  Future<RideModel?> getRideById(String rideId);
  Future<bool> updateAvailableSeats({
    required String rideId,
    required int seatsToDeduct,
  });
}

/// Placeholder implementation of [RideService].
class PlaceholderRideService implements RideService {
  /// Shared singleton instance for app-wide in-memory persistence.
  static final PlaceholderRideService instance = PlaceholderRideService();

  late final List<RideModel> _mockRides;

  PlaceholderRideService() {
    _mockRides = _generateDefaultMockRides();
  }

  static List<RideModel> _generateDefaultMockRides() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    // Future departure times for today guaranteed to be upcoming
    final futureToday1 = now.hour < 23
        ? DateTime(now.year, now.month, now.day, now.hour + 1, 15)
        : now.add(const Duration(minutes: 5));

    final futureToday2 = now.hour < 22
        ? DateTime(now.year, now.month, now.day, now.hour + 2, 45)
        : now.add(const Duration(minutes: 8));

    // Departed time for testing past exclusion
    final departedToday = now.subtract(const Duration(hours: 2));

    return [
      // 1. Current user's own ride (driverId: 'u_1')
      RideModel(
        id: 'ride_101',
        driverId: 'u_1',
        vehicleId: 'v_1',
        source: 'Downtown Metro Station',
        destination: 'Tech Park Campus',
        departureTime: futureToday1,
        availableSeats: 3,
        totalSeats: 4,
        pricePerSeat: 150.0,
        driverName: 'Rahul Sharma',
        driverRating: 4.8,
        vehicleInfo: 'Honda City • KA-01-AB-1234',
        createdAt: now,
      ),

      // 2. Active ride 1: Koramangala -> Whitefield (Priya Singh)
      RideModel(
        id: 'ride_102',
        driverId: 'u_2',
        vehicleId: 'v_2',
        source: 'Koramangala, Bengaluru',
        destination: 'Whitefield Tech Park',
        departureTime: futureToday1,
        availableSeats: 3,
        totalSeats: 4,
        pricePerSeat: 140.0,
        notes: 'Leaving from 5th Block near Forum Mall. AC on, smooth drive.',
        driverName: 'Priya Singh',
        driverRating: 4.9,
        vehicleInfo: 'Hyundai Creta • KA-05-MN-9876',
        createdAt: now,
      ),

      // 3. Active ride 2: Koramangala -> Whitefield (Vikram Malhotra - later time)
      RideModel(
        id: 'ride_103',
        driverId: 'u_3',
        vehicleId: 'v_3',
        source: 'Koramangala, Bengaluru',
        destination: 'Whitefield Tech Park',
        departureTime: futureToday2,
        availableSeats: 2,
        totalSeats: 4,
        pricePerSeat: 160.0,
        notes:
            'Pickup at Sony World signal. Direct via Intermediate Ring Road.',
        driverName: 'Vikram Malhotra',
        driverRating: 4.7,
        vehicleInfo: 'Maruti Ertiga • KA-03-XY-4321',
        createdAt: now,
      ),

      // 4. Active ride 3: Indiranagar -> Electronic City (Ananya Roy)
      RideModel(
        id: 'ride_104',
        driverId: 'u_4',
        vehicleId: 'v_1',
        source: 'Indiranagar 100ft Road',
        destination: 'Electronic City Phase 1',
        departureTime: futureToday1,
        availableSeats: 1,
        totalSeats: 4,
        pricePerSeat: 180.0,
        notes: 'Fast tag toll included. Drop at Infosys Gate 1.',
        driverName: 'Ananya Roy',
        driverRating: 4.8,
        vehicleInfo: 'Honda City • KA-01-AB-1234',
        createdAt: now,
      ),

      // 5. Active ride tomorrow: Koramangala -> Whitefield
      RideModel(
        id: 'ride_105',
        driverId: 'u_2',
        vehicleId: 'v_2',
        source: 'Koramangala, Bengaluru',
        destination: 'Whitefield Tech Park',
        departureTime: DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          9,
          30,
        ),
        availableSeats: 4,
        totalSeats: 4,
        pricePerSeat: 150.0,
        notes: 'Morning office commute. Friendly carpoolers welcome!',
        driverName: 'Priya Singh',
        driverRating: 4.9,
        vehicleInfo: 'Hyundai Creta • KA-05-MN-9876',
        createdAt: now,
      ),

      // 6. Fully booked ride (availableSeats: 0)
      RideModel(
        id: 'ride_106',
        driverId: 'u_5',
        vehicleId: 'v_1',
        source: 'HSR Layout Sector 2',
        destination: 'Manyata Tech Park',
        departureTime: futureToday1,
        availableSeats: 0,
        totalSeats: 4,
        pricePerSeat: 190.0,
        driverName: 'Arjun Das',
        driverRating: 4.6,
        vehicleInfo: 'Tata Nexon • KA-51-AB-9988',
        createdAt: now,
      ),

      // 7. Already departed ride
      RideModel(
        id: 'ride_107',
        driverId: 'u_6',
        vehicleId: 'v_3',
        source: 'Koramangala, Bengaluru',
        destination: 'Whitefield Tech Park',
        departureTime: departedToday,
        availableSeats: 2,
        totalSeats: 4,
        pricePerSeat: 120.0,
        driverName: 'Suresh Raina',
        driverRating: 4.5,
        vehicleInfo: 'Maruti Ertiga • KA-04-ER-1122',
        createdAt: now,
      ),

      // 8. Tomorrow ride on Indiranagar -> Electronic City
      RideModel(
        id: 'ride_108',
        driverId: 'u_4',
        vehicleId: 'v_1',
        source: 'Indiranagar 100ft Road',
        destination: 'Electronic City Phase 1',
        departureTime: DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          10,
          0,
        ),
        availableSeats: 3,
        totalSeats: 4,
        pricePerSeat: 175.0,
        driverName: 'Ananya Roy',
        driverRating: 4.8,
        vehicleInfo: 'Honda City • KA-01-AB-1234',
        createdAt: now,
      ),
    ];
  }

  /// Restores or overwrites the mock ride list (useful for test resets).
  void resetMockRides([List<RideModel>? customRides]) {
    _mockRides.clear();
    _mockRides.addAll(customRides ?? _generateDefaultMockRides());
  }

  /// Read-only snapshot of all stored rides.
  List<RideModel> get allRides => List.unmodifiable(_mockRides);

  bool _matchesLocation(String location, String query) {
    final loc = location.toLowerCase().trim();
    final q = query.toLowerCase().trim();
    if (loc.isEmpty || q.isEmpty) return false;
    if (loc == q || loc.contains(q) || q.contains(loc)) return true;

    // Check individual significant word tokens (>= 3 chars)
    final qTokens = q
        .split(RegExp(r'[, \-\/]+'))
        .map((t) => t.trim().toLowerCase())
        .where((t) => t.length >= 3);
    for (final token in qTokens) {
      if (loc.contains(token)) return true;
    }
    return false;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<RideSearchResult> searchRidesDetailed({
    required String source,
    required String destination,
    required DateTime date,
    String? currentUserId,
  }) async {
    final activeUserId = currentUserId ?? 'u_1';

    // Step 1: Check rides matching route and not driven by current user
    final routeMatches = _mockRides.where((r) {
      if (r.driverId == activeUserId) return false;
      return _matchesLocation(r.source, source) &&
          _matchesLocation(r.destination, destination);
    }).toList();

    if (routeMatches.isEmpty) {
      return const RideSearchResult(
        rides: [],
        emptyReason: RideSearchEmptyReason.noMatchingRoute,
      );
    }

    // Step 2: Check matching travel date
    final dateMatches = routeMatches.where((r) {
      return _isSameDate(r.departureTime, date);
    }).toList();

    if (dateMatches.isEmpty) {
      return const RideSearchResult(
        rides: [],
        emptyReason: RideSearchEmptyReason.noRidesOnSelectedDate,
      );
    }

    // Step 3: Check seat capacity
    final seatsAvailable = dateMatches
        .where((r) => r.availableSeats > 0)
        .toList();

    if (seatsAvailable.isEmpty) {
      return const RideSearchResult(
        rides: [],
        emptyReason: RideSearchEmptyReason.allRidesFullyBooked,
      );
    }

    // Step 4: Check if already departed
    final now = DateTime.now();
    final notDeparted = seatsAvailable
        .where((r) => r.departureTime.isAfter(now))
        .toList();

    if (notDeparted.isEmpty) {
      return const RideSearchResult(
        rides: [],
        emptyReason: RideSearchEmptyReason.allRidesDeparted,
      );
    }

    // Step 5: Sort by earliest departure time ascending
    notDeparted.sort((a, b) => a.departureTime.compareTo(b.departureTime));

    return RideSearchResult(
      rides: notDeparted,
      emptyReason: RideSearchEmptyReason.none,
    );
  }

  @override
  Future<List<RideModel>> searchRides({
    required String source,
    required String destination,
    required DateTime date,
    String? currentUserId,
  }) async {
    final result = await searchRidesDetailed(
      source: source,
      destination: destination,
      date: date,
      currentUserId: currentUserId,
    );
    return result.rides;
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

  @override
  Future<bool> updateAvailableSeats({
    required String rideId,
    required int seatsToDeduct,
  }) async {
    if (seatsToDeduct <= 0) return false;
    final index = _mockRides.indexWhere((r) => r.id == rideId);
    if (index == -1) return false;

    final currentRide = _mockRides[index];
    if (currentRide.availableSeats < seatsToDeduct) return false;

    final updatedSeats = currentRide.availableSeats - seatsToDeduct;
    _mockRides[index] = currentRide.copyWith(
      availableSeats: updatedSeats >= 0 ? updatedSeats : 0,
    );
    return true;
  }
}
