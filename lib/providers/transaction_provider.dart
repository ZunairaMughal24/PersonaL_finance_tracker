import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/models/spending_summary.dart';
import 'package:personal_finance_tracker/services/database_services.dart';
import 'package:personal_finance_tracker/services/finance_service.dart';

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

  double get totalIncome => FinanceService.calculateTotalIncome(_transactions);

  double get totalExpense =>
      FinanceService.calculateTotalExpense(_transactions);

  double get totalBalance =>
      FinanceService.calculateBalance(totalIncome, totalExpense);

  String get displayCurrency =>
      _transactions.isNotEmpty ? _transactions.last.currency : 'USD';

  SpendingSummary get spendingSummary =>
      FinanceService.getSpendingSummary(_transactions);

  List<TransactionModel> getTransactionsByType(bool isIncome) {
    return FinanceService.getTransactionsByType(_transactions, isIncome);
  }
}
