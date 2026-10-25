import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

class AppTheme {
  AppTheme._();

  static const String _bodyFont = 'Noto Sans Arabic';
  static const String _displayFont = 'Noto Kufi Arabic';
  static const List<String> _fontFallback = [
    'Noto Sans Arabic',
    'Noto Kufi Arabic',
    'Segoe UI',
    'Tahoma',
    'Arial',
  ];

  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.brandBlue,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          tertiary: AppColors.tertiary,
          onTertiary: AppColors.onTertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          onTertiaryContainer: AppColors.onTertiaryContainer,
          error: AppColors.error,
          onError: AppColors.onError,
          errorContainer: AppColors.errorContainer,
          onErrorContainer: AppColors.onErrorContainer,
          surface: AppColors.surface,
          onSurface: AppColors.ink,
          surfaceContainerLowest: AppColors.surface,
          surfaceContainerLow: AppColors.surfaceMuted,
          surfaceContainer: AppColors.canvas,
          surfaceContainerHigh: AppColors.surfaceSunken,
          surfaceContainerHighest: AppColors.surfaceSunken,
          onSurfaceVariant: AppColors.inkMuted,
          outline: AppColors.outline,
          outlineVariant: AppColors.border,
          shadow: AppColors.shadow,
          scrim: AppColors.ink,
          inverseSurface: AppColors.ink,
          onInverseSurface: AppColors.surface,
          inversePrimary: AppColors.brandGreen,
        );

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);
    final bodyText = base.textTheme.apply(
      fontFamily: _bodyFont,
      fontFamilyFallback: _fontFallback,
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    final textTheme = bodyText.copyWith(
      displaySmall: _display(
        bodyText.displaySmall,
        fontSize: 30,
        weight: FontWeight.w700,
      ),
      headlineLarge: _display(
        bodyText.headlineLarge,
        fontSize: 28,
        weight: FontWeight.w700,
      ),
      headlineMedium: _display(
        bodyText.headlineMedium,
        fontSize: 24,
        weight: FontWeight.w700,
      ),
      headlineSmall: _display(
        bodyText.headlineSmall,
        fontSize: 21,
        weight: FontWeight.w700,
      ),
      titleLarge: _display(
        bodyText.titleLarge,
        fontSize: 18,
        weight: FontWeight.w700,
      ),
      titleMedium: _display(
        bodyText.titleMedium,
        fontSize: 15.5,
        weight: FontWeight.w600,
      ),
      titleSmall: _display(
        bodyText.titleSmall,
        fontSize: 14,
        weight: FontWeight.w600,
      ),
      bodyLarge: bodyText.bodyLarge?.copyWith(fontSize: 15, height: 1.7),
      bodyMedium: bodyText.bodyMedium?.copyWith(fontSize: 14, height: 1.65),
      bodySmall: bodyText.bodySmall?.copyWith(fontSize: 12.5, height: 1.55),
      labelLarge: bodyText.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      labelMedium: bodyText.labelMedium?.copyWith(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      labelSmall: bodyText.labelSmall?.copyWith(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: _bodyFont,
      fontFamilyFallback: _fontFallback,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      canvasColor: AppColors.canvas,
      dividerColor: AppColors.border,
      hintColor: AppColors.inkSubtle,
      disabledColor: AppColors.inkSubtle,
      unselectedWidgetColor: AppColors.outline,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: AppSizes.headerHeight,
        titleSpacing: AppSpacing.xxl,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.shadow.withValues(alpha: 0.08),
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.none,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.inkMuted, size: 20),
      primaryIconTheme: const IconThemeData(
        color: AppColors.onPrimary,
        size: 20,
      ),
      inputDecorationTheme: const InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        isDense: false,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.error, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: AppColors.border),
        ),
        labelStyle: TextStyle(
          color: AppColors.inkMuted,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: AppColors.inkSubtle,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        helperStyle: TextStyle(
          color: AppColors.inkMuted,
          fontSize: 12,
          height: 1.5,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
        errorMaxLines: 2,
        prefixIconColor: AppColors.inkMuted,
        suffixIconColor: AppColors.inkMuted,
        prefixIconConstraints: BoxConstraints(minWidth: 44, minHeight: 22),
        suffixIconConstraints: BoxConstraints(minWidth: 44, minHeight: 22),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: _buttonBackground(AppColors.primary),
          foregroundColor: _buttonForeground(AppColors.onPrimary),
          overlayColor: _overlay(AppColors.onPrimary),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.button),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: _buttonBackground(AppColors.primary),
          foregroundColor: _buttonForeground(AppColors.onPrimary),
          overlayColor: _overlay(AppColors.onPrimary),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
          backgroundColor: _outlinedBackground,
          overlayColor: _overlay(AppColors.primary),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.borderStrong),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
          overlayColor: _overlay(AppColors.primary),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.button),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.inkMuted),
          overlayColor: _overlay(AppColors.primary),
          minimumSize: const WidgetStatePropertyAll(Size(40, 40)),
          iconSize: const WidgetStatePropertyAll(20),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
            ),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: const TextStyle(
          color: AppColors.surface,
          fontSize: 12,
          height: 1.4,
        ),
        waitDuration: const Duration(milliseconds: 450),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: const WidgetStatePropertyAll(AppColors.brandBlueTint),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.brandBlueTint;
          }
          return null;
        }),
        headingRowHeight: 48,
        dataRowMinHeight: 52,
        dataRowMaxHeight: 58,
        horizontalMargin: AppSpacing.xl,
        columnSpacing: 28,
        dividerThickness: 1,
        headingTextStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.inkMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        dataTextStyle: textTheme.bodyMedium?.copyWith(
          fontSize: 13.5,
          color: AppColors.ink,
        ),
        headingRowAlignment: MainAxisAlignment.start,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shadowColor: AppColors.shadow.withValues(alpha: 0.18),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        insetPadding: const EdgeInsets.all(AppSpacing.xxl),
        iconColor: AppColors.primary,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontSize: 19),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.inkMuted,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          0,
          AppSpacing.xxl,
          AppSpacing.xl,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        actionTextColor: AppColors.brandGreen,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.surface,
          fontSize: 13.5,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        showCloseIcon: true,
        closeIconColor: AppColors.surface,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryContainer,
        circularTrackColor: AppColors.primaryContainer,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          AppColors.inkSubtle.withValues(alpha: 0.55),
        ),
        thumbVisibility: const WidgetStatePropertyAll(false),
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(AppRadius.sm),
        interactive: true,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.18),
        selectionHandleColor: AppColors.primary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.primary,
        textColor: AppColors.ink,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.brandBlueTint,
        selectedColor: AppColors.primaryContainer,
        side: const BorderSide(color: AppColors.border),
        labelStyle: textTheme.labelMedium?.copyWith(color: AppColors.ink),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
      focusColor: AppColors.primary.withValues(alpha: 0.12),
      hoverColor: AppColors.brandBlueTint,
      highlightColor: AppColors.primary.withValues(alpha: 0.08),
    );
  }

  static TextStyle? _display(
    TextStyle? base, {
    required double fontSize,
    required FontWeight weight,
  }) {
    return base?.copyWith(
      fontFamily: _displayFont,
      fontFamilyFallback: _fontFallback,
      fontSize: fontSize,
      fontWeight: weight,
      height: 1.4,
      letterSpacing: 0,
    );
  }

  static WidgetStateProperty<Color?> _buttonBackground(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.surfaceSunken;
      }
      if (states.contains(WidgetState.pressed)) {
        return AppColors.brandBlueDarker;
      }
      if (states.contains(WidgetState.hovered)) {
        return AppColors.primaryDark;
      }
      return color;
    });
  }

  static WidgetStateProperty<Color?> _buttonForeground(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.inkSubtle;
      }
      return color;
    });
  }

  static WidgetStateProperty<Color?> _overlay(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return color.withValues(alpha: 0.20);
      }
      if (states.contains(WidgetState.hovered)) {
        return color.withValues(alpha: 0.10);
      }
      if (states.contains(WidgetState.focused)) {
        return color.withValues(alpha: 0.14);
      }
      return null;
    });
  }

  static WidgetStateProperty<Color?>? get _outlinedBackground {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return AppColors.brandBlueTint;
      }
      return AppColors.surface;
    });
  }

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const supportedLocales = [Locale('ar')];
}
