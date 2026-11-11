/// Service contract for handling in-app and push notifications.
abstract class NotificationService {
  Future<List<Map<String, dynamic>>> getNotifications(String userId);
  Future<void> markAsRead(String notificationId);
}

/// Placeholder implementation of [NotificationService].
class PlaceholderNotificationService implements NotificationService {
  @override
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    return [
      {
        'id': 'notif_1',
        'title': 'New Join Request',
        'body': 'User B requested to join your ride to Tech Park',
        'time': '5m ago',
        'is_read': false,
      },
      {
        'id': 'notif_2',
        'title': 'Ride Confirmed',
        'body': 'Your booking for 06:30 PM has been accepted',
        'time': '1h ago',
        'is_read': true,
      },
    ];
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // Logic ready for persistence
  }
}
