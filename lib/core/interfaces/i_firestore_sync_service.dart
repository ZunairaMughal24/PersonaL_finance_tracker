import 'package:montage/models/transaction_model.dart';

abstract class IFirestoreSyncService {
  Future<void> pushTransaction(String uid, int key, TransactionModel tx);
  Future<void> updateTransaction(String uid, int key, TransactionModel tx);
  Future<void> deleteTransaction(String uid, int key);
  Future<List<TransactionModel>> pullAllTransactions(String uid);
  Future<void> pushAllTransactions(
    String uid,
    Map<dynamic, TransactionModel> entries,
  );
  Future<void> pushSettings(String uid, Map<String, dynamic> settings);
  Future<Map<String, dynamic>?> pullSettings(String uid);
  Future<void> pushCategories(String uid, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> pullCategories(String uid);
  Future<bool> hasCloudData(String uid);
}
