import 'package:intl/intl.dart';

class DateService {
  static const DEFAULT_DATE_FORMAT = "dd/MM/yyyy";

  static String formatDate(DateTime date) {
    DateFormat format = new DateFormat(DEFAULT_DATE_FORMAT);
    return format.format(date);
  }
}
