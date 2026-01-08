import 'package:intl/intl.dart';

class CurrencyUtils {
  static String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'PKR':
        return 'Rs';
      case 'INR':
        return '₹';
      case 'JPY':
        return '¥';
      default:
        return '\$';
    }
  }

  static String formatAmount(double amount, String currency) {
    final format = NumberFormat.currency(
      symbol: "${getCurrencySymbol(currency)} ",
      decimalDigits: 2,
    );
    return format.format(amount);
  }
}
