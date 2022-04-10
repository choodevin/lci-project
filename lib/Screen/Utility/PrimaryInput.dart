import 'package:LCI/Screen/Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class PrimaryInput extends StatefulWidget {
  final String labelText;
  final Function? validator;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final EdgeInsets? margin;
  final Function? onSaved;

  const PrimaryInput({required this.labelText, this.validator, this.textInputAction, this.textInputType, this.margin, this.onSaved});

  StatePrimaryInput createState() => StatePrimaryInput();
}

class StatePrimaryInput extends State<PrimaryInput> {
  get labelText => widget.labelText;

  get validator => widget.validator;

  get textInputAction => widget.textInputAction;

  get textInputType => widget.textInputType;

  get margin => widget.margin;

  get onSaved => widget.onSaved;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorWidth: 1,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          floatingLabelStyle: MaterialStateTextStyle.resolveWith(BaseTheme.inputValidationLabelStyle),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: BaseTheme.FOCUSED_ERROR_COLOR)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_ERROR_COLOR)),
        ),
        style: TextStyle(color: BaseTheme.DEFAULT_DISPLAY_COLOR, letterSpacing: 0.2),
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String labelText;
  final Function? validator;
  final TextInputAction? textInputAction;
  final EdgeInsets? margin;
  final Function? onSaved;

  const PasswordInput({required this.labelText, this.validator, this.textInputAction, this.margin, this.onSaved});

  StatePasswordInput createState() => StatePasswordInput();
}

class StatePasswordInput extends State<PasswordInput> {
  get labelText => widget.labelText;

  get validator => widget.validator;

  get textInputAction => widget.textInputAction;

  get margin => widget.margin;

  get onSaved => widget.onSaved;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: onSaved,
        cursorWidth: 1,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          floatingLabelStyle: MaterialStateTextStyle.resolveWith(BaseTheme.inputValidationLabelStyle),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: BaseTheme.FOCUSED_ERROR_COLOR)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_ERROR_COLOR)),
        ),
        style: TextStyle(color: BaseTheme.DEFAULT_HEADINGS_COLOR, letterSpacing: 0.2),
        obscureText: true,
      ),
    );
  }
}
