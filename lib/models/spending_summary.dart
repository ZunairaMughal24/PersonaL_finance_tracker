/// Model class to hold spending analytics data
class SpendingSummary {
  final Map<String, double> categoryTotals;
  final double grandTotal;

  SpendingSummary({required this.categoryTotals, required this.grandTotal});
}
