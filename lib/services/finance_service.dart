import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/models/spending_summary.dart';

class FinanceService {
  static double calculateTotalIncome(List<TransactionModel> transactions) {
    return transactions
        .where((tx) => tx.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double calculateTotalExpense(List<TransactionModel> transactions) {
    return transactions
        .where((tx) => !tx.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double calculateBalance(double totalIncome, double totalExpense) {
    return totalIncome - totalExpense;
  }

  static List<TransactionModel> getTransactionsByType(
    List<TransactionModel> transactions,
    bool isIncome,
  ) {
    return transactions.where((tx) => tx.isIncome == isIncome).toList();
  }

  static SpendingSummary getSpendingSummary(
    List<TransactionModel> transactions,
  ) {
    Map<String, double> categoryTotals = {};
    double grandTotal = 0;

    final expenses = transactions.where((t) => !t.isIncome).toList();

    for (var transaction in expenses) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      grandTotal += transaction.amount;
    }

    final sortedCategories = <String>[];
    for (var tx in expenses.reversed) {
      if (!sortedCategories.contains(tx.category) &&
          categoryTotals.containsKey(tx.category)) {
        sortedCategories.add(tx.category);
      }
    }

    for (var cat in categoryTotals.keys) {
      if (!sortedCategories.contains(cat)) {
        sortedCategories.add(cat);
      }
    }

    return SpendingSummary(
      categoryTotals: categoryTotals,
      sortedCategories: sortedCategories,
      grandTotal: grandTotal,
    );
  }
}
