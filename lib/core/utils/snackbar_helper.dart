import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/spacing_constants.dart';

class SnackbarHelper {
  /// Shows a floating SnackBar above the navigation bar (for add actions)
  static void showAddSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 120,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        duration: duration,
        elevation: 4,
      ),
    );
  }

  /// Shows a floating SnackBar above the navigation bar with undo action (for removal actions)
  static void showRemoveSnackBarWithUndo(
    BuildContext context,
    String message,
    VoidCallback onUndo, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 120,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        duration: duration,
        elevation: 4,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: onUndo,
        ),
      ),
    );
  }
}
