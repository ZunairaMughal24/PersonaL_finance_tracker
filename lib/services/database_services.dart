import 'package:flutter/foundation.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';

class DatabaseService {
  //accessing box
  final box = Hive.box<TransactionModel>('transactions');
  // Method to add a transaction
  Future<void> addTransaction(TransactionModel tx) async {
    await box.add(tx);
    //tx is the object of model
  }

  List<TransactionModel> getAllTransaction() {
    return box.values.toList();
  }

  Future<void> deleteTransaction(int key) async {
    await box.delete(key);
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    await box.putAt(key, updatedTx);
  }

  ValueListenable<Box<TransactionModel>> listenToBox() {
    return box.listenable();
  }
}
