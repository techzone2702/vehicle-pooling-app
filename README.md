# Vehicle Pooling App

A modern, scalable **Vehicle Pooling (Carpooling) Application** developed with Flutter and Dart. Designed with a modular, feature-first architecture that enables passengers to find shared rides and drivers to monetize empty seats while reducing carbon emissions and travel expenses.

---

## 1. Project Overview

The vehicle pooling application facilitates ride sharing between drivers and passengers through the following core workflow:

- **Ride Creation**: A vehicle owner (User A) creates a ride specifying source, destination, departure date/time, available seats, and price per seat.
- **Ride Discovery**: A traveler (User B) searches for available rides matching their departure, destination, and schedule.
- **Booking & Requests**: User B inspects the ride details and submits a joining request.
- **Approval Workflow**: User A can accept or reject joining requests.
- **Active Trip & History**: Once accepted, both parties access trip details, real-time coordination, and booking summaries.

Future phases will incorporate user authentication, vehicle verification, Google Maps Platform route mapping, push notifications, and in-app chat.

---

## 2. Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (v3.47+ / Target Platforms: Android, iOS, Web, Windows, macOS, Linux)
- **Language**: [Dart](https://dart.dev) (v3.13+)
- **Design System**: Material Design 3 (M3) with centralized Light and Dark theme configurations
- **Maps**: Google Maps Platform (Directions, Geocoding, Places) — *architecture ready*
- **Backend / API**: REST API ready (`ApiService` abstraction layer)
- **Persistence**: Key-value cache & local database ready (`StorageService` abstraction layer)

---

## 3. Architecture & Folder Structure

The project adopts a **Modular Feature-First Architecture** complemented by a centralized **Core Layer** for cross-cutting concerns and shared UI components:

```text
lib/
├── main.dart                          # Application entry point & root MaterialApp
│
├── core/                              # Centralized cross-cutting foundation
│   ├── constants/
│   │   ├── app_colors.dart            # Brand palette, status colors, and theme tones
│   │   └── app_constants.dart         # Dimensions, strings, and asset path constants
│   ├── theme/
│   │   └── app_theme.dart             # Material 3 light & dark theme definitions
│   ├── utils/
│   │   ├── app_routes.dart            # Centralized named routing & navigation handler
│   │   └── formatters.dart            # Date, time, currency, and count formatters
│   ├── widgets/
│   │   ├── custom_button.dart         # Reusable primary & outlined action buttons
│   │   ├── custom_text_field.dart     # Standardized text input form fields
│   │   ├── empty_state_view.dart      # Reusable empty & placeholder views
│   │   └── loading_indicator.dart     # Consistent progress indicators
│   └── services/
│       ├── api_service.dart           # Base REST API contract & mock implementation
│       └── storage_service.dart       # Local key-value storage contract
│
├── models/                            # Domain entities with serialization
│   ├── user_model.dart                # User profiles (driver and passenger)
│   ├── vehicle_model.dart             # Registered vehicle specifications
│   ├── ride_model.dart                # Offered ride journeys and seat capacities
│   └── booking_model.dart             # Joining requests and booking status
│
└── features/                          # Self-contained domain feature modules
    ├── authentication/                # User login, registration, and session logic
    │   ├── screens/login_screen.dart
    │   ├── widgets/auth_header.dart
    │   └── services/auth_service.dart
    ├── home/                          # Main dashboard & module quick-launchers
    │   ├── screens/home_screen.dart
    │   └── widgets/quick_action_card.dart
    ├── profile/                       # User profile, ratings, and stats
    │   ├── screens/profile_screen.dart
    │   ├── widgets/
    │   └── services/profile_service.dart
    ├── vehicle/                       # Vehicle management & verification
    │   ├── screens/vehicle_screen.dart
    │   ├── widgets/
    │   └── services/vehicle_service.dart
    ├── rides/                         # Search, filter, and offer rides
    │   ├── screens/rides_screen.dart
    │   ├── widgets/
    │   └── services/ride_service.dart
    ├── booking/                       # Manage requests, approvals, and history
    │   ├── screens/booking_screen.dart
    │   ├── widgets/
    │   └── services/booking_service.dart
    ├── maps/                          # Route plotting and live location tracking
    │   ├── screens/map_screen.dart
    │   ├── widgets/
    │   └── services/map_service.dart
    ├── notifications/                 # Real-time trip alerts & request updates
    │   ├── screens/notifications_screen.dart
    │   └── services/notification_service.dart
    └── chat/                          # Driver-passenger messaging
        ├── screens/chat_screen.dart
        ├── widgets/
        └── services/chat_service.dart

assets/
├── images/                            # Application graphics and banners
├── icons/                             # Custom vector & raster icons
└── fonts/                             # Custom typography fonts
```

---

## 4. Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.47 or later)
- [Dart SDK](https://dart.dev/get-dart) (3.13 or later)
- IDE: Visual Studio Code with Flutter & Dart extensions, or Android Studio

### Installation

1. Clone or navigate to the repository directory:
   ```bash
   cd c:\CodeProjects\vehicle-pooling-app
   ```

2. Fetch Flutter package dependencies:
   ```bash
   flutter pub get
   ```

3. Verify environment and connected devices:
   ```bash
   flutter doctor
   flutter devices
   ```

---

## 5. Running the Application

Launch on your preferred platform:

- **Windows Desktop**:
  ```bash
  flutter run -d windows
  ```

- **Web Browser (Chrome)**:
  ```bash
  flutter run -d chrome
  ```

- **Mobile Device / Emulator** (Android or iOS):
  ```bash
  flutter run
  ```

---

## 6. Code Quality & Testing

Format the codebase:
```bash
dart format .
```

Run static analysis:
```bash
flutter analyze
```

Execute widget and unit tests:
```bash
flutter test
```
