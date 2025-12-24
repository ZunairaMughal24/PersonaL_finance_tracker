import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';

import 'package:personal_finance_tracker/services/database_services.dart';

class TransactionProvider extends ChangeNotifier {
  final box = Hive.box('transactionUpdates');
  final transactionBox = Hive.box<TransactionModel>('transactions');
  final DatabaseService db = DatabaseService();
  double income = 0;
  double expense = 0;
  double totalBalance = 0;
  TransactionProvider() {
    loadSavedValues();
  }

  void loadSavedValues() {
    income = box.get('income', defaultValue: 0.0);
    expense = box.get('expense', defaultValue: 0.0);
    totalBalance = box.get('totalBalance', defaultValue: 0.0);

    notifyListeners();
  }

  void addTransaction(TransactionModel tx) {
    if (tx.isIncome) {
      income += tx.amount;
    } else {
      expense += tx.amount;
    }
    totalBalance = (income - expense);
    db.addTransaction(tx);
    box.putAll({
      'income': income,
      'expense': expense,
      'totalBalance': totalBalance,
    });
    notifyListeners();
  }

  void deleteTransaction(int key) {
    final tx = transactionBox.get(key);
    db.deleteTransaction(key);

    if (tx != null) {
      recalculateBalance(tx);
    }
    notifyListeners();
  }

  void recalculateBalance(TransactionModel tx) {
    if (tx.isIncome) {
      income -= tx.amount;
    } else {
      expense -= tx.amount;
    }
    totalBalance = (income - expense);

    box.putAll({
      'income': income,
      'expense': expense,
      'totalBalance': totalBalance,
    });
    notifyListeners();
  }

  void updateTransaction(int key, TransactionModel updatedTx) {

    final oldTx = transactionBox.get(key);

    if (oldTx != null) {
     
      if (oldTx.isIncome) {
        income -= oldTx.amount;
      } else {
        expense -= oldTx.amount;
      }
    }
    if (updatedTx.isIncome) {
      income += updatedTx.amount;
    } else {
      expense += updatedTx.amount;
    }
    totalBalance = (income - expense);
    db.updateTransaction(key, updatedTx); 
     box.putAll({
      'income': income,
      'expense': expense,
      'totalBalance': totalBalance,
    });
    notifyListeners();
  }
}
