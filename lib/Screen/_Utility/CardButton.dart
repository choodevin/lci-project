import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:LCI/Screen/_Utility/CustomIcon.dart';
import 'package:LCI/Screen/_Utility/PrimaryCard.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final Color? color;
  final EdgeInsets? margin;
  final Function()? onPressed;

  const CardButton({Key? key, required this.text, required this.iconPath, this.color, this.margin, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: PrimaryCard(
        outlined: false,
        color: color,
        contentMargin: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        margin: margin,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: CustomIcon(
                outlined: true,
                iconSource: iconPath,
                size: 24,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color!.computeLuminance() > 0.5 ? BaseTheme.DEFAULT_DISPLAY_COLOR : Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: color!.computeLuminance() > 0.5 ? BaseTheme.DEFAULT_DISPLAY_COLOR : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
