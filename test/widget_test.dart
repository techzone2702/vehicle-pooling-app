import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_pooling_app/core/constants/app_constants.dart';
import 'package:vehicle_pooling_app/main.dart';

void main() {
  testWidgets(
    'VehiclePoolingApp smoke test - renders home screen and modules',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const VehiclePoolingApp());
      await tester.pumpAndSettle();

      // Verify that the App Bar title renders the app name.
      expect(find.text(AppConstants.appName), findsOneWidget);

      // Verify key action buttons and dashboard elements appear.
      expect(find.text('Find a Ride'), findsOneWidget);
      expect(find.text('Offer Ride'), findsOneWidget);
      expect(find.text('Rides & Search'), findsOneWidget);
      expect(find.text('My Bookings'), findsOneWidget);
    },
  );
}
