import 'package:flutter/material.dart';

/// Shared spacing scale. Keeping these values in one place keeps rhythm and
/// alignment consistent across the desktop layout.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
}

class AppSizes {
  AppSizes._();

  static const double contentMaxWidth = 1480;
  static const double formPageMaxWidth = 1180;
  static const double exportPageMaxWidth = 980;
  static const double headerHeight = 78;
  static const double sidebarWidth = 264;
  static const double navigationBreakpoint = 1000;
  static const double formWidth = 424;
  static const double tableBreakpoint = 680;
  static const double wideLayoutBreakpoint = 1240;
}
