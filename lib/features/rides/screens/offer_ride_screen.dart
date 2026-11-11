import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/empty_state_view.dart';

/// Screen for creating and offering a new carpool ride (Placeholder).
class OfferRideScreen extends StatelessWidget {
  const OfferRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Offer a Ride'),
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
                    icon: Icons.add_road_rounded,
                    title: 'Publish Your Ride',
                    description: 'Share empty seats with fellow travelers, split travel costs, and reduce traffic congestion. Full ride creation will be enabled in the next milestone.',
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Step-by-step route planning, seat pricing, and departure scheduling are coming soon.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w500,
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
