/// Spacing constants for consistent UI spacing throughout the app
/// 
/// Follows an 8px base unit system for better visual harmony
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  // Base spacing unit (8px)
  static const double base = 8.0;

  // Small spacing (4-8px)
  static const double xs = 4.0;
  static const double sm = 8.0;

  // Medium spacing (12-16px)
  static const double md = 12.0;
  static const double lg = 16.0;

  // Large spacing (20-24px)
  static const double xl = 20.0;
  static const double xxl = 24.0;

  // Extra large spacing (28-32px)
  static const double xxxl = 28.0;
  static const double huge = 32.0;

  // Special spacing values
  static const double section = 24.0; // Space between sections
  static const double cardPadding = 16.0; // Standard card padding
  static const double screenPadding = 20.0; // Standard screen padding
  static const double screenPaddingWeb = 40.0; // Screen padding for web/tablet
}

/// Border radius constants for consistent rounded corners
class AppRadius {
  AppRadius._();

  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double circular = 999.0; // For fully circular shapes
}

/// Icon size constants for consistent icon sizing
class AppIconSize {
  AppIconSize._();

  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 28.0;
  static const double xxl = 32.0;
  static const double huge = 60.0;
}
