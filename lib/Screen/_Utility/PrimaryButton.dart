import 'package:flutter/material.dart';

import 'BaseTheme.dart';
import 'PrimaryLoading.dart';

class PrimaryButton extends StatefulWidget {
  final Function()? onPressed;
  final String text;
  final Color? color;
  final bool? outlined;
  final EdgeInsets? margin;
  final bool? isLoading;

  const PrimaryButton({this.onPressed, required this.text, this.color, this.outlined, this.margin, this.isLoading});

  StatePrimaryButton createState() => StatePrimaryButton();
}

class StatePrimaryButton extends State<PrimaryButton> {
  get onPressed => widget.onPressed;

  get text => widget.text;

  get color => widget.color ?? Theme.of(context).primaryColor;

  get outlined => widget.outlined ?? false;

  get margin => widget.margin;

  get isLoading => widget.isLoading ?? false;

  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: margin,
      duration: Duration(milliseconds: 300),
      child: MaterialButton(
        height: 48,
        elevation: 0,
        highlightElevation: 0,
        color: outlined ? null : color,
        shape: RoundedRectangleBorder(
            borderRadius: BaseTheme.DEFAULT_BORDER_RADIUS,
            side: BorderSide(
              width: outlined ? 1 : 0,
              color: color,
            )),
        disabledColor: color,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Padding(
                padding: EdgeInsets.all(4),
                child: PrimaryLoading(color: outlined ? color : Colors.white),
              )
            : Text(
                text.toUpperCase(),
                style: TextStyle(fontSize: 14, color: outlined ? color : Colors.white, letterSpacing: 3.0),
              ),
      ),
    );
  }
}
