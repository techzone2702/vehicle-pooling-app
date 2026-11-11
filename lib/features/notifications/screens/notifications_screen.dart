import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Screen displaying notification alerts for ride updates and joining requests.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: const [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person_add, color: AppColors.primary),
              ),
              title: Text('New Ride Request'),
              subtitle: Text('User B requested 1 seat for ride to Tech Park'),
              trailing: Text(
                '5m ago',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondaryLight,
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.secondary,
                ),
              ),
              title: Text('Booking Confirmed'),
              subtitle: Text('Driver accepted your ride request'),
              trailing: Text(
                '1h ago',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
