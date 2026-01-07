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
}
