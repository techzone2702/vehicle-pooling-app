import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/empty_state_view.dart';

/// Screen for searching and discovering available rides (Placeholder).
class FindRideScreen extends StatelessWidget {
  const FindRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Find a Ride'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyStateView(
                    icon: Icons.search_rounded,
                    title: 'Search & Explore Rides',
                    description: 'Find verified drivers heading your way. Filter by departure time, seat availability, and price. Live search will be integrated in the next milestone.',
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: AppColors.secondary,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Real-time ride matching with interactive pickup point maps will be available soon.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
