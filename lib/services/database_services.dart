import 'package:flutter/foundation.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:montage/models/transaction_model.dart';

class DatabaseService {
  final Box<TransactionModel> box;

  DatabaseService(this.box);

  // Method to add a transaction
  Future<void> addTransaction(TransactionModel tx) async {
    try {
      await box.add(tx);
    } catch (e) {
      debugPrint('DatabaseService: Error adding transaction: $e');
      rethrow;
    }
  }

  List<TransactionModel> getAllTransaction() {
    return box.values.toList();
  }

  Future<void> deleteTransaction(int key) async {
    try {
      await box.delete(key);
    } catch (e) {
      debugPrint('DatabaseService: Error deleting transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    try {
      await box.put(key, updatedTx);
    } catch (e) {
      debugPrint('DatabaseService: Error updating transaction: $e');
      rethrow;
    }
  }

  ValueListenable<Box<TransactionModel>> listenToBox() {
    return box.listenable();
  }
}
