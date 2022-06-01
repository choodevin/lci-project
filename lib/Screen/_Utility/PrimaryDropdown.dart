import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/material.dart';

class PrimaryDropdown extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final Function onChanged;
  final String value;
  final EdgeInsets? margin;
  final String? label;
  final Function? validator;
  final Function? onSaved;
  final bool? enabled;

  const PrimaryDropdown(
      {required this.items, required this.onChanged, required this.value, this.margin, this.label, this.validator, this.onSaved, this.enabled});

  StatePrimaryDropdown createState() => StatePrimaryDropdown();
}

class StatePrimaryDropdown extends State<PrimaryDropdown> {
  get items => widget.items;

  get onChanged => widget.onChanged;

  get value => widget.value;

  get margin => widget.margin ?? BaseTheme.DEFAULT_MARGIN;

  get label => widget.label;

  get validator => widget.validator;

  get onSaved => widget.onSaved;

  get enabled => widget.enabled ?? true;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          items: items,
          onChanged: enabled ? onChanged : null,
          value: value,
          validator: validator,
          onSaved: onSaved,
          elevation: 1,
          borderRadius: BaseTheme.DEFAULT_BORDER_RADIUS,
          isExpanded: true,
          decoration: InputDecoration(
            floatingLabelStyle: MaterialStateTextStyle.resolveWith(BaseTheme.inputValidationLabelStyle),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_DISPLAY_COLOR)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: BaseTheme.FOCUSED_ERROR_COLOR)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: BaseTheme.DEFAULT_ERROR_COLOR)),
          ),
        ),
      ),
    );
  }
}
