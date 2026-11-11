import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';

/// The two primary action cards on the dashboard: "Offer a Ride" and "Find a Ride".
class MainActionCards extends StatelessWidget {
  const MainActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width is generous (tablet/web), render side by side; otherwise vertically stacked
        final isWide = constraints.maxWidth > 500;

        final card1 = _buildActionCard(
          context,
          title: 'Offer a Ride',
          description: 'Have empty seats? Share your journey with others.',
          buttonText: 'Offer a Ride',
          icon: Icons.directions_car_rounded,
          iconColor: AppColors.primary,
          buttonBg: AppColors.primary,
          cardBg: Colors.white,
          accentBorder: AppColors.primary.withValues(alpha: 0.25),
          badgeText: 'Driver',
          badgeBg: AppColors.primaryLight,
          badgeColor: AppColors.primaryDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.offerRide),
        );

        final card2 = _buildActionCard(
          context,
          title: 'Find a Ride',
          description: 'Going somewhere? Find people travelling your way.',
          buttonText: 'Find a Ride',
          icon: Icons.explore_rounded,
          iconColor: AppColors.secondary,
          buttonBg: AppColors.secondary,
          cardBg: Colors.white,
          accentBorder: AppColors.secondary.withValues(alpha: 0.25),
          badgeText: 'Passenger',
          badgeBg: AppColors.secondaryLight,
          badgeColor: AppColors.secondary,
          onTap: () => Navigator.pushNamed(context, AppRoutes.findRide),
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: card1),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(child: card2),
            ],
          );
        }

        return Column(
          children: [
            card1,
            const SizedBox(height: AppConstants.defaultPadding),
            card2,
          ],
        );
      },
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
    required Color iconColor,
    required Color buttonBg,
    required Color cardBg,
    required Color accentBorder,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: accentBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBg,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
