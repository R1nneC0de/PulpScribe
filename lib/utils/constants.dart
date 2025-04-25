import 'package:flutter/material.dart';

/// App-wide colors
class AppColors {
  static const primary = Color(0xFF6A1B9A); // Deep Purple
  static const accent = Color(0xFFBA68C8); // Light Purple
  static const background = Color(0xFFF3E5F5); // Soft Lavender
  static const text = Color(0xFF212121);
}

/// Padding & spacing
class AppPadding {
  static const double screen = 16.0;
  static const double section = 12.0;
  static const double element = 8.0;
}

/// Firebase Collection Keys
class FirestoreCollections {
  static const users = 'users';
  static const reviews = 'reviews';
  static const discussions = 'discussions';
  static const readingList = 'readingList';
}

/// Text styles
class AppTextStyle {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const body = TextStyle(fontSize: 14, color: AppColors.text);
}
