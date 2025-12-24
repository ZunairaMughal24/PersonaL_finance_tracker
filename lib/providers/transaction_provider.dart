// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:personal_finance_tracker/models/transaction_model.dart';

// import 'package:personal_finance_tracker/services/database_services.dart';

// class TransactionProvider extends ChangeNotifier {
//   final box = Hive.box('transactionUpdates');
//   final transactionBox = Hive.box<TransactionModel>('transactions');
//   final DatabaseService db = DatabaseService();
//   double income = 0;
//   double expense = 0;
//   double totalBalance = 0;
//   TransactionProvider() {
//     loadSavedValues();
//   }

//   void loadSavedValues() {
//     income = box.get('income', defaultValue: 0.0);
//     expense = box.get('expense', defaultValue: 0.0);
//     totalBalance = box.get('totalBalance', defaultValue: 0.0);

//     notifyListeners();
//   }

//   void addTransaction(TransactionModel tx) {
//     if (tx.isIncome) {
//       income += tx.amount;
//     } else {
//       expense += tx.amount;
//     }
//     totalBalance = (income - expense);
//     db.addTransaction(tx);
//     box.putAll({
//       'income': income,
//       'expense': expense,
//       'totalBalance': totalBalance,
//     });
//     notifyListeners();
//   }

//   void deleteTransaction(int key) {
//     final tx = transactionBox.get(key);
//     db.deleteTransaction(key);

//     if (tx != null) {
//       recalculateBalance(tx);
//     }
//     notifyListeners();
//   }

//   void recalculateBalance(TransactionModel tx) {
//     if (tx.isIncome) {
//       income -= tx.amount;
//     } else {
//       expense -= tx.amount;
//     }
//     totalBalance = (income - expense);

//     box.putAll({
//       'income': income,
//       'expense': expense,
//       'totalBalance': totalBalance,
//     });
//     notifyListeners();
//   }

//   void updateTransaction(int key, TransactionModel updatedTx) {

//     final oldTx = transactionBox.get(key);

//     if (oldTx != null) {
     
//       if (oldTx.isIncome) {
//         income -= oldTx.amount;
//       } else {
//         expense -= oldTx.amount;
//       }
//     }
//     if (updatedTx.isIncome) {
//       income += updatedTx.amount;
//     } else {
//       expense += updatedTx.amount;
//     }
//     totalBalance = (income - expense);
//     db.updateTransaction(key, updatedTx); 
//      box.putAll({
//       'income': income,
//       'expense': expense,
//       'totalBalance': totalBalance,
//     });
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/services/database_services.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService();
  
  // We no longer need the 'income', 'expense', and 'totalBalance' variables
  // because we calculate them live from the source of truth.

  // --- GETTERS (Calculated State) ---

  /// Calculates total income by filtering and folding the transaction list
  double get totalIncome {
    return db.getAllTransaction()
        .where((tx) => tx.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  /// Calculates total expense
  double get totalExpense {
    return db.getAllTransaction()
        .where((tx) => !tx.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  /// Calculates total balance (Income - Expense)
  /// Returns 0.0 if the balance would be negative (optional professional safety)
  double get totalBalance {
    final balance = totalIncome - totalExpense;
    return balance < 0 ? 0.0 : balance;
  }

  // --- METHODS ---

  /// Adds a transaction and notifies the UI to recalculate totals
  Future<void> addTransaction(TransactionModel tx) async {
    await db.addTransaction(tx);
    notifyListeners(); 
  }

  /// Deletes a transaction using its unique Hive key
  Future<void> deleteTransaction(int key) async {
    await db.deleteTransaction(key);
    notifyListeners();
  }

  /// Updates a transaction and triggers a UI refresh
  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    await db.updateTransaction(key, updatedTx);
    notifyListeners();
  }
}