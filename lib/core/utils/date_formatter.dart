import 'package:intl/intl.dart';

class DateUtilsCustom {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static DateTime parseDate(String dateString) {
    try {
      return DateFormat('dd MMM yyyy').parse(dateString);
    } catch (e) {
  
      return DateTime.now();
    }
  }
  static String formatFullDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }
}
