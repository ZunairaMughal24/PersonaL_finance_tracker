class FinancialPeriodData {
  final String label; 
  final DateTime? date;
  final double income;
  final double expense;

  FinancialPeriodData({
    required this.label,
    this.date,
    required this.income,
    required this.expense,
  });

  FinancialPeriodData copyWith({
    String? label,
    DateTime? date,
    double? income,
    double? expense,
  }) {
    return FinancialPeriodData(
      label: label ?? this.label,
      date: date ?? this.date,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }
}
