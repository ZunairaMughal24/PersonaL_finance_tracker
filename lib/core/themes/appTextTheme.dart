import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextStyle h1({Color? color, FontWeight weight = FontWeight.w700}) =>
      GoogleFonts.nunito(
        fontSize: 24,
        height: 1.2,
        fontWeight: weight,
        color: color,
      );

  static TextStyle h2({Color? color, FontWeight weight = FontWeight.w700}) =>
      GoogleFonts.nunito(
        fontSize: 20,
        height: 1.2,
        fontWeight: weight,
        color: color,
      );

  static TextStyle h3({Color? color, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.nunito(
        fontSize: 18,
        height: 1.2,
        fontWeight: weight,
        color: color,
      );

  // Body Style (Primary content text)
  static TextStyle body({
    Color? color,
    FontWeight weight = FontWeight.w400,
    double fontSize = 14,
  }) => GoogleFonts.nunito(
    fontSize: fontSize,
    height: 1.4,
    fontWeight: weight,
    color: color,
  );

  // Mono Font Style (using Geologica)
  static TextStyle mono({
    Color? color,
    FontWeight weight = FontWeight.w400,
    double fontSize = 13,
  }) => GoogleFonts.geologica(
    fontSize: fontSize,
    height: 1.2,
    fontWeight: weight,
    color: color,
  );
}
