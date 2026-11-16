import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const textTheme = TextTheme(
    headlineMedium: TextStyle(
      color: AppColors.ink,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      color: AppColors.ink,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: AppColors.ink,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: AppColors.ink, fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5),
    labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  );
}
