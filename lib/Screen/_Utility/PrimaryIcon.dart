import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryIcon extends StatelessWidget {
  final dynamic iconSource;
  final double? size;
  final Color? color;
  final bool? outlined;

  const PrimaryIcon({required this.iconSource, this.size, this.color, this.outlined});

  Widget build(BuildContext context) {
    Widget? child = null;

    double finalSize = size ?? 16;
    Color finalColor = color ?? Colors.black;
    bool finalOutlined = outlined ?? false;

    if (iconSource is String) child = SvgPicture.asset(iconSource, height: finalSize, width: finalSize, color: finalColor);
    if (iconSource is IconData) child = Icon(iconSource, size: finalSize, color: finalColor);

    if (child != null) {
      return Container(
        child: child,
        padding: EdgeInsets.all(finalSize / 2),
        decoration: BoxDecoration(
          color: BaseTheme.BACKGROUND_COLOR,
          border: finalOutlined
              ? Border.all(
                  color: BaseTheme.DEFAULT_DISPLAY_COLOR,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      );
    }

    return Text("Invalid icon source");
  }
}
