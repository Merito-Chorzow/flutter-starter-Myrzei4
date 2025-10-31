import 'package:flutter/material.dart';

const _primary = Color(0xFF2196F3);
const _accent = Color(0xFF00BCD4);
const _bg = Color(0xFF0B0F12);
const _card = Color(0xFF111418);
const _muted = Color(0xFF9AA3AE);

final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _primary,
  onPrimary: Colors.white,
  secondary: _accent,
  onSecondary: Colors.black,
  background: _bg,
  onBackground: Colors.white70,
  surface: _card,
  onSurface: Colors.white70,
  error: Colors.red,
  onError: Colors.white,
);

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 2,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: darkColorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: base.textTheme.apply(
      fontFamily: 'InterCustom',
      bodyColor: Colors.white70,
      displayColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.alphaBlend(Colors.white12, darkColorScheme.surface),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      hintStyle: TextStyle(color: _muted),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _accent,
      foregroundColor: Colors.black,
    ),
    listTileTheme: const ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      tileColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkColorScheme.surface,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
