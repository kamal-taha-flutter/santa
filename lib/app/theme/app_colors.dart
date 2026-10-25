import 'package:flutter/material.dart';

/// Brand and semantic colour tokens for the application.
///
/// The palette is sampled directly from `assets/لوجو.png`:
/// - SANTAA blue   #006AA1
/// - SANTAA orange #F58634
/// - SANTAA green  #A8CF45
///
/// The darker accent variants are used for text so that every pairing keeps
/// a comfortable WCAG contrast ratio on light surfaces.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------
  static const Color brandBlue = Color(0xFF006AA1);
  static const Color brandBlueDark = Color(0xFF00527D);
  static const Color brandBlueDarker = Color(0xFF003A5A);
  static const Color brandBlueSoft = Color(0xFFE4F3FB);
  static const Color brandBlueTint = Color(0xFFF0F8FD);

  static const Color brandOrange = Color(0xFFF58634);
  static const Color brandOrangeDark = Color(0xFF9A4B08);
  static const Color brandOrangeSoft = Color(0xFFFFEBDD);
  static const Color brandOrangeTint = Color(0xFFFFF6EF);

  static const Color brandGreen = Color(0xFFA8CF45);
  static const Color brandGreenDark = Color(0xFF476B05);
  static const Color brandGreenSoft = Color(0xFFF1F8DF);

  // ---------------------------------------------------------------------------
  // Semantic aliases used by the app shell and widgets
  // ---------------------------------------------------------------------------
  static const Color primary = brandBlue;
  static const Color primaryDark = brandBlueDark;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = brandBlueSoft;
  static const Color onPrimaryContainer = Color(0xFF003A5A);

  static const Color secondary = brandOrange;
  static const Color secondaryDark = brandOrangeDark;
  static const Color onSecondary = Color(0xFF3A1A00);
  static const Color secondaryContainer = brandOrangeSoft;
  static const Color onSecondaryContainer = Color(0xFF4A1F00);

  static const Color tertiary = brandGreen;
  static const Color tertiaryDark = brandGreenDark;
  static const Color onTertiary = Color(0xFF1F2A00);
  static const Color tertiaryContainer = brandGreenSoft;
  static const Color onTertiaryContainer = Color(0xFF243300);

  // ---------------------------------------------------------------------------
  // Surfaces and typography
  // ---------------------------------------------------------------------------
  static const Color canvas = Color(0xFFF4F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFB);
  static const Color surfaceSunken = Color(0xFFEEF3F6);
  static const Color ink = Color(0xFF14262F);
  static const Color inkMuted = Color(0xFF5A6B75);
  static const Color inkSubtle = Color(0xFF63747E);
  static const Color outline = Color(0xFF7C8C96);
  static const Color border = Color(0xFFDCE5EB);
  static const Color borderStrong = Color(0xFFC5D3DC);

  // ---------------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------------
  static const Color error = Color(0xFFB42318);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE8E6);
  static const Color onErrorContainer = Color(0xFF601410);
  static const Color success = Color(0xFF2E7D32);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFEAF4E7);
  static const Color onSuccessContainer = Color(0xFF123B16);

  // Shadow is intentionally restrained; cards rely on borders first.
  static const Color shadow = Color(0xFF0B1F2A);
}
