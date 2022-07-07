import 'package:flutter/material.dart';

import 'BaseTheme.dart';

class PrimaryCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;

  const PrimaryCheckbox({required this.value, required this.onChanged});

  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BaseTheme.DEFAULT_BORDER_RADIUS),
      value: value,
      activeColor: BaseTheme.PRIMARY_COLOR,
      onChanged: onChanged,
      side: BorderSide(color: BaseTheme.DEFAULT_DISPLAY_COLOR),
    );
  }
}
