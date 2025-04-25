class Validators {
  /// Validates if a field is not empty
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  /// Validates email format (basic)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Validates password length (min 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates review text (min 10 characters for quality)
  static String? validateReview(String? value) {
    if (value == null || value.trim().length < 10) {
      return 'Review must be at least 10 characters';
    }
    return null;
  }

  /// Validates genre input (non-empty, single word recommended)
  static String? validateGenre(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Genre cannot be empty';
    }
    return null;
  }
}
