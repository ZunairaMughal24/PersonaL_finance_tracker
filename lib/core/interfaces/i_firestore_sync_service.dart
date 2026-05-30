import 'package:montage/domain/entities/transaction.dart';

abstract class IFirestoreSyncService {
  Future<void> pushTransaction(String uid, int id, Transaction tx);
  Future<void> updateTransaction(String uid, int id, Transaction tx);
  Future<void> deleteTransaction(String uid, int id);
  Future<List<Transaction>> pullAllTransactions(String uid);
  Future<void> pushAllTransactions(String uid, Map<int, Transaction> entries);
  Future<void> pushSettings(String uid, Map<String, dynamic> settings);
  Future<Map<String, dynamic>?> pullSettings(String uid);
  Future<void> pushCategories(String uid, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> pullCategories(String uid);
  Future<bool> hasCloudData(String uid);
}
