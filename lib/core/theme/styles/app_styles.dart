import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import 'base_styles.dart';

/// Contains styles for app
class AppStyles implements BaseStyles {
  AppStyles(this._colors);

  final AppColors _colors;

  @override
  TextStyle get headline1 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 36,
        color: _colors.textBlack,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline2 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 32,
        color: _colors.textBlack,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline3 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 28,
        color: _colors.textBlack,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline4 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 24,
        color: _colors.textBlack,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get headline5 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 20,
        color: _colors.textBlack,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get body1 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        color: _colors.white,
        fontWeight: FontWeight.w400,
      );

  @override
  TextStyle get body2 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 12,
        color: _colors.white,
        fontWeight: FontWeight.w300,
      );

  @override
  TextStyle get button1 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 20,
        color: _colors.white,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get button2 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        color: _colors.white,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get button3 => TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 12,
        color: _colors.white,
        fontWeight: FontWeight.w700,
      );
}
