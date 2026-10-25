import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum AppSnackType { success, error, info }

/// Consistent, compact feedback messages used across the app.
class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    AppSnackType type = AppSnackType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final (background, icon) = switch (type) {
      AppSnackType.success => (
        const Color(0xFF1E5B25),
        Icons.check_circle_rounded,
      ),
      AppSnackType.error => (const Color(0xFF8E1F15), Icons.error_rounded),
      AppSnackType.info => (AppColors.ink, Icons.info_outline_rounded),
    };

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          width: math.min(460, MediaQuery.sizeOf(context).width - 32),
          backgroundColor: background,
          duration: duration,
          action: actionLabel != null && onAction != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: AppColors.brandGreen,
                  onPressed: onAction,
                )
              : null,
          content: Row(
            children: [
              Icon(icon, color: AppColors.surface, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.surface,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
