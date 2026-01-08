import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/models/spending_summary.dart';
import 'package:personal_finance_tracker/services/database_services.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService();
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  TransactionProvider() {
    _loadTransactions();
  }

  void _loadTransactions() {
    _transactions = db.getAllTransaction();
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await db.addTransaction(tx);

    _loadTransactions();
  }

  Future<void> deleteTransaction(int key, int index) async {
    await db.deleteTransaction(key);
    _loadTransactions();
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    await db.updateTransaction(key, updatedTx);

    _loadTransactions();
  }

  double get totalIncome => _transactions
      .where((tx) => tx.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((tx) => !tx.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalBalance => totalIncome - totalExpense;

  String get displayCurrency =>
      _transactions.isNotEmpty ? _transactions.last.currency : 'USD';

  SpendingSummary get spendingSummary {
    Map<String, double> categoryTotals = {};
    double grandTotal = 0;

    final expenses = _transactions.where((t) => !t.isIncome);

    for (var transaction in expenses) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      grandTotal += transaction.amount;
    }

    return SpendingSummary(
      categoryTotals: categoryTotals,
      grandTotal: grandTotal,
    );
  }
}
