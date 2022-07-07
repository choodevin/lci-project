import 'package:intl/intl.dart';

class DateService {
  static const DEFAULT_DATE_FORMAT = "dd/MM/yyyy";

  static String formatDate(DateTime date) {
    DateFormat format = new DateFormat(DEFAULT_DATE_FORMAT);
    return format.format(date);
  }

  static DateTime getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String getDateStringWithSuffix(DateTime selectedDate) {
    String suffix = "";
    if (!(selectedDate.day >= 1 && selectedDate.day <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (selectedDate.day >= 11 && selectedDate.day <= 13) {
      suffix = 'th';
    }

    switch (selectedDate.day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }

    return "${selectedDate.day}$suffix ${DateFormat(DateFormat.MONTH).format(selectedDate)} ${selectedDate.year}";
  }
}
