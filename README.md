# Movie Browsing App – Flutter (TMDB API)

## Project Overview

- Flutter application for browsing and discovering movies using The Movie Database (TMDB) API
- Features include movie search, favourites management, watchlist functionality, and detailed movie information
- Implements clean architecture with feature-based folder structure
- Uses Provider for state management and local storage for user preferences
- Includes comprehensive UI states (loading, empty, error) and responsive design

## Tech Stack

- Flutter (Dart) - SDK 3.0.0+
- TMDB API - Movie data source
- Provider (^6.1.1) - State management
- HTTP (^1.1.0) - API requests
- SharedPreferences (^2.2.2) - Local storage for favourites and watchlist
- Flutter Local Notifications (^16.3.0) - In-app notifications

## Features

- Splash screen with animated logo
- Bottom navigation with three tabs: Movies, Favourites, Watchlist
- Movie listing with posters, titles, genres, and ratings
- Real-time movie search functionality
- Movie details screen with banner, overview, release date, genres, and circular rating progress indicator
- Add/remove movies to favourites and watchlist (persisted locally)
- In-app notification triggered by "Play Now" button
- Loading state with progress indicators
- Empty state with helpful messages
- Error state with retry functionality
- Pull-to-refresh and infinite scroll pagination

## API Key Setup (IMPORTANT)

This application requires a TMDB API key to function. The `api_constants.dart` file containing the API key is intentionally not committed to version control.

**Setup Steps:**

1. Get your free API key from [TMDB](https://www.themoviedb.org/settings/api)
2. Copy the example file:
   ```
   Copy: lib/core/constants/api_constants.dart.example
   To: lib/core/constants/api_constants.dart
   ```
3. Open `lib/core/constants/api_constants.dart`
4. Replace `YOUR_TMDB_API_KEY_HERE` with your actual API key:
   ```dart
   static const String apiKey = 'your_actual_api_key_here';
   ```

**File Path:** `lib/core/constants/api_constants.dart`

## How to Run the Project Locally

**Prerequisites:**
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Internet connection for API calls

**Steps:**

1. Clone the repository:
   ```bash
   git clone https://github.com/an-shoo/lenskart-ca.git
   cd lenskart
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up TMDB API key as described in the "API Key Setup" section above

4. Run the application:
   ```bash
   flutter run
   ```

5. To build APK for Android:
   ```bash
   flutter build apk --release
   ```

## Project Structure

```
lib/
├── main.dart                    # Application entry point
├── core/
│   ├── constants/               # API configuration
│   ├── models/                  # Data models (Movie, Genre, MovieDetail)
│   ├── services/                # API service, storage, notifications
│   └── theme/                   # App theming and colors
├── features/
│   ├── splash/                  # Splash screen
│   ├── home/                    # Home screen with bottom navigation
│   ├── movies/                  # Movies listing and search
│   ├── favourites/              # Favourites management
│   ├── watchlist/               # Watchlist management
│   └── movie_detail/            # Movie details screen
└── shared/
    └── widgets/                 # Reusable UI components
```

## Assumptions & Notes

- No user authentication is implemented - data is stored locally per device
- Favourites and watchlist are unique to each device/user session
- Application has been tested on Android platform
- Internet connection is required for API calls and image loading
- TMDB API key must be configured before running the application
- The app uses Material Design 3 with a dark theme

## States Handled

- **Loading state**: Displayed when fetching data from API, includes progress indicators
- **Empty state**: Shown when no movies are found (search results, favourites, watchlist)
- **Error state**: Displayed on API failures or network errors, includes retry functionality

## Screenshots

Screenshots can be added here

## Submission Notes

This project was developed as part of a technical assessment. The code is original and written by the candidate. The repository is structured for local execution and review. All features specified in the requirements have been implemented, including splash screen, bottom navigation, movie browsing with search, favourites/watchlist management, movie details with circular rating, and in-app notifications.
