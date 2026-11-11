import '../../../models/vehicle_model.dart';

/// Vehicle management service contract for handling vehicle registration & queries.
abstract class VehicleService {
  Future<List<VehicleModel>> getVehiclesForUser(String userId);
  Future<VehicleModel> registerVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String vehicleId);
}

/// Placeholder implementation of [VehicleService].
class PlaceholderVehicleService implements VehicleService {
  final List<VehicleModel> _vehicles = [
    const VehicleModel(
      id: 'v_1',
      ownerId: 'u_1',
      make: 'Honda',
      model: 'City',
      year: 2022,
      licensePlate: 'KA-01-AB-1234',
      color: 'Silver',
      seatsCapacity: 4,
      isVerified: true,
    ),
  ];

  @override
  Future<List<VehicleModel>> getVehiclesForUser(String userId) async {
    return _vehicles;
  }

  @override
  Future<VehicleModel> registerVehicle(VehicleModel vehicle) async {
    _vehicles.add(vehicle);
    return vehicle;
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    _vehicles.removeWhere((v) => v.id == vehicleId);
  }
}
