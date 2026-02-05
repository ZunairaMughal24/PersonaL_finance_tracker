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
    final String pattern = amount % 1 == 0 ? "###,###,###" : "###,###,###.00";
    final format = NumberFormat(pattern);

    return "${getCurrencySymbol(currency)} ${format.format(amount)}";
  }

  static String formatCompactAmount(double amount) {
    if (amount >= 1000000) {
      double millions = amount / 1000000;
      if (millions >= 10) {
        return "${millions.toStringAsFixed(0)}M";
      } else {
        return "${millions.toStringAsFixed(1)}M";
      }
    } else if (amount >= 1000) {
      double thousands = amount / 1000;
      if (thousands >= 10) {
        return "${thousands.toStringAsFixed(0)}K";
      } else {
        return "${thousands.toStringAsFixed(1)}K";
      }
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}
