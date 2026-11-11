import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';
import '../widgets/quick_action_card.dart';

/// Central placeholder home screen presenting the vehicle pooling concept and navigation hub.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Carpool & Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.rides),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                          ),
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('Find a Ride'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.vehicles),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text('Offer Ride'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            Text(
              'Feature Modules',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            // Navigation Grid/List of Features
            QuickActionCard(
              icon: Icons.directions_car,
              iconColor: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              title: 'Rides & Search',
              subtitle: 'Browse available rides or publish a new journey',
              onTap: () => Navigator.pushNamed(context, AppRoutes.rides),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            QuickActionCard(
              icon: Icons.bookmark_border,
              iconColor: AppColors.secondary,
              backgroundColor: AppColors.secondaryLight,
              title: 'My Bookings',
              subtitle: 'Check pending join requests and confirmed trips',
              onTap: () => Navigator.pushNamed(context, AppRoutes.booking),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            QuickActionCard(
              icon: Icons.car_rental,
              iconColor: AppColors.accent,
              backgroundColor: const Color(0xFFFFF3E0),
              title: 'Vehicle Management',
              subtitle: 'Register and manage your carpooling vehicles',
              onTap: () => Navigator.pushNamed(context, AppRoutes.vehicles),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            QuickActionCard(
              icon: Icons.map_outlined,
              iconColor: Colors.deepPurple,
              backgroundColor: const Color(0xFFEDE7F6),
              title: 'Maps & Route Tracking',
              subtitle: 'Google Maps route planning & GPS tracking',
              onTap: () => Navigator.pushNamed(context, AppRoutes.map),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            QuickActionCard(
              icon: Icons.chat_bubble_outline,
              iconColor: Colors.teal,
              backgroundColor: const Color(0xFFE0F2F1),
              title: 'Ride Chat',
              subtitle: 'Coordinate pickup points with driver and passengers',
              onTap: () => Navigator.pushNamed(context, AppRoutes.chat),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            QuickActionCard(
              icon: Icons.lock_outline,
              iconColor: Colors.blueGrey,
              backgroundColor: const Color(0xFFECEFF1),
              title: 'Account Authentication',
              subtitle: 'User sign in and registration',
              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
