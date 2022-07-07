import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final LinearGradient? gradient;
  final Color? borderColor;
  final EdgeInsets? margin;
  final EdgeInsets? contentMargin;
  final bool? outlined;

  const PrimaryCard({required this.child, this.color, this.gradient, this.borderColor, this.margin, this.contentMargin, this.outlined});

  Widget build(BuildContext context) {
    Color finalBorderColor = borderColor ?? Colors.transparent;
    bool finalOutlined = outlined ?? true;

    if (color == null && gradient == null) finalBorderColor = BaseTheme.LIGHT_OUTLINE_COLOR;
    finalBorderColor = borderColor ?? finalBorderColor;

    return Container(
      margin: margin ?? BaseTheme.DEFAULT_CARD_MARGIN,
      child: Container(
        margin: contentMargin ?? BaseTheme.DEFAULT_CONTENT_MARGIN,
        child: child,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        color: color ?? BaseTheme.BACKGROUND_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: finalOutlined ? Border.all(
          color: finalBorderColor,
        ) : null,
      ),
    );
  }
}
