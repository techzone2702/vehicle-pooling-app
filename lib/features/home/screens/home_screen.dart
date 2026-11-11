import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../booking/screens/booking_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../rides/screens/my_rides_screen.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/main_action_cards.dart';
import '../widgets/quick_search_card.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/upcoming_rides_section.dart';
import '../widgets/welcome_banner.dart';

/// The central Home Dashboard screen featuring a 4-tab bottom navigation bar,
/// dynamic top header, welcome banner, primary action cards, quick search shortcut,
/// upcoming rides feed, and recent activity timeline.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardTab(context),
          const MyRidesScreen(isTab: true),
          const BookingScreen(isTab: true),
          const ProfileScreen(isTab: true),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          backgroundColor: Theme.of(context).cardTheme.color,
          indicatorColor: AppColors.primaryLight,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(
                Icons.directions_car_rounded,
                color: AppColors.primary,
              ),
              label: 'My Rides',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined),
              selectedIcon: Icon(
                Icons.confirmation_number_rounded,
                color: AppColors.primary,
              ),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: AppColors.primary,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main Home Dashboard tab view.
  Widget _buildDashboardTab(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: User Greeting, Avatar, Notification Bell
                DashboardHeader(
                  userName: 'Rahul Sharma',
                  onProfileTap: () => _onTabSelected(3),
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Main Welcome Section
                const WelcomeBanner(),

                const SizedBox(height: AppConstants.largePadding),

                // Two Main Action Cards: Offer a Ride & Find a Ride
                const MainActionCards(),

                const SizedBox(height: AppConstants.largePadding),

                // Quick Search Section
                const QuickSearchCard(),

                const SizedBox(height: AppConstants.largePadding),

                // Upcoming Rides Section
                UpcomingRidesSection(
                  onViewAll: () => _onTabSelected(1),
                  hasRides: true,
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Recent Activity Section
                const RecentActivitySection(),

                const SizedBox(height: AppConstants.largePadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
