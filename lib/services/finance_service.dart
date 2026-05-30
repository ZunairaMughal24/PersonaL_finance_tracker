import 'package:intl/intl.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';

class FinanceService {
  static double calculateTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((tx) => tx.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double calculateTotalExpense(List<Transaction> transactions) {
    return transactions
        .where((tx) => !tx.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  static double calculateBalance(double totalIncome, double totalExpense) {
    return totalIncome - totalExpense;
  }

  static List<Transaction> getTransactionsByType(
    List<Transaction> transactions,
    bool isIncome,
  ) {
    return transactions.where((tx) => tx.isIncome == isIncome).toList();
  }

  static SpendingSummary getSpendingSummary(List<Transaction> transactions) {
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

  static List<FinancialPeriodData> getWeeklyFinancialSummary(
    List<Transaction> transactions,
  ) {
    DateTime getThisWeekDay(int dayOfWeek) {
      final now = DateTime.now();
      return now.subtract(Duration(days: now.weekday - dayOfWeek));
    }

    final Map<String, FinancialPeriodData> dayMap = {
      'Mon': FinancialPeriodData(label: 'Mon', date: getThisWeekDay(DateTime.monday), income: 0, expense: 0),
      'Tue': FinancialPeriodData(label: 'Tue', date: getThisWeekDay(DateTime.tuesday), income: 0, expense: 0),
      'Wed': FinancialPeriodData(label: 'Wed', date: getThisWeekDay(DateTime.wednesday), income: 0, expense: 0),
      'Thu': FinancialPeriodData(label: 'Thu', date: getThisWeekDay(DateTime.thursday), income: 0, expense: 0),
      'Fri': FinancialPeriodData(label: 'Fri', date: getThisWeekDay(DateTime.friday), income: 0, expense: 0),
      'Sat': FinancialPeriodData(label: 'Sat', date: getThisWeekDay(DateTime.saturday), income: 0, expense: 0),
      'Sun': FinancialPeriodData(label: 'Sun', date: getThisWeekDay(DateTime.sunday), income: 0, expense: 0),
    };

    for (var tx in transactions) {
      final parsedDate = DateUtilsCustom.parseDate(tx.date);
      if (parsedDate == null) continue;
      final day = DateFormat('E').format(parsedDate);
      if (!dayMap.containsKey(day)) continue;
      if (tx.isIncome) {
        dayMap[day] = dayMap[day]!.copyWith(income: dayMap[day]!.income + tx.amount);
      } else {
        dayMap[day] = dayMap[day]!.copyWith(expense: dayMap[day]!.expense + tx.amount);
      }
    }

    return dayMap.values.toList().cast<FinancialPeriodData>();
  }
}
