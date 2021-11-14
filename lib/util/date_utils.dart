import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTimeUtils shared = DateTimeUtils();

  String? stringFromDate(DateTime? date) {
    if (date != null) {
      return DateFormat('yyyy-MM-dd').format(date);
    } else {
      return null;
    }
  }

  DateTime? dateFromString(String text) {
    return DateTime.tryParse(text);
  }

  String? stringDateFromString(String text) {
    DateTime newDate = DateFormat("yyyy-M-dd").parse(text);
    String? newStringDate = stringFromDate(newDate);
    return newStringDate;
  }
}
