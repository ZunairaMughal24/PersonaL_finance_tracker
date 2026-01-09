class SpendingSummary {
  final Map<String, double> categoryTotals;
  final List<String> sortedCategories;
  final double grandTotal;

  SpendingSummary({
    required this.categoryTotals,
    required this.sortedCategories,
    required this.grandTotal,
  });
}
