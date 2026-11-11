import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../models/ride_model.dart';
import '../../../models/vehicle_model.dart';
import '../../vehicle/services/vehicle_service.dart';
import '../services/ride_service.dart';

/// Screen for creating and publishing a ride offer with comprehensive validation,
/// seat stepper, price calculation, vehicle selection, and in-memory mock submission.
class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({super.key});

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _availableSeats = 3;
  VehicleModel? _selectedVehicle;
  List<VehicleModel> _vehicles = [];

  bool _isSubmitting = false;
  String? _dateTimeError;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    // Default to tomorrow at 08:30 AM for user convenience
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    _selectedTime = const TimeOfDay(hour: 8, minute: 30);
  }

  Future<void> _loadVehicles() async {
    final vehicles = await PlaceholderVehicleService.instance
        .getVehiclesForUser('u_1');
    if (mounted) {
      setState(() {
        _vehicles = vehicles;
        if (vehicles.isNotEmpty) {
          _selectedVehicle = vehicles.first;
        }
      });
    }
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _validateDateTime();
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _validateDateTime();
      });
    }
  }

  bool _validateDateTime() {
    if (_selectedDate == null || _selectedTime == null) {
      setState(() {
        _dateTimeError = 'Please select both departure date and time';
      });
      return false;
    }

    final combined = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (combined.isBefore(DateTime.now())) {
      setState(() {
        _dateTimeError = 'Departure date and time cannot be in the past';
      });
      return false;
    }

    setState(() {
      _dateTimeError = null;
    });
    return true;
  }

  void _incrementSeats() {
    final maxAllowed = _selectedVehicle != null
        ? (_selectedVehicle!.seatsCapacity - 1).clamp(1, 7)
        : 7;
    if (_availableSeats < maxAllowed) {
      setState(() {
        _availableSeats++;
      });
    }
  }

  void _decrementSeats() {
    if (_availableSeats > 1) {
      setState(() {
        _availableSeats--;
      });
    }
  }

  Future<void> _handlePublishRide() async {
    final isDateTimeValid = _validateDateTime();
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || !isDateTimeValid || _selectedVehicle == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    final departure = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final price = double.parse(_priceController.text.trim());

    final newRide = RideModel(
      id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
      driverId: 'u_1',
      vehicleId: _selectedVehicle!.id,
      source: _sourceController.text.trim(),
      destination: _destinationController.text.trim(),
      departureTime: departure,
      availableSeats: _availableSeats,
      totalSeats: _selectedVehicle!.seatsCapacity,
      pricePerSeat: price,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      status: RideStatus.scheduled,
      createdAt: DateTime.now(),
    );

    // Save into shared in-memory ride repository
    await PlaceholderRideService.instance.createRide(newRide);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSuccessDialog(newRide);
  }

  void _showSuccessDialog(RideModel ride) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadius * 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.all(AppConstants.largePadding),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'Ride Offered Successfully!',
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your ride has been scheduled and added to your in-memory list.',
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.trip_origin_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ride.source,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: SizedBox(
                        height: 12,
                        child: VerticalDivider(
                          thickness: 1.5,
                          color: AppColors.border,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ride.destination,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatDate(ride.departureTime),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          Formatters.formatTime(ride.departureTime),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ride.availableSeats} seats',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          Formatters.formatCurrency(ride.pricePerSeat),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),
              CustomButton(
                text: 'View My Rides',
                onPressed: () {
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.pushReplacementNamed(context, AppRoutes.myRides);
                },
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Back to Dashboard',
                isOutlined: true,
                onPressed: () {
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.pop(context); // Back to previous/home screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Offer a Ride'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionCard(
                      title: 'Journey Details',
                      icon: Icons.alt_route_rounded,
                      children: [
                        CustomTextField(
                          controller: _sourceController,
                          label: 'Leaving From',
                          hintText:
                              'Pickup address, metro station, or landmark',
                          prefixIcon: Icons.trip_origin_rounded,
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return 'Please enter departure location';
                            }
                            if (trimmed.length < 3) {
                              return 'Location must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        CustomTextField(
                          controller: _destinationController,
                          label: 'Going To',
                          hintText: 'Destination address, office, or landmark',
                          prefixIcon: Icons.location_on_rounded,
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return 'Please enter destination';
                            }
                            if (trimmed.length < 3) {
                              return 'Location must be at least 3 characters';
                            }
                            if (trimmed.toLowerCase() ==
                                _sourceController.text.trim().toLowerCase()) {
                              return 'Source and destination cannot be identical';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),

                        // Departure Date and Time row
                        Row(
                          children: [
                            // Date Selector
                            Expanded(
                              child: _buildSelectorTile(
                                label: 'Departure Date',
                                value: _selectedDate != null
                                    ? Formatters.formatDate(_selectedDate!)
                                    : 'Select Date',
                                icon: Icons.calendar_today_rounded,
                                onTap: _pickDate,
                              ),
                            ),
                            const SizedBox(width: AppConstants.defaultPadding),
                            // Time Selector
                            Expanded(
                              child: _buildSelectorTile(
                                label: 'Departure Time',
                                value: _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : 'Select Time',
                                icon: Icons.access_time_rounded,
                                onTap: _pickTime,
                              ),
                            ),
                          ],
                        ),
                        if (_dateTimeError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _dateTimeError!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: AppConstants.largePadding),

                    _buildSectionCard(
                      title: 'Ride Information',
                      icon: Icons.airline_seat_recline_normal_rounded,
                      children: [
                        // Available Seats Stepper
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Seats',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                    ),
                                    color: _availableSeats > 1
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                    onPressed: _decrementSeats,
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        '$_availableSeats',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _availableSeats == 1
                                            ? 'Passenger Seat'
                                            : 'Passenger Seats',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline_rounded,
                                    ),
                                    color: _availableSeats < 7
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                    onPressed: _incrementSeats,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.defaultPadding),

                        // Price Per Passenger Field
                        CustomTextField(
                          controller: _priceController,
                          label: 'Price Per Passenger (₹)',
                          hintText: 'e.g. 150',
                          prefixIcon: Icons.currency_rupee_rounded,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return 'Please enter price per seat';
                            }
                            final parsed = double.tryParse(trimmed);
                            if (parsed == null || parsed <= 0) {
                              return 'Price must be a valid positive amount';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.largePadding),

                    _buildSectionCard(
                      title: 'Vehicle & Additional Instructions',
                      icon: Icons.directions_car_rounded,
                      children: [
                        // Vehicle Selection Dropdown
                        Text(
                          'Select Vehicle',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<VehicleModel>(
                              value: _selectedVehicle,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              items: _vehicles.map((v) {
                                return DropdownMenuItem<VehicleModel>(
                                  value: v,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.directions_car_filled_rounded,
                                        size: 20,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '${v.displayName} • ${v.licensePlate}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (vehicle) {
                                setState(() {
                                  _selectedVehicle = vehicle;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: AppConstants.defaultPadding),

                        // Additional Instructions Field
                        CustomTextField(
                          controller: _notesController,
                          label: 'Additional Instructions (Optional)',
                          hintText: 'e.g. Pickup near gate 2, AC will be on, small luggage only',
                          prefixIcon: Icons.notes_rounded,
                          maxLines: 3,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.largePadding * 1.5),

                    // Publish Ride Button
                    CustomButton(
                      text: 'Publish Ride',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: _isSubmitting,
                      onPressed: _handlePublishRide,
                    ),

                    const SizedBox(height: AppConstants.largePadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSelectorTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
