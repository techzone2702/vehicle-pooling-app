import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';

/// Top Header component displaying user greeting, profile avatar, and notification bell.
class DashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    this.userName = 'Rahul Sharma',
    this.onProfileTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Avatar with tap action
        GestureDetector(
          onTap:
              onProfileTap ??
              () => Navigator.pushNamed(context, AppRoutes.profile),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                'RS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),

        // Greeting & User Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Notification Bell Icon with Badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 26),
              color: AppColors.textPrimary,
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
