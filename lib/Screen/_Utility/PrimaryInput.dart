import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class PrimaryInput extends StatefulWidget {
  final String labelText;
  final Function? validator;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final EdgeInsets? margin;
  final Function? onSaved;
  final bool? enabled;
  final TextEditingController? textEditingController;
  final bool? readOnly;
  final Function? onTap;
  final AutovalidateMode? autoValidateMode;
  final Function? onEditingComplete;
  final Function? onChanged;

  const PrimaryInput(
      {required this.labelText,
      this.validator,
      this.textInputAction,
      this.textInputType,
      this.margin,
      this.onSaved,
      this.enabled,
      this.textEditingController,
      this.readOnly,
      this.onTap,
      this.autoValidateMode,
      this.onEditingComplete,
      this.onChanged});

  StatePrimaryInput createState() => StatePrimaryInput();
}

class StatePrimaryInput extends State<PrimaryInput> {
  get labelText => widget.labelText;

  get validator => widget.validator;

  get textInputAction => widget.textInputAction;

  get textInputType => widget.textInputType;

  get margin => widget.margin ?? BaseTheme.DEFAULT_MARGIN;

  get onSaved => widget.onSaved;

  get enabled => widget.enabled ?? true;

  get textEditingController => widget.textEditingController ?? TextEditingController();

  get readOnly => widget.readOnly ?? false;

  get onTap => widget.onTap;

  get autoValidateMode => widget.autoValidateMode ?? AutovalidateMode.onUserInteraction;

  get onEditingComplete => widget.onEditingComplete;

  get onChanged => widget.onChanged;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        readOnly: readOnly,
        onTap: onTap,
        enabled: enabled,
        onSaved: onSaved,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: autoValidateMode,
        cursorWidth: 1,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        controller: textEditingController,
        textCapitalization: textInputType == TextInputType.name ? TextCapitalization.words : TextCapitalization.none,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          floatingLabelStyle: MaterialStateTextStyle.resolveWith(BaseTheme.inputValidationLabelStyle),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
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
  final bool? enabled;
  final TextEditingController? textEditingController;
  final Function? onEditingComplete;
  final Function? onChanged;

  const PasswordInput(
      {required this.labelText,
      this.validator,
      this.textInputAction,
      this.margin,
      this.onSaved,
      this.enabled,
      this.textEditingController,
      this.onEditingComplete, this.onChanged});

  StatePasswordInput createState() => StatePasswordInput();
}

class StatePasswordInput extends State<PasswordInput> {
  get labelText => widget.labelText;

  get validator => widget.validator;

  get textInputAction => widget.textInputAction;

  get margin => widget.margin ?? BaseTheme.DEFAULT_MARGIN;

  get onSaved => widget.onSaved;

  get enabled => widget.enabled ?? true;

  get textEditingController => widget.textEditingController;

  get onEditingComplete => widget.onEditingComplete;

  get onChanged => widget.onChanged;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        enabled: enabled,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: onSaved,
        cursorWidth: 1,
        textInputAction: textInputAction,
        controller: textEditingController,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        decoration: InputDecoration(
          floatingLabelStyle: MaterialStateTextStyle.resolveWith(BaseTheme.inputValidationLabelStyle),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: BaseTheme.FOCUSED_ERROR_COLOR)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_ERROR_COLOR)),
        ),
        style: TextStyle(color: BaseTheme.DEFAULT_HEADINGS_COLOR, letterSpacing: 0.2),
        obscureText: true,
      ),
    );
  }
}
