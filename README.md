# Corpfinity Employee Wellness App

A Flutter mobile application that provides employees with quick wellness activities (1-5 minutes) during their workday.

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Root app widget
├── core/                     # Core utilities and shared components
│   ├── constants/           # App constants (colors, typography, dimensions)
│   ├── theme/               # Theme configuration
│   ├── utils/               # Utility functions and helpers
│   └── widgets/             # Reusable widgets
├── features/                # Feature modules
│   ├── onboarding/         # Splash, welcome carousel
│   ├── auth/               # Authentication and profile setup
│   ├── home/               # Home screen and energy selection
│   ├── activities/         # Activity selection, guide, completion
│   ├── progress/           # Progress tracking, streaks, badges
│   └── profile/            # User profile and settings
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Repository implementations
│   └── services/           # API and local storage services
└── routes/                  # Navigation configuration

assets/
├── images/                  # Image assets
├── animations/             # Lottie animation files
└── icons/                  # Icon assets
```

## Dependencies

- **State Management**: Provider
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: Hive, flutter_secure_storage
- **Animations**: Lottie

## Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart 3.8.1 or higher

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Permissions configured: INTERNET, ACCESS_NETWORK_STATE

#### iOS
- Minimum iOS version: 12.0
- Orientation: Portrait only
- App Transport Security configured for development

## Development

### Running Tests
```bash
flutter test
```

### Building for Release

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## Features

- User onboarding with welcome carousel
- Email/password and SSO authentication
- Energy-based activity recommendations
- Six wellness pillars (Stress Reduction, Increased Energy, Better Sleep, Physical Fitness, Healthy Eating, Social Connection)
- Step-by-step activity guidance
- Progress tracking with streaks and badges
- Activity library with search and filters
- User profile and settings management

## License

Proprietary - Corpfinity
