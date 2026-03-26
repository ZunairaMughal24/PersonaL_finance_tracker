import 'package:intl/intl.dart';

class DateUtilsCustom {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static DateTime? parseDate(String dateString) {
    if (dateString.isEmpty) return null;

    // List of formats to try parsing
    final formats = ['dd MMM yyyy', 'yyyy-MM-dd', 'MM/dd/yyyy'];

    for (var format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (_) {}
    }

    // Finally try default DateTime.tryParse
    return DateTime.tryParse(dateString);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  static String getFullDayName(DateTime? date) {
    if (date == null) return "";
    return DateFormat('EEEE').format(date);
  }
}
