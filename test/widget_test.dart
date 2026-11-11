import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_pooling_app/core/constants/app_constants.dart';
import 'package:vehicle_pooling_app/features/home/screens/home_screen.dart';
import 'package:vehicle_pooling_app/features/rides/screens/offer_ride_screen.dart';
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

  testWidgets('OfferRideScreen renders form sections, inputs, and controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OfferRideScreen()));
    await tester.pumpAndSettle();

    // Verify Form Sections
    expect(find.text('Journey Details'), findsOneWidget);
    expect(find.text('Ride Information'), findsOneWidget);
    expect(find.text('Vehicle & Additional Instructions'), findsOneWidget);

    // Verify Form Fields
    expect(find.text('Leaving From'), findsOneWidget);
    expect(find.text('Going To'), findsOneWidget);
    expect(find.text('Departure Date'), findsOneWidget);
    expect(find.text('Departure Time'), findsOneWidget);
    expect(find.text('Available Seats'), findsOneWidget);
    expect(find.text('Price Per Passenger (₹)'), findsOneWidget);
    expect(find.text('Select Vehicle'), findsOneWidget);
    expect(find.text('Additional Instructions (Optional)'), findsOneWidget);
    expect(find.text('Publish Ride'), findsOneWidget);
  });

  testWidgets(
    'OfferRideScreen validates empty fields and identical source/destination',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OfferRideScreen()));
      await tester.pumpAndSettle();

      // Tap Publish Ride with empty fields
      final publishFinder = find.widgetWithText(ElevatedButton, 'Publish Ride');
      await tester.ensureVisible(publishFinder);
      await tester.tap(publishFinder);
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter departure location'), findsOneWidget);
      expect(find.text('Please enter destination'), findsOneWidget);
      expect(find.text('Please enter price per seat'), findsOneWidget);

      // Enter identical locations
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Koramangala');
      await tester.enterText(textFields.at(1), 'Koramangala');

      await tester.ensureVisible(publishFinder);
      await tester.tap(publishFinder);
      await tester.pumpAndSettle();

      expect(
        find.text('Source and destination cannot be identical'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'OfferRideScreen validates positive price and submits ride successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OfferRideScreen()));
      await tester.pumpAndSettle();

      final publishFinder = find.widgetWithText(ElevatedButton, 'Publish Ride');

      // Enter valid source and destination
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Koramangala 5th Block');
      await tester.enterText(textFields.at(1), 'Electronic City Phase 1');

      // Test negative/zero price
      await tester.enterText(textFields.at(2), '0');
      await tester.ensureVisible(publishFinder);
      await tester.tap(publishFinder);
      await tester.pumpAndSettle();

      expect(
        find.text('Price must be a valid positive amount'),
        findsOneWidget,
      );

      // Enter valid positive price
      await tester.enterText(textFields.at(2), '150');

      // Tap increment seats
      final addSeatFinder = find.byIcon(Icons.add_circle_outline_rounded);
      await tester.ensureVisible(addSeatFinder);
      await tester.tap(addSeatFinder);
      await tester.pumpAndSettle();

      // Submit valid ride
      await tester.ensureVisible(publishFinder);
      await tester.tap(publishFinder);
      await tester.pumpAndSettle();

      // Verify success confirmation dialog appears
      expect(find.text('Ride Offered Successfully!'), findsOneWidget);
      expect(
        find.text(
          'Your ride has been scheduled and added to your in-memory list.',
        ),
        findsOneWidget,
      );
      expect(find.text('View My Rides'), findsOneWidget);
      expect(find.text('Back to Dashboard'), findsOneWidget);
    },
  );
}
