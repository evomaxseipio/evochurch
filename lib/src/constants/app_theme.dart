import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.1.1.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class EvoTheme {
  /// The overlay color for dialogs. // Updated Colors
  static const Color _primaryColor = Color(0xFF007BFF); // Trustworthy blue
  static const Color _secondaryColor = Color(0xFFFF6B6B); // Soft, warm red
  static const Color _lightBackgroundColor =
      Color(0xFFF8F9FA); // Light background
  static const Color _darkBackgroundColor =
      Color(0xFF212529); // Dark background
  static const Color _darkSurfaceColor = Color(0xFF343A40); // Dark surface
  static const Color _lightSurfaceColor = Color.fromARGB(255, 234, 238, 243);
  static const Color _lightTextColor = Color(0xFF495057); // Light mode text
  static const Color _darkTextColor = Color(0xFFDEE2E6); // Dark mode text

  // New color for dialog overlay
  static const Color _lightOverlayColor = Color(0x80000000); // 50% black
  static const Color _darkOverlayColor = Color(0x80000000); // 50% black

  // button colors
// Trustworthy blue
// Soft, warm red
// Bright yellow

  // button colors hover
  //dark
  static const Color _buttonPrimaryColorHover =
      Color(0xFF0056B3); // Trustworthy blue
  //light
  static const Color _buttonPrimaryColorHoverLight =
      Color(0xFF007BFF); // Trustworthy blue

  // Text Styles
  static const TextStyle _lightAppBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: _primaryColor,
  );

  static const TextStyle _darkAppBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: _primaryColor,
  );

  static const TextStyle _lightBodyText = TextStyle(
    fontSize: 16,
    color: _lightTextColor,
  );

  static const TextStyle _darkBodyText = TextStyle(
    fontSize: 16,
    color: _darkTextColor,
  );

  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xFF00296B),
      primaryContainer: Color(0xFFA0C2ED),
      primaryLightRef: Color(0xFF00296B),
      secondary: Color(0xFFD26900),
      secondaryContainer: Color(0xFFFFD270),
      secondaryLightRef: Color(0xFFD26900),
      tertiary: Color(0xFF5C5C95),
      tertiaryContainer: Color(0xFFC8DBF8),
      tertiaryLightRef: Color(0xFF5C5C95),
      appBarColor: Color(0xFFC8DCF8),
      error: Color(0x00000000),
      errorContainer: Color(0x00000000),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects:
          true, // Enable interaction effects (hover, focus, etc.)
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      // Customize button hover effects
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.secondary,
      outlinedButtonSchemeColor: SchemeColor.primary,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      textButtonSchemeColor: SchemeColor.primary,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.indigo,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 15,
    useMaterial3: true,
    colors: const FlexSchemeColor(
      primary: Color(0xFFB1CFF5),
      primaryContainer: Color(0xFF3873BA),
      primaryLightRef: Color(0xFF00296B),
      secondary: Color(0xFFFFD270),
      secondaryContainer: Color(0xFFD26900),
      secondaryLightRef: Color(0xFFD26900),
      tertiary: Color(0xFFC9CBFC),
      tertiaryContainer: Color(0xFF535393),
      tertiaryLightRef: Color(0xFF5C5C95),
      appBarColor: Color(0xFF00102B),
      error: Color(0x00000000),
      errorContainer: Color(0x00000000),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects:
          true, // Enable interaction effects (hover, focus, etc.)
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      // Customize button hover effects
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.secondary,
      outlinedButtonSchemeColor: SchemeColor.primary,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      textButtonSchemeColor: SchemeColor.primary,
      
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // Existing utility methods
  static TextStyle title(BuildContext context) => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: context.isDarkMode
            ? EvoColor.darkTextHeader
            : EvoColor.lightTextHeader,
      );

  static TextStyle smallText(BuildContext context) => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: !context.isDarkMode ? EvoColor.lightText : EvoColor.darkText,
      );

  static TextStyle text(BuildContext context) => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: !context.isDarkMode ? EvoColor.lightText : EvoColor.darkText,
      );

  static TextStyle hintText = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: EvoColor.darkhintText,
  );

  static TextStyle heading = const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle heading2 = const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle heading3 = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  // New utility methods
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _primaryColor
        : _primaryColor.withOpacity(0.8);
  }

  static Color getSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _secondaryColor
        : _secondaryColor.withOpacity(0.8);
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightBackgroundColor
        : _darkBackgroundColor;
  }

  static Color getCardBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? EvoColor.boxgreylight
        : _darkBackgroundColor;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightTextColor
        : _darkTextColor;
  }

  // Updated utility method for AlertDialog
  static Future<T?> showEvoDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Theme.of(context).brightness == Brightness.light
          ? _lightOverlayColor
          : _darkOverlayColor,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel();
              },
              child: Text(cancelText),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) onConfirm();
              },
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }

  static Future<T?> showEvoCustomDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Theme.of(context).brightness == Brightness.light
          ? _lightOverlayColor
          : _darkOverlayColor,
      builder: builder,
    );
  }
}
