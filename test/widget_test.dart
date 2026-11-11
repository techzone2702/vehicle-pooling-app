import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_pooling_app/core/constants/app_constants.dart';
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
}
