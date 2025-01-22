import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:flutter/material.dart';

class EvoTheme {
  // Updated Colors
  static const Color _primaryColor = Color(0xFF007BFF); // Trustworthy blue
  static const Color _secondaryColor = Color(0xFFFF6B6B); // Soft, warm red
  static const Color _lightBackgroundColor =Color(0xFFF8F9FA); // Light background
  static const Color _darkBackgroundColor =Color(0xFF212529); // Dark background
  static const Color _darkSurfaceColor = Color(0xFF343A40); // Dark surface
  static const Color _lightSurfaceColor =Color.fromARGB(255, 234, 238, 243);  
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
  static const Color _buttonPrimaryColorHover = Color(0xFF0056B3); // Trustworthy blue
  //light
  static const Color _buttonPrimaryColorHoverLight = Color(0xFF007BFF); // Trustworthy blue




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

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      surface: _lightSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _lightTextColor,
      // onPrimaryContainer: _buttonPrimaryColorHover,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightBackgroundColor,
      foregroundColor: _primaryColor,
      titleTextStyle: _lightAppBarTitle,
      iconTheme: IconThemeData(color: _primaryColor),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        side: const BorderSide(color: _primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: _primaryColor,
        iconSize: 18
        
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightTextColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black26,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: const IconThemeData(
      color: _primaryColor,
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: _lightTextColor),
      displayMedium: const TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: _lightTextColor),
      displaySmall: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: _lightTextColor),
      headlineMedium: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: _lightTextColor),
      titleLarge: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: _lightTextColor),
      bodyLarge: _lightBodyText,
      bodyMedium: _lightBodyText.copyWith(fontSize: 14),
    ),
     // New AlertDialog theme
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: _primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: _lightTextColor,
        fontSize: 16,
      ),
    ),
    // Dialog overlay color
    dialogBackgroundColor: Colors.white,
    // New ShowDialog overlay theme
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    
    scaffoldBackgroundColor: _lightBackgroundColor,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark( 
      primary: _primaryColor,
      secondary: _secondaryColor,
      surface: _darkSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,      
      onSurface: _darkTextColor,
      onPrimaryContainer: _buttonPrimaryColorHover,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      foregroundColor: _primaryColor,
      titleTextStyle: _darkAppBarTitle,
      iconTheme: IconThemeData(color: _primaryColor),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        side: const BorderSide(color: _primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurfaceColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkTextColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    cardTheme: CardTheme(
      color: _darkSurfaceColor,
      shadowColor: Colors.black87,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: const IconThemeData(
      color: _primaryColor,
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: _darkTextColor),
      displayMedium: const TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: _darkTextColor),
      displaySmall: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: _darkTextColor),
      headlineMedium: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: _darkTextColor),
      titleLarge: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: _darkTextColor),
      bodyLarge: _darkBodyText,
      bodyMedium: _darkBodyText.copyWith(fontSize: 14),
    ),
    // New AlertDialog theme
    dialogTheme: DialogTheme(
      backgroundColor: _darkSurfaceColor,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: _primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: _darkTextColor,
        fontSize: 16,
      ),
    ),
     // Dialog overlay color
    dialogBackgroundColor: _darkSurfaceColor,
    // New ShowDialog overlay theme
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: _darkBackgroundColor,
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

  // New utility method for custom dialogs
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
