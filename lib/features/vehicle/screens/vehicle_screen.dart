import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Screen for managing registered vehicles.
class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Vehicles')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add vehicle flow ready to implement'),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Vehicle', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: const [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.directions_car, color: AppColors.primary),
              ),
              title: Text('Honda City (2022)'),
              subtitle: Text('License: KA-01-AB-1234 • 4 Seats'),
              trailing: Chip(
                label: Text('Verified', style: TextStyle(fontSize: 12)),
                backgroundColor: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
