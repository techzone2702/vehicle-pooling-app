import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/empty_state_view.dart';

/// Screen for displaying route map and GPS tracking (prepared for Google Maps).
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route & Map')),
      body: Container(
        color: AppColors.backgroundLight,
        child: const EmptyStateView(
          icon: Icons.map_outlined,
          title: 'Google Maps Integration',
          description: 'Map visualization and route polylines will appear here once Google Maps SDK is initialized.',
        ),
      ),
    );
  }
}
