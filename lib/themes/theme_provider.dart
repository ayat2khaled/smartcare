import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ── Premium Light Theme ──
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2563EB),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F7FA),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1E293B)),
      titleTextStyle: TextStyle(
        color: Color(0xFF1E293B),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2563EB),
      unselectedItemColor: Color(0xFF94A3B8),
      elevation: 8,
    ),
    cardColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: const Color(0xFFE2E8F0),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF3B82F6),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Color(0xFF1E293B),
      onSecondary: Colors.white,
      error: Color(0xFFEF4444),
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Color(0xFF1E293B)),
      titleSmall: TextStyle(color: Color(0xFF1E293B)),
      bodyLarge: TextStyle(color: Color(0xFF1E293B)),
      bodyMedium: TextStyle(color: Color(0xFF1E293B)),
      bodySmall: TextStyle(color: Color(0xFF64748B)),
      labelLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: Color(0xFF64748B)),
      labelSmall: TextStyle(color: Color(0xFF94A3B8)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF2563EB);
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF2563EB).withValues(alpha: 0.3);
        return Colors.grey.shade300;
      }),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xFF2563EB),
      unselectedLabelColor: Color(0xFF64748B),
      indicatorColor: Color(0xFF2563EB),
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF2563EB),
      linearTrackColor: Color(0xFFE2E8F0),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF1F5F9),
      selectedColor: const Color(0xFF2563EB),
      labelStyle: const TextStyle(color: Color(0xFF1E293B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFF1E293B),
      iconColor: Color(0xFF64748B),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Color(0xFF1E293B),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      contentTextStyle: const TextStyle(color: Color(0xFF64748B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1E293B),
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // ── Premium Dark Theme ──
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3B82F6),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      selectedItemColor: Color(0xFF3B82F6),
      unselectedItemColor: Color(0xFF64748B),
      elevation: 8,
    ),
    cardColor: const Color(0xFF1E293B),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: const Color(0xFF334155),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF60A5FA),
      surface: Color(0xFF1E293B),
      onPrimary: Colors.white,
      onSurface: Color(0xFFE2E8F0),
      onSecondary: Colors.white,
      error: Color(0xFFF87171),
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Color(0xFFE2E8F0)),
      titleSmall: TextStyle(color: Color(0xFFE2E8F0)),
      bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
      bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
      bodySmall: TextStyle(color: Color(0xFF94A3B8)),
      labelLarge: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: Color(0xFF94A3B8)),
      labelSmall: TextStyle(color: Color(0xFF64748B)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE2E8F0)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF3B82F6);
        return const Color(0xFF64748B);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF3B82F6).withValues(alpha: 0.3);
        return const Color(0xFF334155);
      }),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xFF3B82F6),
      unselectedLabelColor: Color(0xFF94A3B8),
      indicatorColor: Color(0xFF3B82F6),
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF3B82F6),
      linearTrackColor: Color(0xFF334155),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF253350),
      selectedColor: const Color(0xFF3B82F6),
      labelStyle: const TextStyle(color: Color(0xFFE2E8F0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFFE2E8F0),
      iconColor: Color(0xFF94A3B8),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1E293B),
      titleTextStyle: const TextStyle(
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      contentTextStyle: const TextStyle(color: Color(0xFF94A3B8)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF334155),
      contentTextStyle: const TextStyle(color: Color(0xFFE2E8F0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}