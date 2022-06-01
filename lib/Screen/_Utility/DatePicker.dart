import 'package:LCI/Screen/_Utility/BaseTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DatePicker extends StatefulWidget {
  final Function onDateTimeChanged;
  final DateTime initialDateTime;

  const DatePicker({required this.onDateTimeChanged, required this.initialDateTime});

  StateDatePicker createState() => StateDatePicker();
}

class StateDatePicker extends State<DatePicker> {
  get onDateTimeChanged => widget.onDateTimeChanged;

  get initialDateTime => widget.initialDateTime;

  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: GoogleFonts.mavenPro(
              fontSize: 18,
              color: BaseTheme.DEFAULT_DISPLAY_COLOR
            ),
          ),
        ),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDateTime,
          minimumYear: 1900,
          maximumYear: DateTime.now().year,
          onDateTimeChanged: onDateTimeChanged,
        ),
      ),
    );
  }
}
