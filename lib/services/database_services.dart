import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';

class DatabaseService {
  //accessing box
  final box = Hive.box<TransactionModel>('transactions');
  // Method to add a transaction
  Future<void> addTransaction(TransactionModel tx) async {
    await box.add(tx);
    //tx is the object of model
    //TransactionModel type
  }

  // Method to get all transactions
  List<TransactionModel> getAllTransaction() {
    return box.values.toList();
  }

  // Method to delete a transaction
  Future<void> deleteTransaction(int key) async {
    await box.delete(key);
  }

  // Method to update a transaction
  Future<void> updateTransaction(int index, TransactionModel tx) async {
    await box.putAt(index, tx);
  }

  /// LISTENABLE for UI rebuild
  ValueListenable<Box<TransactionModel>> listenToBox() {
    return box.listenable();
  }
}
