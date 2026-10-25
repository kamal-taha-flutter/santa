import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Displays the SANTAA brand mark shipped with the application.
///
/// The mark is a transparent crop of the original logo; the original asset is
/// left untouched. The rounded tile keeps the mark legible on both white and
/// tinted header surfaces.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 52,
    this.tileColor = AppColors.brandBlueTint,
    this.showBorder = true,
  });

  final double size;
  final Color tileColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.28);
    return Semantics(
      label: 'شعار SANTA',
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.14),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: radius,
          border: showBorder ? Border.all(color: AppColors.border) : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          'assets/branding/santa_mark.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.storefront_rounded,
              size: size * 0.5,
              color: AppColors.primary,
            );
          },
        ),
      ),
    );
  }
}
