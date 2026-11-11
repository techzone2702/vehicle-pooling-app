import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state_view.dart';

/// Section displaying upcoming scheduled rides with route, timing, seat capacity, and pricing.
class UpcomingRidesSection extends StatelessWidget {
  final VoidCallback onViewAll;
  final bool hasRides;

  const UpcomingRidesSection({
    super.key,
    required this.onViewAll,
    this.hasRides = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Rides',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),

        if (!hasRides)
          const EmptyStateView(
            icon: Icons.directions_car_outlined,
            title: 'No Upcoming Rides',
            description: 'You have no rides scheduled for today or tomorrow.',
          )
        else ...[
          // Sample Ride 1
          _buildRideCard(
            context,
            source: 'Koramangala 4th Block',
            destination: 'Electronic City Phase 1',
            date: 'Today, 12 Nov',
            time: '05:30 PM',
            driverName: 'Amit Patel',
            driverRating: 4.9,
            vehicleName: 'Honda City',
            availableSeats: 3,
            price: 120.0,
            status: 'Confirmed',
            statusColor: AppColors.primary,
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Sample Ride 2
          _buildRideCard(
            context,
            source: 'Indiranagar 100ft Road',
            destination: 'Whitefield Tech Park',
            date: 'Tomorrow, 13 Nov',
            time: '08:45 AM',
            driverName: 'Priya Nair',
            driverRating: 4.8,
            vehicleName: 'Hyundai i20',
            availableSeats: 2,
            price: 150.0,
            status: 'Scheduled',
            statusColor: AppColors.secondary,
          ),
        ],
      ],
    );
  }

  Widget _buildRideCard(
    BuildContext context, {
    required String source,
    required String destination,
    required String date,
    required String time,
    required String driverName,
    required double driverRating,
    required String vehicleName,
    required int availableSeats,
    required double price,
    required String status,
    required Color statusColor,
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
          // Header: Date & Time + Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$date • $time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Route Points
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
                  source,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
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
              child: VerticalDivider(thickness: 1.5, color: AppColors.border),
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
                  destination,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Driver info, Seats, and Price
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  driverName.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$vehicleName • ★ $driverRating',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$availableSeats seats left',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
