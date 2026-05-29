import 'package:flutter/foundation.dart';
import 'package:montage/core/utils/app_logger.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:montage/models/transaction_model.dart';

class DatabaseService {
  final Box<TransactionModel> box;

  DatabaseService(this.box);

  // Method to add a transaction
  Future<void> addTransaction(TransactionModel tx) async {
    try {
      await box.add(tx);
    } catch (e, stackTrace) {
      AppLogger.error(
        'DatabaseService: Error adding transaction',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  List<TransactionModel> getAllTransaction() {
    return box.values.toList();
  }

  Future<void> deleteTransaction(int key) async {
    try {
      await box.delete(key);
    } catch (e, stackTrace) {
      AppLogger.error(
        'DatabaseService: Error deleting transaction',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    try {
      await box.put(key, updatedTx);
    } catch (e, stackTrace) {
      AppLogger.error(
        'DatabaseService: Error updating transaction',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> updateBulkTransactions(
    Map<int, TransactionModel> transactions,
  ) async {
    try {
      await box.putAll(transactions);
    } catch (e, stackTrace) {
      AppLogger.error(
        'DatabaseService: Error updating bulk transactions',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  ValueListenable<Box<TransactionModel>> listenToBox() {
    return box.listenable();
  }
}
