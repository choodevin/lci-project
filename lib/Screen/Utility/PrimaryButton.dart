import 'package:LCI/Notifier/StateNotifier.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final Function()? onPressed;
  final String text;
  final Color? color;
  final bool? outlined;
  final EdgeInsets? margin;
  final StateNotifier? stateNotifier;

  const PrimaryButton({this.onPressed, required this.text, this.color, this.outlined, this.margin, this.stateNotifier});

  StatePrimaryButton createState() => StatePrimaryButton();
}

class StatePrimaryButton extends State<PrimaryButton> {
  get onPressed => widget.onPressed;

  get text => widget.text;

  get color => widget.color ?? Theme.of(context).primaryColor;

  get outlined => widget.outlined ?? false;

  get margin => widget.margin;

  get stateNotifier => widget.stateNotifier;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: MaterialButton(
        height: 48,
        elevation: 0,
        highlightElevation: 0,
        color: outlined ? null : color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
            side: BorderSide(
              width: outlined ? 1 : 0,
              color: color,
            )),
        disabledColor: color,
        onPressed: onPressed,
        child: stateNotifier != null && stateNotifier.currentState == StateNotifier.STATE_LOADING
            ? CircularProgressIndicator()
            : Text(
                text.toUpperCase(),
                style: TextStyle(fontSize: 14, color: outlined ? color : Colors.white, letterSpacing: 3.0),
              ),
      ),
    );
  }
}
