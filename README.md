# Lenskart Movies App

A Flutter movie application built for the Lenskart Mobile Development Assignment. This app integrates with TMDB (The Movie Database) API to provide a comprehensive movie browsing experience.

## 📱 Features

### Core Features
- **Splash Screen**: Animated splash screen with app branding
- **Movies Screen**: Browse popular movies with search functionality
- **Favourites Screen**: Manage your favorite movies
- **Watchlist Screen**: Keep track of movies you want to watch later
- **Movie Detail Screen**: View comprehensive movie information

### Movie Details Include
- Movie Banner/Backdrop
- Title and Year
- Overview/Description
- Release Date
- Genre Tags
- User Rating (Circular Progress Bar)
- Play Now button with In-App Notification

### Additional Features
- Search movies by title
- Add/Remove movies from Favourites
- Add/Remove movies from Watchlist
- Pull-to-refresh on movie list
- Infinite scroll pagination
- Beautiful animations and transitions
- Loading, Empty, and Error states
- Responsive design for various screen sizes

## 🎨 Design

- **Theme**: Dark cinema theme with teal and gold accents
- **Color Palette**:
  - Primary: `#00B4D8` (Teal)
  - Accent: `#FFB703` (Gold)
  - Background: `#0D1B2A` (Dark Navy)
  - Surface: `#1B263B` (Dark Blue)

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK (for Android development)

### TMDB API Key Setup

1. Create an account at [TMDB](https://www.themoviedb.org/)
2. Go to Settings → API
3. Request an API key (choose "Developer" option)
4. Copy your API key

5. Copy the example file to create your config:
```bash
cp lib/core/constants/api_constants.dart.example lib/core/constants/api_constants.dart
```

6. Open `lib/core/constants/api_constants.dart` and replace with your API key:
```dart
static const String apiKey = 'your_actual_api_key_here';
```

> ⚠️ **Note**: `api_constants.dart` is gitignored to protect your API key. Never commit it!

### Running the App

1. **Navigate to project directory**
```bash
cd C:\Abinash\lenskart
```

2. **Create Flutter project structure** (generates android/ios/web folders)
```bash
flutter create .
```

3. **Install dependencies**
```bash
flutter pub get
```

4. **Run the app**
```bash
flutter run
```

### Building APK

To generate a release APK:

```bash
flutter build apk --release
```

The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── core/
│   ├── constants/
│   │   └── api_constants.dart          # API configuration
│   ├── models/
│   │   ├── movie.dart                  # Movie model
│   │   ├── movie_detail.dart           # Movie detail model
│   │   └── genre.dart                  # Genre model
│   ├── services/
│   │   ├── api_service.dart            # TMDB API service
│   │   ├── notification_service.dart   # Local notifications
│   │   └── storage_service.dart        # Local storage (SharedPreferences)
│   └── theme/
│       └── app_theme.dart              # App theming
├── features/
│   ├── splash/
│   │   └── screens/
│   │       └── splash_screen.dart
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart
│   ├── movies/
│   │   ├── providers/
│   │   │   └── movie_provider.dart
│   │   ├── screens/
│   │   │   └── movies_screen.dart
│   │   └── widgets/
│   │       ├── movie_card.dart
│   │       └── search_bar_widget.dart
│   ├── favourites/
│   │   ├── providers/
│   │   │   └── favourites_provider.dart
│   │   └── screens/
│   │       └── favourites_screen.dart
│   ├── watchlist/
│   │   ├── providers/
│   │   │   └── watchlist_provider.dart
│   │   └── screens/
│   │       └── watchlist_screen.dart
│   └── movie_detail/
│       ├── screens/
│       │   └── movie_detail_screen.dart
│       └── widgets/
│           └── circular_rating_widget.dart
└── shared/
    └── widgets/
        ├── loading_widget.dart
        ├── error_widget.dart
        ├── empty_widget.dart
        └── movie_list_tile.dart
```

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| provider | ^6.1.1 | State management |
| http | ^1.1.0 | HTTP requests |
| shared_preferences | ^2.2.2 | Local storage |
| cached_network_image | ^3.3.0 | Image caching |
| flutter_local_notifications | ^16.3.0 | In-app notifications |

## 🔌 API Integration

This app uses the [TMDB API](https://developers.themoviedb.org/3) for movie data:

- **Popular Movies**: `/movie/popular`
- **Search Movies**: `/search/movie`
- **Movie Details**: `/movie/{movie_id}`
- **Genre List**: `/genre/movie/list`

## 📱 Screenshots

The app includes:
1. Splash screen with animated logo
2. Movies grid with search functionality
3. Favourites list with swipe-to-delete
4. Watchlist with swipe-to-delete
5. Detailed movie view with circular rating

## ✅ Requirements Checklist

- [x] Splash Screen with dummy image
- [x] Home Page with Bottom Navigation
- [x] Movies screen with images, names, and genre cards
- [x] Search functionality on Movies screen
- [x] Mark movies as Favourites
- [x] Mark movies as Watchlist
- [x] Unique lists per user (local storage)
- [x] Favourites screen
- [x] Watchlist screen
- [x] Movie Detail with Banner, Name, Overview, Release Date, Genre
- [x] Circular Progress Bar for User Rating
- [x] Play Now button with In-App Notification
- [x] Clean folder structure
- [x] Readable code
- [x] Loading state
- [x] Empty state
- [x] Error state
- [x] Responsive design
- [x] Consistent typography and spacing
- [x] Material Design

## 👨‍💻 Author

Created for Lenskart Mobile Development Assignment

## 📄 License

This project is for assessment purposes only.

