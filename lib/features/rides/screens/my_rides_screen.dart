import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

/// Screen displaying the user's offered and joined rides.
class MyRidesScreen extends StatelessWidget {
  final bool isTab;

  const MyRidesScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final content = DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).cardTheme.color,
            child: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Offered Rides'),
                Tab(text: 'Joined Rides'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOfferedRidesList(context),
                _buildJoinedRidesList(context),
              ],
            ),
          ),
        ],
      ),
    );

    if (isTab) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Rides'),
          automaticallyImplyLeading: false,
        ),
        body: content,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Rides')),
      body: content,
    );
  }

  Widget _buildOfferedRidesList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        _buildRideSummaryCard(
          context,
          from: 'Koramangala, Bengaluru',
          to: 'Electronic City Phase 1',
          time: 'Today, 05:30 PM',
          seatsText: '3 seats left of 4',
          price: 120.0,
          status: 'Active',
          statusColor: AppColors.primary,
          statusBg: AppColors.primaryLight,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        _buildRideSummaryCard(
          context,
          from: 'Indiranagar 100ft Road',
          to: 'Whitefield Tech Park',
          time: 'Tomorrow, 08:45 AM',
          seatsText: '2 seats left of 3',
          price: 150.0,
          status: 'Scheduled',
          statusColor: AppColors.secondary,
          statusBg: AppColors.secondaryLight,
        ),
      ],
    );
  }

  Widget _buildJoinedRidesList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        _buildRideSummaryCard(
          context,
          from: 'HSR Layout Sector 2',
          to: 'Embassy Manyata Tech Park',
          time: '14 Nov, 09:00 AM',
          seatsText: '1 seat booked',
          price: 180.0,
          status: 'Confirmed',
          statusColor: AppColors.success,
          statusBg: const Color(0xFFE8F5E9),
        ),
      ],
    );
  }

  Widget _buildRideSummaryCard(
    BuildContext context, {
    required String from,
    required String to,
    required String time,
    required String seatsText,
    required double price,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.trip_origin_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    from,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 7),
              child: SizedBox(
                height: 14,
                child: VerticalDivider(thickness: 1.5, color: AppColors.border),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    to,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  seatsText,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  Formatters.formatCurrency(price),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
