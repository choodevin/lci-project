import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseTheme {
  static const Color BACKGROUND_COLOR = Color(0xFFFFFFFE);

  static const Color DEFAULT_HEADINGS_COLOR = Color(0xFF2B2C34);
  static const Color DEFAULT_DISPLAY_COLOR = Color(0xFF2B2C34);
  static const Color DEFAULT_OUTLINE_COLOR = Color(0xFF2B2C34);
  static const Color DEFAULT_ERROR_COLOR = Color(0XFFFF0033);
  static const Color DEFAULT_INFO_COLOR = Color(0xFF6246EA);
  static const Color DEFAULT_SUCCESS_COLOR = Color(0xFF28A745);

  static const Color LIGHT_ERROR_COLOR = Color(0XFFFF4D4D);
  static const Color LIGHT_OUTLINE_COLOR = Color(0xFFD2D2D2);

  static const Color FOCUSED_ERROR_COLOR = Color(0xFFA63232);
  static const Color META_TEXT_COLOR = Color(0xFF717171);
  static const Color PRIMARY_COLOR = Color(0xFF170E9A);
  static const Color SECONDARY_COLOR = Color(0xFFDBDBEA);
  static const Color DISABLED_COLOR = Color(0xFFE5E5E5);
  static const Color OVERLAY_BACKGROUND_COLOR = Color(0x3D000000);

  static const Color PREMIUM_COLOR = Color(0xFFFFD700);

  static const EdgeInsets DEFAULT_MARGIN = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets DEFAULT_HEADINGS_MARGIN = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets DEFAULT_META_TEXT_MARGIN = EdgeInsets.only(top: 8, bottom: 14);
  static const EdgeInsets DEFAULT_CARD_MARGIN = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets DEFAULT_CONTENT_MARGIN = EdgeInsets.symmetric(horizontal: 12, vertical: 16);
  static const EdgeInsets DEFAULT_BUTTON_MARGIN = EdgeInsets.only(top: 14);
  static const EdgeInsets DEFAULT_MODAL_MARGIN = EdgeInsets.symmetric(horizontal: 16, vertical: 24);
  static const EdgeInsets DEFAULT_SCREEN_MARGIN = EdgeInsets.all(24);

  static const EdgeInsets DEFAULT_HOME_SCREEN_ITEM_MARGIN = EdgeInsets.all(8);
  static const EdgeInsets CONTENT_MARGIN_NO_HORIZONTAL = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets CONTENT_MARGIN_NO_VERTICAL = EdgeInsets.symmetric(horizontal: 12);

  static const BorderRadius DEFAULT_BORDER_RADIUS = BorderRadius.all(Radius.circular(4));
  static const BorderRadius MODAL_BORDER_RADIUS = BorderRadius.all(Radius.circular(12));

  static const String SAMPLE_PARAGRAPH =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam tristique metus non purus luctus, ut suscipit lorem efficitur. Nunc aliquam, risus maximus vulputate lobortis, urna enim malesuada ante, non pharetra felis est sit amet enim. Nulla placerat eros nec turpis sodales ornare. Aliquam rhoncus nisi non pulvinar consectetur. Pellentesque dictum ante a diam rhoncus, id accumsan justo dignissim. Donec fringilla mi id urna eleifend, eu rhoncus dolor vulputate. ";

  static const Duration DEFAULT_ANIMATION_DURATION = Duration(milliseconds: 300);

  static ThemeData get defaultTheme {
    return ThemeData(
      scaffoldBackgroundColor: BACKGROUND_COLOR,
      textTheme: GoogleFonts.workSansTextTheme(),
      primaryColor: PRIMARY_COLOR,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: PRIMARY_COLOR,
      ),
    );
  }

  static TextStyle get defaultTextStyle {
    return GoogleFonts.workSans(
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
