/// Centralized API service contract prepared for future REST API client integration.
abstract class ApiService {
  /// Base API URL (configurable for development, staging, and production)
  String get baseUrl;

  /// Perform a GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters});

  /// Perform a POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body});

  /// Perform a PUT / PATCH request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body});

  /// Perform a DELETE request
  Future<dynamic> delete(String endpoint);
}

/// Placeholder implementation of [ApiService] for use until a live backend is connected.
class PlaceholderApiService implements ApiService {
  @override
  final String baseUrl;

  PlaceholderApiService({
    this.baseUrl = 'https://api.vehiclepooling.example.com/v1',
  });

  @override
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    // Ready for future http/dio integration
    return <String, dynamic>{};
  }

  @override
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    return <String, dynamic>{};
  }

  @override
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    return <String, dynamic>{};
  }

  @override
  Future<dynamic> delete(String endpoint) async {
    return <String, dynamic>{};
  }
}
