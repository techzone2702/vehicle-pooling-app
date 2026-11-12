import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_pooling_app/core/constants/app_constants.dart';
import 'package:vehicle_pooling_app/core/utils/app_routes.dart';
import 'package:vehicle_pooling_app/features/home/screens/home_screen.dart';
import 'package:vehicle_pooling_app/features/rides/screens/find_ride_screen.dart';
import 'package:vehicle_pooling_app/features/rides/screens/offer_ride_screen.dart';
import 'package:vehicle_pooling_app/features/rides/services/ride_service.dart';
import 'package:vehicle_pooling_app/features/booking/screens/booking_screen.dart';
import 'package:vehicle_pooling_app/features/booking/screens/driver_requests_screen.dart';
import 'package:vehicle_pooling_app/features/booking/services/booking_service.dart';
import 'package:vehicle_pooling_app/features/rides/widgets/ride_result_card.dart';
import 'package:vehicle_pooling_app/models/booking_model.dart';
import 'package:vehicle_pooling_app/models/ride_model.dart';
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

  group('PlaceholderRideService Tests', () {
    final service = PlaceholderRideService.instance;

    setUp(() {
      service.resetMockRides();
    });

    test(
      'Valid search returns matching rides sorted by earliest departure time',
      () async {
        final now = DateTime.now();
        final results = await service.searchRides(
          source: 'Koramangala',
          destination: 'Whitefield',
          date: DateTime(now.year, now.month, now.day),
        );

        expect(results.isNotEmpty, isTrue);
        // Verify departure times are sorted ascending
        for (int i = 0; i < results.length - 1; i++) {
          expect(
            results[i].departureTime.isBefore(results[i + 1].departureTime) ||
                results[i].departureTime.isAtSameMomentAs(
                  results[i + 1].departureTime,
                ),
            isTrue,
          );
        }
      },
    );

    test('Case-insensitive and partial location matching works', () async {
      final now = DateTime.now();
      final results = await service.searchRides(
        source: 'kORAMANGALA',
        destination: 'wHITEFIELD',
        date: DateTime(now.year, now.month, now.day),
      );

      expect(results.any((r) => r.source.contains('Koramangala')), isTrue);
      expect(results.any((r) => r.destination.contains('Whitefield')), isTrue);
    });

    test('Filters rides strictly by selected travel date', () async {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));

      final todayResults = await service.searchRides(
        source: 'Koramangala',
        destination: 'Whitefield',
        date: DateTime(now.year, now.month, now.day),
      );
      final tomorrowResults = await service.searchRides(
        source: 'Koramangala',
        destination: 'Whitefield',
        date: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
      );

      for (final r in todayResults) {
        expect(r.departureTime.day, equals(now.day));
      }
      for (final r in tomorrowResults) {
        expect(r.departureTime.day, equals(tomorrow.day));
      }
    });

    test('Excludes fully booked rides (availableSeats == 0)', () async {
      final now = DateTime.now();
      final detailed = await service.searchRidesDetailed(
        source: 'HSR Layout',
        destination: 'Manyata',
        date: DateTime(now.year, now.month, now.day),
      );

      expect(detailed.rides.isEmpty, isTrue);
      expect(
        detailed.emptyReason,
        equals(RideSearchEmptyReason.allRidesFullyBooked),
      );
    });

    test(
      "Excludes current user's own offered rides (driverId == u_1)",
      () async {
        final now = DateTime.now();
        final results = await service.searchRides(
          source: 'Downtown Metro Station',
          destination: 'Tech Park Campus',
          date: DateTime(now.year, now.month, now.day),
          currentUserId: 'u_1',
        );

        expect(results.any((r) => r.driverId == 'u_1'), isFalse);
      },
    );

    test(
      'Correctly reports noMatchingRoute when no rides exist for route',
      () async {
        final now = DateTime.now();
        final detailed = await service.searchRidesDetailed(
          source: 'Jaipur Junction',
          destination: 'Delhi Aerocity',
          date: DateTime(now.year, now.month, now.day),
        );

        expect(detailed.rides.isEmpty, isTrue);
        expect(
          detailed.emptyReason,
          equals(RideSearchEmptyReason.noMatchingRoute),
        );
      },
    );
  });

  group('FindRideScreen Widget Tests', () {
    setUp(() {
      FindRideScreen.lastSearchArgs = null;
      FindRideScreen.lastSearchResult = null;
      PlaceholderRideService.instance.resetMockRides();
    });

    testWidgets(
      'FindRideScreen renders initial search form, discovery banner, and swap button',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: FindRideScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Find a Ride'), findsOneWidget);
        expect(find.text('Search Available Rides'), findsOneWidget);
        expect(find.text('Leaving From'), findsOneWidget);
        expect(find.text('Going To'), findsOneWidget);
        expect(find.byIcon(Icons.swap_vert_rounded), findsOneWidget);
        expect(find.text('Travel Date'), findsOneWidget);
        expect(
          find.widgetWithText(ElevatedButton, 'Search Rides'),
          findsOneWidget,
        );
        expect(find.text('Find Your Next Commute'), findsOneWidget);
      },
    );

    testWidgets(
      'FindRideScreen validates empty fields and identical locations',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: FindRideScreen()));
        await tester.pumpAndSettle();

        final searchButton = find.widgetWithText(
          ElevatedButton,
          'Search Rides',
        );
        await tester.ensureVisible(searchButton);
        await tester.tap(searchButton);
        await tester.pumpAndSettle();

        expect(find.text('Please enter departure location'), findsOneWidget);
        expect(find.text('Please enter destination'), findsOneWidget);

        // Enter identical locations
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'Indiranagar');
        await tester.enterText(textFields.at(1), 'Indiranagar');

        await tester.ensureVisible(searchButton);
        await tester.tap(searchButton);
        await tester.pumpAndSettle();

        expect(
          find.text('Source and destination cannot be identical'),
          findsOneWidget,
        );
      },
    );

    testWidgets('Swap button interchanges source and destination text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: FindRideScreen()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Koramangala');
      await tester.enterText(textFields.at(1), 'Whitefield');
      await tester.pumpAndSettle();

      final swapButton = find.byIcon(Icons.swap_vert_rounded);
      await tester.tap(swapButton);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Whitefield'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Koramangala'), findsOneWidget);
    });

    testWidgets(
      'Submits valid search and renders RideResultCard with driver and vehicle info',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: FindRideScreen()));
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'Koramangala');
        await tester.enterText(textFields.at(1), 'Whitefield');

        final searchButton = find.widgetWithText(
          ElevatedButton,
          'Search Rides',
        );
        await tester.ensureVisible(searchButton);
        await tester.tap(searchButton);
        await tester.pumpAndSettle();

        // Verify results count and RideResultCard rendering
        expect(find.byType(RideResultCard), findsWidgets);
        expect(find.text('Priya Singh'), findsWidgets);
        expect(find.text('Verified Driver'), findsWidgets);
        expect(find.text('View Details'), findsWidgets);

        // Tap View Details on the first ride result
        final viewDetailsButton = find
            .widgetWithText(OutlinedButton, 'View Details')
            .first;
        await tester.ensureVisible(viewDetailsButton);
        await tester.tap(viewDetailsButton);
        await tester.pumpAndSettle();

        // Verify bottom sheet modal opened
        expect(find.text('Ride Details'), findsOneWidget);
        expect(find.text('Pickup Point'), findsOneWidget);
        expect(find.text('Drop-off Destination'), findsOneWidget);
        expect(find.text('Vehicle Specifications'), findsOneWidget);
        expect(find.text('Close'), findsOneWidget);

        // Close bottom sheet
        final closeFinder = find.widgetWithText(OutlinedButton, 'Close');
        await tester.ensureVisible(closeFinder);
        await tester.tap(closeFinder);
        await tester.pumpAndSettle();
        expect(find.text('Ride Details'), findsNothing);
      },
    );

    testWidgets(
      'Displays friendly empty state when no matching route is found',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: FindRideScreen()));
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'Mumbai Central');
        await tester.enterText(textFields.at(1), 'Pune Station');

        final searchButton = find.widgetWithText(
          ElevatedButton,
          'Search Rides',
        );
        await tester.ensureVisible(searchButton);
        await tester.tap(searchButton);
        await tester.pumpAndSettle();

        expect(find.text('No Matching Rides Found'), findsOneWidget);
        expect(find.text('Modify Search'), findsOneWidget);
      },
    );

    testWidgets(
      'FindRideScreen automatically executes search when launched with FindRideArgs',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                settings: RouteSettings(
                  name: AppRoutes.findRide,
                  arguments: FindRideArgs(
                    source: 'Indiranagar',
                    destination: 'Electronic City',
                    date: DateTime.now(),
                  ),
                ),
                builder: (_) => const FindRideScreen(),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        // Verify textfields auto-filled
        expect(
          find.widgetWithText(TextFormField, 'Indiranagar'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(TextFormField, 'Electronic City'),
          findsOneWidget,
        );

        // Verify auto-executed results
        expect(find.byType(RideResultCard), findsWidgets);
        expect(find.text('Ananya Roy'), findsOneWidget);
      },
    );
  });

  group('Booking and Join Request Service Tests', () {
    setUp(() {
      PlaceholderBookingService.instance.resetMockBookings();
      PlaceholderRideService.instance.resetMockRides();
    });

    test('createBookingRequest initializes with pending status and stores details correctly', () async {
      final departure = DateTime.now().add(const Duration(hours: 4));
      final booking = await PlaceholderBookingService.instance
          .createBookingRequest(
            rideId: 'ride_102',
            passengerId: 'u_10',
            seats: 2,
            totalPrice: 280.0,
            passengerName: 'Karan Mehra',
            passengerPhone: '+91 99999 88888',
            source: 'Koramangala, Bengaluru',
            destination: 'Whitefield Tech Park',
            departureTime: departure,
          );

      expect(booking.id, startsWith('book_'));
      expect(booking.status, BookingStatus.pending);
      expect(booking.seatsBooked, 2);
      expect(booking.totalPrice, 280.0);
      expect(booking.passengerName, 'Karan Mehra');
      expect(booking.source, 'Koramangala, Bengaluru');
      expect(booking.destination, 'Whitefield Tech Park');
    });

    test(
      'createBookingRequest prevents passenger from requesting their own ride',
      () async {
        // ride_101 has driverId == 'u_1'
        expect(
          () => PlaceholderBookingService.instance.createBookingRequest(
            rideId: 'ride_101',
            passengerId: 'u_1',
            seats: 1,
            totalPrice: 120.0,
          ),
          throwsA(
            predicate(
              (e) =>
                  e.toString().contains('cannot request to join your own ride'),
            ),
          ),
        );
      },
    );

    test('createBookingRequest prevents requested seats exceeding available capacity', () async {
      final ride = await PlaceholderRideService.instance.getRideById(
        'ride_102',
      );
      final maxCapacity = ride?.availableSeats ?? 3;

      expect(
        () => PlaceholderBookingService.instance.createBookingRequest(
          rideId: 'ride_102',
          passengerId: 'u_15',
          seats: maxCapacity + 1,
          totalPrice: 500.0,
        ),
        throwsA(
          predicate((e) => e.toString().contains('exceed available capacity')),
        ),
      );
    });

    test('createBookingRequest prevents duplicate pending requests for the same ride and passenger', () async {
      await PlaceholderBookingService.instance.createBookingRequest(
        rideId: 'ride_104',
        passengerId: 'u_99',
        seats: 1,
        totalPrice: 160.0,
      );

      expect(
        () => PlaceholderBookingService.instance.createBookingRequest(
          rideId: 'ride_104',
          passengerId: 'u_99',
          seats: 1,
          totalPrice: 160.0,
        ),
        throwsA(
          predicate((e) => e.toString().contains('pending join request')),
        ),
      );
    });

    test('acceptBookingRequest changes status to accepted, updates timestamp, and deducts available seats from ride', () async {
      final rideBefore = await PlaceholderRideService.instance.getRideById(
        'ride_102',
      );
      final initialSeats = rideBefore!.availableSeats;

      final newReq = await PlaceholderBookingService.instance
          .createBookingRequest(
            rideId: 'ride_102',
            passengerId: 'u_50',
            seats: 2,
            totalPrice: 280.0,
          );

      final accepted = await PlaceholderBookingService.instance
          .acceptBookingRequest(newReq.id);

      expect(accepted.status, BookingStatus.accepted);
      expect(accepted.respondedAt, isNotNull);

      final rideAfter = await PlaceholderRideService.instance.getRideById(
        'ride_102',
      );
      expect(rideAfter!.availableSeats, initialSeats - 2);
    });

    test('acceptBookingRequest prevents double-acceptance of an already processed request', () async {
      final req = await PlaceholderBookingService.instance.createBookingRequest(
        rideId: 'ride_102',
        passengerId: 'u_51',
        seats: 1,
        totalPrice: 140.0,
      );

      await PlaceholderBookingService.instance.acceptBookingRequest(req.id);

      expect(
        () => PlaceholderBookingService.instance.acceptBookingRequest(req.id),
        throwsA(
          predicate((e) => e.toString().contains('already been accepted')),
        ),
      );
    });

    test('rejectBookingRequest changes status to rejected and leaves available seats unchanged', () async {
      final rideBefore = await PlaceholderRideService.instance.getRideById(
        'ride_102',
      );
      final initialSeats = rideBefore!.availableSeats;

      final req = await PlaceholderBookingService.instance.createBookingRequest(
        rideId: 'ride_102',
        passengerId: 'u_52',
        seats: 1,
        totalPrice: 140.0,
      );

      final rejected = await PlaceholderBookingService.instance
          .rejectBookingRequest(req.id);

      expect(rejected.status, BookingStatus.rejected);
      expect(rejected.respondedAt, isNotNull);

      final rideAfter = await PlaceholderRideService.instance.getRideById(
        'ride_102',
      );
      expect(rideAfter!.availableSeats, initialSeats);
    });
  });

  group('Booking and Join Request UI Widget Tests', () {
    setUp(() {
      PlaceholderBookingService.instance.resetMockBookings();
      PlaceholderRideService.instance.resetMockRides();
    });

    testWidgets(
      'RideResultCard modal allows interactive seat stepper and dynamic fare calculation',
      (WidgetTester tester) async {
        final testRide = RideModel(
          id: 'test_r1',
          driverId: 'u_other',
          vehicleId: 'veh_test1',
          createdAt: DateTime.now(),
          driverName: 'Vikram Seth',
          driverRating: 4.9,
          source: 'Indiranagar 100ft Road',
          destination: 'Whitefield Tech Park',
          departureTime: DateTime.now().add(const Duration(hours: 3)),
          availableSeats: 3,
          totalSeats: 4,
          pricePerSeat: 150.0,
          vehicleInfo: 'Honda City • KA-03-EF-9012',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: RideResultCard(ride: testRide)),
          ),
        );
        await tester.pumpAndSettle();

        // Tap View Details
        final viewDetails = find.widgetWithText(OutlinedButton, 'View Details');
        await tester.ensureVisible(viewDetails);
        await tester.tap(viewDetails);
        await tester.pumpAndSettle();

        // Verify modal opened and initial stepper is 1 seat
        expect(find.text('Select Required Seats'), findsOneWidget);
        expect(find.text('1 seat × ₹150'), findsOneWidget);
        expect(find.text('₹150'), findsWidgets);

        // Tap '+' to increment seats
        final plusIcon = find.byIcon(Icons.add);
        await tester.tap(plusIcon);
        await tester.pumpAndSettle();

        // Verify dynamic fare update to 2 seats × ₹150 = ₹300
        expect(find.text('2 seats × ₹150'), findsOneWidget);
        expect(find.text('₹300'), findsOneWidget);

        // Tap '-' to decrement seats back to 1
        final minusIcon = find.byIcon(Icons.remove);
        await tester.tap(minusIcon);
        await tester.pumpAndSettle();
        expect(find.text('1 seat × ₹150'), findsOneWidget);
        expect(find.text('₹150'), findsWidgets);
      },
    );

    testWidgets(
      'RideResultCard sends join request and displays confirmation dialog',
      (WidgetTester tester) async {
        final testRide = (await PlaceholderRideService.instance.getRideById(
          'ride_104',
        ))!;

        await tester.pumpWidget(
          MaterialApp(
            routes: {AppRoutes.booking: (_) => const BookingScreen()},
            home: Scaffold(body: RideResultCard(ride: testRide)),
          ),
        );
        await tester.pumpAndSettle();

        final viewDetails = find.widgetWithText(OutlinedButton, 'View Details');
        await tester.ensureVisible(viewDetails);
        await tester.tap(viewDetails);
        await tester.pumpAndSettle();

        // Tap Send Join Request
        final sendBtn = find.widgetWithText(
          ElevatedButton,
          'Send Join Request',
        );
        await tester.ensureVisible(sendBtn);
        await tester.tap(sendBtn);
        await tester.pumpAndSettle();

        // Verify confirmation dialog
        expect(find.text('Request Sent!'), findsOneWidget);
        expect(find.text('View in My Bookings'), findsOneWidget);

        // Tap Done to close dialog
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
        expect(find.text('Request Sent!'), findsNothing);
      },
    );

    testWidgets(
      'BookingScreen renders Sent Requests and Booking History tabs with correct status badges',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: BookingScreen()));
        await tester.pumpAndSettle();

        // Verify title and tabs
        expect(find.text('My Bookings'), findsOneWidget);
        expect(find.text('Sent Requests'), findsOneWidget);
        expect(find.text('Booking History'), findsOneWidget);

        // Verify default mock requests for u_1
        expect(find.text('Pending'), findsWidgets);
        expect(find.text('Accepted'), findsWidgets);
        expect(find.text('Cancel Request'), findsWidgets);

        // Switch to Booking History tab
        await tester.tap(find.text('Booking History'));
        await tester.pumpAndSettle();

        // History has rejected request book_p3
        expect(find.text('Rejected'), findsWidgets);
      },
    );

    testWidgets(
      'DriverRequestsScreen renders incoming requests and supports driver Accept action',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: DriverRequestsScreen()),
        );
        await tester.pumpAndSettle();

        // Verify title and tabs
        expect(find.text('Incoming Ride Requests'), findsOneWidget);
        expect(find.text('Pending'), findsWidgets);
        expect(find.text('Processed'), findsOneWidget);

        // Verify incoming pending request for driver u_1
        expect(find.text('Ankit Mehra'), findsOneWidget);
        expect(find.text('Accept'), findsOneWidget);
        expect(find.text('Decline'), findsOneWidget);

        // Tap Accept
        final acceptBtn = find.widgetWithText(ElevatedButton, 'Accept');
        await tester.tap(acceptBtn);
        await tester.pumpAndSettle();

        // Verify SnackBar feedback
        expect(
          find.textContaining('Accepted join request from Ankit Mehra'),
          findsOneWidget,
        );
      },
    );
  });
}
