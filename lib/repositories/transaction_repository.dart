import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/services/database_services.dart';
import 'package:montage/services/firestore_sync_service.dart';

class TransactionRepository {
  final FirestoreSyncService _syncService;
  DatabaseService? _db;
  String? _userId;

  TransactionRepository({FirestoreSyncService? syncService})
    : _syncService = syncService ?? FirestoreSyncService();

  bool get isInitialized => _db != null;

  Future<void> init(String userId) async {
    if (_userId == userId && _db != null) return;
    _userId = userId;

    final boxName = 'transactions_$userId';
    final box = await Hive.openBox<TransactionModel>(boxName);
    _db = DatabaseService(box);

    // Initial Sync Logic
    if (box.isEmpty) {
      await _restoreFromCloud(userId, box);
    } else {
      _syncInBackground(userId, box);
    }
  }

  Future<void> _restoreFromCloud(
    String userId,
    Box<TransactionModel> box,
  ) async {
    try {
      if (await _syncService.hasCloudData(userId)) {
        final cloudData = await _syncService.pullAllTransactions(userId);
        for (final tx in cloudData) {
          await box.add(tx);
        }
      }
    } catch (e) {
      debugPrint('TransactionRepository: Cloud restore failed: $e');
    }
  }

  void _syncInBackground(String userId, Box<TransactionModel> box) async {
    try {
      if (!(await _syncService.hasCloudData(userId))) {
        await _syncService.pushAllTransactions(userId, box.toMap());
      }
    } catch (e) {
      debugPrint('TransactionRepository: Background sync failed: $e');
    }
  }

  List<TransactionModel> getAll() {
    return _db?.getAllTransaction() ?? [];
  }

  Future<void> add(TransactionModel tx) async {
    if (_db == null) return;
    await _db!.addTransaction(tx);
    if (_userId != null && tx.key != null) {
      _syncService.pushTransaction(_userId!, tx.key as int, tx);
    }
  }

  Future<void> update(int key, TransactionModel tx) async {
    if (_db == null) return;
    await _db!.updateTransaction(key, tx);
    if (_userId != null) {
      _syncService.updateTransaction(_userId!, key, tx);
    }
  }

  Future<void> delete(int key) async {
    if (_db == null) return;
    await _db!.deleteTransaction(key);
    if (_userId != null) {
      _syncService.deleteTransaction(_userId!, key);
    }
  }

  Future<void> deleteBulk(List<int> keys) async {
    for (var key in keys) {
      await delete(key);
    }
  }

  void dispose() {
    _db = null;
    _userId = null;
  }
}
