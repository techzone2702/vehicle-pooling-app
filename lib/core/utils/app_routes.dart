import 'package:flutter/material.dart';

import '../../features/authentication/screens/login_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/maps/screens/map_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/rides/screens/rides_screen.dart';
import '../../features/vehicle/screens/vehicle_screen.dart';

/// Centralized route definitions and generator for the Vehicle Pooling App.
class AppRoutes {
  AppRoutes._();

  // Route Name Constants
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String vehicles = '/vehicles';
  static const String rides = '/rides';
  static const String booking = '/booking';
  static const String map = '/map';
  static const String notifications = '/notifications';
  static const String chat = '/chat';

  /// Generates routes dynamically based on [RouteSettings]
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case vehicles:
        return MaterialPageRoute(
          builder: (_) => const VehicleScreen(),
          settings: settings,
        );
      case rides:
        return MaterialPageRoute(
          builder: (_) => const RidesScreen(),
          settings: settings,
        );
      case booking:
        return MaterialPageRoute(
          builder: (_) => const BookingScreen(),
          settings: settings,
        );
      case map:
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
          settings: settings,
        );
      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case chat:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
