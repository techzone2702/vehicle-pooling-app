/// Map and route service contract prepared for Google Maps Platform integration.
abstract class MapService {
  Future<Map<String, dynamic>> getRouteCoordinates({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
  Future<double> calculateDistanceKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
}

/// Placeholder implementation of [MapService].
class PlaceholderMapService implements MapService {
  @override
  Future<Map<String, dynamic>> getRouteCoordinates({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    // Ready for future Google Maps Directions API integration
    return <String, dynamic>{'points': <dynamic>[]};
  }

  @override
  Future<double> calculateDistanceKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    return 15.4; // Sample estimated distance
  }
}
