import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/services/database_services.dart';
import 'package:montage/services/firestore_sync_service.dart';
import 'package:montage/core/constants/app_keys.dart';
import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/core/interfaces/i_firestore_sync_service.dart';

class TransactionRepository implements ITransactionRepository {
  final IFirestoreSyncService _syncService;
  DatabaseService? _db;
  String? _userId;

  TransactionRepository({IFirestoreSyncService? syncService})
    : _syncService = syncService ?? FirestoreSyncService();

  @override
  bool get isInitialized => _db != null;

  @override
  Future<void> init(String userId) async {
    if (_userId == userId && _db != null) return;
    _userId = userId;

    final boxName = AppKeys.transactions(userId);
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

  @override
  List<TransactionModel> getAll() {
    return _db?.getAllTransaction() ?? [];
  }

  @override
  Future<void> add(TransactionModel tx) async {
    if (_db == null) return;
    await _db!.addTransaction(tx);
    if (_userId != null && tx.key != null) {
      _syncService.pushTransaction(_userId!, tx.key as int, tx);
    }
  }

  @override
  Future<void> update(int key, TransactionModel tx) async {
    if (_db == null) return;
    await _db!.updateTransaction(key, tx);
    if (_userId != null) {
      _syncService.updateTransaction(_userId!, key, tx);
    }
  }

  @override
  Future<void> delete(int key) async {
    if (_db == null) return;
    await _db!.deleteTransaction(key);
    if (_userId != null) {
      _syncService.deleteTransaction(_userId!, key);
    }
  }

  @override
  Future<void> deleteBulk(List<int> keys) async {
    for (var key in keys) {
      await delete(key);
    }
  }

  @override
  void dispose() {
    _db = null;
    _userId = null;
  }
}
