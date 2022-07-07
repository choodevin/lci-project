import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class MiniButton extends StatelessWidget {
  final String text;
  final Color? color;
  final EdgeInsets? margin;
  final Function()? onPressed;

  const MiniButton({required this.text, this.onPressed, this.color, this.margin});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: BaseTheme.DEFAULT_ANIMATION_DURATION,
        margin: margin ?? EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(color: color ?? BaseTheme.PRIMARY_COLOR, borderRadius: BaseTheme.DEFAULT_BORDER_RADIUS),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color != null && color!.computeLuminance() > 0.5 ? BaseTheme.DEFAULT_DISPLAY_COLOR : Colors.white,
          ),
        ),
      ),
    );
  }
}
