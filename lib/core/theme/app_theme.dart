import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

final themeModeProvider = ValueNotifier(ThemeMode.system);

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          headlineMedium: AppTypography.headlineMedium,
          bodyLarge: AppTypography.bodyLarge,
          labelLarge: AppTypography.labelLarge,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          headlineMedium: AppTypography.headlineMedium,
          bodyLarge: AppTypography.bodyLarge,
          labelLarge: AppTypography.labelLarge,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      );
}
