import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseTheme {
  static const Color DEFAULT_HEADINGS_COLOR = Color(0xFF3E3E3E);
  static const Color DEFAULT_DISPLAY_COLOR = Color(0xFF2B2B2B);
  static const Color DEFAULT_ERROR_COLOR = Color(0XFFFF0033);

  static const Color FOCUSED_ERROR_COLOR = Color(0xFFA63232);
  static const Color META_TEXT_COLOR = Color(0xFF717171);
  static const Color PRIMARY_COLOR = Color(0xFF170E9A);

  static const Color LIGHT_BLACK_COLOR = Color(0xFFDFDFDF);

  static const EdgeInsets DEFAULT_MARGIN = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets DEFAULT_HEADINGS_MARGIN = EdgeInsets.symmetric(vertical: 12);

  static ThemeData get defaultTheme {
    return ThemeData(
      textTheme: GoogleFonts.mavenProTextTheme(),
      primaryColor: PRIMARY_COLOR,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: PRIMARY_COLOR,
      ),
    );
  }

  static TextStyle get defaultTextStyle {
    return TextStyle(
      color: DEFAULT_DISPLAY_COLOR,
      fontSize: 14,
    );
  }

  static TextStyle Function(Set<MaterialState>) get inputValidationLabelStyle {
    return (states) {
      TextStyle finalStyle = new TextStyle();

      if (states.isEmpty) {
        finalStyle = TextStyle(
          color: BaseTheme.DEFAULT_DISPLAY_COLOR,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
        );
      }

      if (states.contains(MaterialState.focused)) {
        finalStyle = TextStyle(
          color: PRIMARY_COLOR,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
        );
      }

      if (states.contains(MaterialState.focused) && states.contains(MaterialState.error)) {
        finalStyle = TextStyle(
          color: BaseTheme.FOCUSED_ERROR_COLOR,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
        );
      }

      return finalStyle;
    };
  }
}
