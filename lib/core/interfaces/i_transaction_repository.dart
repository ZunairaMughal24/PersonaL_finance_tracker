import 'package:montage/core/enums/sync_status.dart';
import 'package:montage/domain/entities/transaction.dart';

abstract class ITransactionRepository {
  bool get isInitialized;
  Stream<SyncStatus> get syncStatus;
  Future<void> init(String userId);
  List<Transaction> getAll();
  Future<void> add(Transaction tx);
  Future<void> update(int id, Transaction tx);
  Future<void> updateBulk(Map<int, Transaction> transactions);
  Future<void> deleteBulk(List<int> ids);
  Future<void> delete(int id);
  void dispose();
}
