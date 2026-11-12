import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../models/ride_model.dart';
import '../../booking/services/booking_service.dart';

/// Reusable card displaying an available ride result matching the search criteria.
/// Features driver info, star rating, origin/destination timeline, vehicle specs,
/// departure time, price, seat count, and a "View Details" bottom sheet trigger.
class RideResultCard extends StatelessWidget {
  final RideModel ride;
  final VoidCallback? onViewDetails;

  const RideResultCard({super.key, required this.ride, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final driverName = ride.driverName ?? 'Verified Driver';
    final driverRating = ride.driverRating ?? 4.8;
    final vehicleInfo = ride.vehicleInfo ?? 'Sedan • Verified';

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Driver Details + Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xFFFFB300),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            driverRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Verified Driver',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatCurrency(ride.pricePerSeat),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      'per passenger',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 22),

            // Route Timeline Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.trip_origin_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    Container(
                      width: 1.5,
                      height: 24,
                      color: AppColors.border,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.source,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        ride.destination,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Departure Time & Vehicle Information Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '${Formatters.formatDate(ride.departureTime)}, ${Formatters.formatTime(ride.departureTime)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.directions_car_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      vehicleInfo,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bottom Bar: Seat Indicator + View Details Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ride.availableSeats > 1
                        ? AppColors.primaryLight
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.airline_seat_recline_normal_rounded,
                        size: 14,
                        color: ride.availableSeats > 1
                            ? AppColors.primary
                            : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${ride.availableSeats} ${ride.availableSeats == 1 ? 'seat' : 'seats'} left',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ride.availableSeats > 1
                              ? AppColors.primaryDark
                              : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onViewDetails ?? () => _showRideDetails(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.info_outline_rounded, size: 14),
                  label: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRideDetails(BuildContext context) {
    const currentUserId = 'u_1';
    final isOwnRide = ride.driverId == currentUserId;
    final isFullyBooked = ride.availableSeats <= 0;
    final hasPending = PlaceholderBookingService.instance
        .hasPendingRequestForRideSync(
          rideId: ride.id,
          passengerId: currentUserId,
        );

    int requestedSeats = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final dynamicTotalFare = ride.pricePerSeat * requestedSeats;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.largePadding,
                vertical: AppConstants.largePadding,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Title
                      Text(
                        'Ride Details',
                        style: Theme.of(bottomSheetContext).textTheme.titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Review journey route, vehicle specifications, and driver details before joining.',
                        style: Theme.of(bottomSheetContext).textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),

                      const SizedBox(height: AppConstants.defaultPadding),

                      // Route Card
                      Container(
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding,
                        ),
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
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pickup Point',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        ride.source,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Drop-off Destination',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        ride.destination,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.defaultPadding),

                      // Grid of specifications
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailTile(
                              icon: Icons.calendar_today_rounded,
                              label: 'Departure Date',
                              value: Formatters.formatDate(ride.departureTime),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDetailTile(
                              icon: Icons.access_time_rounded,
                              label: 'Departure Time',
                              value: Formatters.formatTime(ride.departureTime),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailTile(
                              icon: Icons.airline_seat_recline_normal_rounded,
                              label: 'Available Seats',
                              value:
                                  '${ride.availableSeats} of ${ride.totalSeats} seats left',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDetailTile(
                              icon: Icons.payments_outlined,
                              label: 'Fare Per Seat',
                              value: Formatters.formatCurrency(
                                ride.pricePerSeat,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      _buildDetailTile(
                        icon: Icons.directions_car_rounded,
                        label: 'Vehicle Specifications',
                        value:
                            ride.vehicleInfo ?? 'Registered & Verified Vehicle',
                      ),

                      if (ride.notes != null &&
                          ride.notes!.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _buildDetailTile(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Driver Instructions',
                          value: ride.notes!.trim(),
                        ),
                      ],

                      const SizedBox(height: AppConstants.defaultPadding),

                      // Booking / Join Request Section
                      if (isOwnRide) ...[
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            border: Border.all(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.person_pin_circle_outlined,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'You offered this ride. You cannot request to join your own ride.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (isFullyBooked) ...[
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.block_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'This ride is fully booked. No seats are currently available.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (hasPending) ...[
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.hourglass_top_rounded,
                                color: AppColors.warning,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'You already have a pending join request for this ride. Track its status under Bookings.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Interactive Seat Selection and Dynamic Fare
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(
                              alpha: 0.4,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Required Seats',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Stepper Minus Button
                                  InkWell(
                                    onTap: requestedSeats > 1
                                        ? () {
                                            setModalState(() {
                                              requestedSeats--;
                                            });
                                          }
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: requestedSeats > 1
                                            ? Colors.white
                                            : AppColors.border.withValues(
                                                alpha: 0.3,
                                              ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: requestedSeats > 1
                                              ? AppColors.primary
                                              : AppColors.border,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: requestedSeats > 1
                                            ? AppColors.primary
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '$requestedSeats',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Stepper Plus Button
                                  InkWell(
                                    onTap: requestedSeats < ride.availableSeats
                                        ? () {
                                            setModalState(() {
                                              requestedSeats++;
                                            });
                                          }
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color:
                                            requestedSeats < ride.availableSeats
                                            ? Colors.white
                                            : AppColors.border.withValues(
                                                alpha: 0.3,
                                              ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              requestedSeats <
                                                  ride.availableSeats
                                              ? AppColors.primary
                                              : AppColors.border,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 18,
                                        color:
                                            requestedSeats < ride.availableSeats
                                            ? AppColors.primary
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Max: ${ride.availableSeats} seat${ride.availableSeats > 1 ? "s" : ""}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Fare Calculation',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        '$requestedSeats seat${requestedSeats > 1 ? "s" : ""} × ₹${ride.pricePerSeat.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatters.formatCurrency(dynamicTotalFare),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        CustomButton(
                          text: 'Send Join Request',
                          onPressed: () {
                            try {
                              PlaceholderBookingService.instance
                                  .createBookingRequest(
                                    rideId: ride.id,
                                    passengerId: currentUserId,
                                    passengerName: 'Rahul Sharma',
                                    passengerPhone: '+91 98765 43210',
                                    seats: requestedSeats,
                                    totalPrice: dynamicTotalFare,
                                    source: ride.source,
                                    destination: ride.destination,
                                    departureTime: ride.departureTime,
                                  );

                              Navigator.pop(bottomSheetContext);

                              _showRequestSentDialog(
                                context,
                                requestedSeats: requestedSeats,
                                totalFare: dynamicTotalFare,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll('Exception: ', ''),
                                  ),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          },
                        ),
                      ],

                      const SizedBox(height: AppConstants.smallPadding),

                      CustomButton(
                        text: 'Close',
                        isOutlined: true,
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRequestSentDialog(
    BuildContext context, {
    required int requestedSeats,
    required double totalFare,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 26,
              ),
              SizedBox(width: 10),
              Text(
                'Request Sent!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your join request for $requestedSeats seat${requestedSeats > 1 ? "s" : ""} (${Formatters.formatCurrency(totalFare)}) has been sent to ${ride.driverName ?? "the driver"}.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'You will receive updates once the driver accepts or rejects your request. You can monitor request statuses anytime in your Bookings tab.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Done'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamed(context, AppRoutes.booking);
              },
              child: const Text('View in My Bookings'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
