import 'package:flutter/material.dart';

/// Contains color palette used by the app.
class AppColors {
  // Common colors
  Color get white => const Color(0xFFFFFFFF);
  Color get navy => const Color.fromARGB(255, 7, 81, 150);
  Color get lightOrange1 => const Color(0xFFFF5733);
  Color get lightOrange2 => const Color(0xFFFFE6DD);

  LinearGradient get bgGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF5733),
          Color.fromARGB(255, 231, 141, 123),
        ],
      );

  Color get bgBlack => const Color(0xFF000000);
  Color get bgLightGray => const Color(0xFFFAFAFA);

  // Text Colors
  Color get textBlack => const Color(0xFF1D2125);
  Color get textGray => const Color(0xFF9B9B9B);
}
