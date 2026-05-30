import 'package:hive_flutter/adapters.dart';
import 'package:montage/core/utils/app_logger.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/models/transaction_model.dart';

class DatabaseService {
  final Box<TransactionModel> box;

  DatabaseService(this.box);

  Future<int> addTransaction(Transaction tx) async {
    try {
      return await box.add(TransactionModel.fromEntity(tx));
    } catch (e, stackTrace) {
      AppLogger.error('DatabaseService: Error adding transaction', e, stackTrace);
      rethrow;
    }
  }

  List<Transaction> getAllTransaction() {
    return box.values.map((m) => m.toEntity()).toList();
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await box.delete(id);
    } catch (e, stackTrace) {
      AppLogger.error('DatabaseService: Error deleting transaction', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateTransaction(int id, Transaction tx) async {
    try {
      await box.put(id, TransactionModel.fromEntity(tx));
    } catch (e, stackTrace) {
      AppLogger.error('DatabaseService: Error updating transaction', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateBulkTransactions(Map<int, Transaction> transactions) async {
    try {
      final hiveMap = transactions.map(
        (k, v) => MapEntry(k, TransactionModel.fromEntity(v)),
      );
      await box.putAll(hiveMap);
    } catch (e, stackTrace) {
      AppLogger.error('DatabaseService: Error updating bulk transactions', e, stackTrace);
      rethrow;
    }
  }
}
