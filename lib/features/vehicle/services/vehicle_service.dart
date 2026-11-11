import '../../../models/vehicle_model.dart';

/// Vehicle management service contract for handling vehicle registration & queries.
abstract class VehicleService {
  Future<List<VehicleModel>> getVehiclesForUser(String userId);
  Future<VehicleModel> registerVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String vehicleId);
}

/// Placeholder implementation of [VehicleService].
class PlaceholderVehicleService implements VehicleService {
  /// Shared singleton instance for app-wide in-memory persistence.
  static final PlaceholderVehicleService instance = PlaceholderVehicleService();

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
      fuelType: 'Petrol',
      isVerified: true,
    ),
    const VehicleModel(
      id: 'v_2',
      ownerId: 'u_1',
      make: 'Hyundai',
      model: 'Creta',
      year: 2023,
      licensePlate: 'KA-05-MN-9876',
      color: 'Polar White',
      seatsCapacity: 5,
      fuelType: 'Diesel',
      isVerified: true,
    ),
    const VehicleModel(
      id: 'v_3',
      ownerId: 'u_1',
      make: 'Maruti Suzuki',
      model: 'Ertiga',
      year: 2021,
      licensePlate: 'KA-03-XY-4321',
      color: 'Magma Grey',
      seatsCapacity: 7,
      fuelType: 'CNG',
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
