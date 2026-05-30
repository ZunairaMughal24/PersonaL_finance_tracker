import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/core/enums/sync_status.dart';
import 'package:montage/core/utils/app_logger.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/services/database_services.dart';
import 'package:montage/core/constants/app_keys.dart';
import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/core/interfaces/i_firestore_sync_service.dart';

class TransactionRepository implements ITransactionRepository {
  final IFirestoreSyncService _syncService;
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  DatabaseService? _db;
  String? _userId;

  TransactionRepository({required IFirestoreSyncService syncService})
      : _syncService = syncService;

  @override
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  @override
  bool get isInitialized => _db != null;

  @override
  Future<void> init(String userId) async {
    if (_userId == userId && _db != null) return;
    _userId = userId;

    final boxName = AppKeys.transactions(userId);
    final box = await Hive.openBox<TransactionModel>(boxName);
    _db = DatabaseService(box);

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
      _syncStatusController.add(SyncStatus.syncing);
      if (await _syncService.hasCloudData(userId)) {
        final cloudData = await _syncService.pullAllTransactions(userId);
        for (final tx in cloudData) {
          await box.add(TransactionModel.fromEntity(tx));
        }
      }
      _syncStatusController.add(SyncStatus.success);
    } catch (e, stackTrace) {
      _syncStatusController.add(SyncStatus.error);
      AppLogger.error('TransactionRepository: Cloud restore failed', e, stackTrace);
    }
  }

  void _syncInBackground(String userId, Box<TransactionModel> box) async {
    try {
      _syncStatusController.add(SyncStatus.syncing);
      final hasCloudData = await _syncService.hasCloudData(userId);
      if (!hasCloudData) {
        final localMap = <int, Transaction>{};
        for (final entry in box.toMap().entries) {
          localMap[entry.key as int] = entry.value.toEntity();
        }
        await _syncService.pushAllTransactions(userId, localMap);
        _syncStatusController.add(SyncStatus.success);
        return;
      }

      _syncStatusController.add(SyncStatus.success);
      AppLogger.info('TransactionRepository: Background sync completed');
    } catch (e, stackTrace) {
      _syncStatusController.add(SyncStatus.error);
      AppLogger.error('TransactionRepository: Background sync failed', e, stackTrace);
    }
  }

  void _pushToCloud(Future<void> Function() action) {
    _syncStatusController.add(SyncStatus.syncing);
    action().then((_) {
      _syncStatusController.add(SyncStatus.success);
    }).catchError((Object e, StackTrace st) {
      _syncStatusController.add(SyncStatus.error);
      AppLogger.error('TransactionRepository: Cloud push failed', e, st);
    });
  }

  @override
  List<Transaction> getAll() {
    return _db?.getAllTransaction() ?? [];
  }

  @override
  Future<void> add(Transaction tx) async {
    if (_db == null) return;
    final assignedId = await _db!.addTransaction(tx);
    if (_userId != null) {
      _pushToCloud(() => _syncService.pushTransaction(_userId!, assignedId, tx));
    }
  }

  @override
  Future<void> update(int id, Transaction tx) async {
    if (_db == null) return;
    await _db!.updateTransaction(id, tx);
    if (_userId != null) {
      _pushToCloud(() => _syncService.updateTransaction(_userId!, id, tx));
    }
  }

  @override
  Future<void> updateBulk(Map<int, Transaction> transactions) async {
    if (_db == null) return;
    await _db!.updateBulkTransactions(transactions);
    if (_userId != null) {
      _pushToCloud(() => _syncService.pushAllTransactions(_userId!, transactions));
    }
  }

  @override
  Future<void> delete(int id) async {
    if (_db == null) return;
    await _db!.deleteTransaction(id);
    if (_userId != null) {
      _pushToCloud(() => _syncService.deleteTransaction(_userId!, id));
    }
  }

  @override
  Future<void> deleteBulk(List<int> ids) async {
    for (var id in ids) {
      await delete(id);
    }
  }

  @override
  void dispose() {
    _syncStatusController.close();
    _db = null;
    _userId = null;
  }
}
