import 'package:montage/models/transaction_model.dart';

abstract class ITransactionRepository {
  bool get isInitialized;
  Future<void> init(String userId);
  List<TransactionModel> getAll();
  Future<void> add(TransactionModel tx);
  Future<void> update(int key, TransactionModel tx);
  Future<void> updateBulk(Map<int, TransactionModel> transactions);
  Future<void> deleteBulk(List<int> keys);
  // Optional: Add delete if needed, but deleteBulk handles it.
  Future<void> delete(int key);
  void dispose();
}
