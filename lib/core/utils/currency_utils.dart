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
    if (amount.abs() >= 10000000000) {
      final compactFormat = NumberFormat.compact();
      return "${getCurrencySymbol(currency)} ${compactFormat.format(amount)}";
    }

    final String pattern = amount % 1 == 0 ? "###,###,###" : "###,###,###.00";
    final format = NumberFormat(pattern);

    return "${getCurrencySymbol(currency)} ${format.format(amount)}";
  }

  static String formatAmountCompact(double amount, String currency) {
    if (amount.abs() >= 1000) {
      return "${getCurrencySymbol(currency)} ${NumberFormat.compact().format(amount)}";
    }
    return formatAmount(amount, currency);
  }

  static String formatCompactAmount(double amount) {
    if (amount == 0) return '0';
    return NumberFormat.compact().format(amount);
  }
}
