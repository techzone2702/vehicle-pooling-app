import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_pooling_app/core/constants/app_constants.dart';
import 'package:vehicle_pooling_app/features/home/screens/home_screen.dart';
import 'package:vehicle_pooling_app/main.dart';

void main() {
  testWidgets(
    'WelcomeScreen renders on initial launch with brand mark, illustration, and action buttons',
    (WidgetTester tester) async {
      await tester.pumpWidget(const VehiclePoolingApp());
      await tester.pumpAndSettle();

      // Verify Welcome screen branding and elements
      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(find.text('Smart Commute,\nShared Journeys'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    },
  );

  testWidgets(
    'Navigates from WelcomeScreen to RegisterScreen and verifies required field validations',
    (WidgetTester tester) async {
      await tester.pumpWidget(const VehiclePoolingApp());
      await tester.pumpAndSettle();

      // Tap 'Get Started' to navigate to RegisterScreen
      final getStartedFinder = find.text('Get Started');
      await tester.ensureVisible(getStartedFinder);
      await tester.tap(getStartedFinder);
      await tester.pumpAndSettle();

      // Verify RegisterScreen elements
      expect(find.text('Join Vehicle Pooling'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);

      // Attempt submit without filling form
      final createAccountFinder = find.widgetWithText(
        ElevatedButton,
        'Create Account',
      );
      await tester.ensureVisible(createAccountFinder);
      await tester.tap(createAccountFinder);
      await tester.pumpAndSettle();

      // Verify validation error messages
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please enter your mobile number'), findsOneWidget);
      expect(find.text('Please create a password'), findsOneWidget);
      expect(
        find.text('You must accept the terms and conditions to proceed'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Navigates between Login and Registration screens seamlessly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VehiclePoolingApp());
    await tester.pumpAndSettle();

    // Tap 'Sign In' from Welcome Screen
    final signInFinder = find.text('Sign In');
    await tester.ensureVisible(signInFinder);
    await tester.tap(signInFinder);
    await tester.pumpAndSettle();

    // Verify Login Screen
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Tap 'Sign Up' to switch to Register Screen
    final signUpFinder = find.text('Sign Up');
    await tester.ensureVisible(signUpFinder);
    await tester.tap(signUpFinder);
    await tester.pumpAndSettle();

    // Verify Register Screen
    expect(find.text('Join Vehicle Pooling'), findsOneWidget);

    // Tap 'Log In' to switch back to Login Screen
    final logInFinder = find.text('Log In');
    await tester.ensureVisible(logInFinder);
    await tester.tap(logInFinder);
    await tester.pumpAndSettle();

    // Verify back on Login Screen
    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets(
    'Home Dashboard renders all required sections: header, banner, action cards, search, upcoming rides, activity, and bottom nav',
    (WidgetTester tester) async {
      // Build MaterialApp displaying HomeScreen directly
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // A. Top Header
      expect(find.text('Rahul Sharma'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

      // B. Welcome Section
      expect(find.text('Your Journey, Shared.'), findsOneWidget);
      expect(
        find.text('Travel together, save more and make every journey count.'),
        findsOneWidget,
      );

      // C. Two Main Action Cards
      expect(find.text('Offer a Ride'), findsWidgets);
      expect(
        find.text('Have empty seats? Share your journey with others.'),
        findsOneWidget,
      );
      expect(find.text('Find a Ride'), findsWidgets);
      expect(
        find.text('Going somewhere? Find people travelling your way.'),
        findsOneWidget,
      );

      // D. Quick Search Section
      expect(find.text('Quick Ride Search'), findsOneWidget);
      expect(find.text('Search Rides'), findsOneWidget);

      // E. Upcoming Rides Section
      expect(find.text('Upcoming Rides'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.text('Koramangala 4th Block'), findsOneWidget);
      expect(find.text('Electronic City Phase 1'), findsOneWidget);

      // F. Recent Activity Section
      expect(find.text('Recent Activity'), findsOneWidget);
      expect(find.text('Ride request accepted'), findsOneWidget);
      expect(find.text('New ride available'), findsOneWidget);
      expect(find.text('Booking confirmation'), findsOneWidget);

      // Bottom Navigation Bar tabs
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Rides'), findsOneWidget);
      expect(find.text('Bookings'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets(
    'Home Dashboard bottom navigation switches between tabs correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Tap 'My Rides' in bottom nav
      await tester.tap(find.text('My Rides'));
      await tester.pumpAndSettle();
      expect(find.text('Offered Rides'), findsOneWidget);
      expect(find.text('Joined Rides'), findsOneWidget);

      // Tap 'Bookings' in bottom nav
      await tester.tap(find.text('Bookings'));
      await tester.pumpAndSettle();
      expect(find.text('My Bookings'), findsOneWidget);

      // Tap 'Profile' in bottom nav
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Identity Verified'), findsOneWidget);

      // Tap 'Home' to return to Dashboard
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Your Journey, Shared.'), findsOneWidget);
    },
  );
}
