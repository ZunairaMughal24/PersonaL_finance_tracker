import 'package:intl/intl.dart';

class DateUtilsCustom {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}