import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Recent Activity feed on the dashboard displaying recent trip events and confirmations.
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Container(
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
            children: [
              _buildActivityTile(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.primary,
                bgColor: AppColors.primaryLight,
                title: 'Ride request accepted',
                description:
                    'Driver Amit accepted your seat request for Koramangala',
                time: '15m ago',
                showDivider: true,
              ),
              _buildActivityTile(
                icon: Icons.directions_car_rounded,
                iconColor: AppColors.secondary,
                bgColor: AppColors.secondaryLight,
                title: 'New ride available',
                description:
                    '3 drivers traveling to Whitefield tomorrow morning',
                time: '1h ago',
                showDivider: true,
              ),
              _buildActivityTile(
                icon: Icons.confirmation_number_rounded,
                iconColor: AppColors.accent,
                bgColor: const Color(0xFFFFF3E0),
                title: 'Booking confirmation',
                description: 'Your trip to Electronic City has been confirmed',
                time: '3h ago',
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
    required String time,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 50, endIndent: 14),
      ],
    );
  }
}
