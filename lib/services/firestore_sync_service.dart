import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:montage/core/utils/app_logger.dart';
import 'package:montage/core/interfaces/i_firestore_sync_service.dart';
import 'package:montage/domain/entities/transaction.dart';

class FirestoreSyncService implements IFirestoreSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _txCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('transactions');

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) =>
      _firestore.collection('users').doc(uid).collection('settings').doc('user_prefs');

  DocumentReference<Map<String, dynamic>> _categoriesDoc(String uid) =>
      _firestore.collection('users').doc(uid).collection('settings').doc('custom_categories');

  @override
  Future<void> pushTransaction(String uid, int id, Transaction tx) async {
    try {
      await _txCollection(uid).doc(id.toString()).set(tx.toMap());
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService action failed', e, stackTrace);
    }
  }

  @override
  Future<void> updateTransaction(String uid, int id, Transaction tx) async {
    try {
      await _txCollection(uid).doc(id.toString()).set(tx.toMap());
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService operation failed', e, stackTrace);
    }
  }

  @override
  Future<void> deleteTransaction(String uid, int id) async {
    try {
      await _txCollection(uid).doc(id.toString()).delete();
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService delete failed', e, stackTrace);
    }
  }

  @override
  Future<List<Transaction>> pullAllTransactions(String uid) async {
    try {
      final snapshot = await _txCollection(uid).get();
      return snapshot.docs.map((doc) => Transaction.fromMap(doc.data())).toList();
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService pull failed', e, stackTrace);
      return [];
    }
  }

  @override
  Future<void> pushAllTransactions(String uid, Map<int, Transaction> entries) async {
    try {
      final batch = _firestore.batch();
      for (final entry in entries.entries) {
        batch.set(_txCollection(uid).doc(entry.key.toString()), entry.value.toMap());
      }
      await batch.commit();
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService pushAll failed', e, stackTrace);
    }
  }

  @override
  Future<void> pushSettings(String uid, Map<String, dynamic> settings) async {
    try {
      await _settingsDoc(uid).set(settings);
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService pushSettings failed', e, stackTrace);
    }
  }

  @override
  Future<Map<String, dynamic>?> pullSettings(String uid) async {
    try {
      final doc = await _settingsDoc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService pullSettings failed', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> pushCategories(String uid, Map<String, dynamic> data) async {
    try {
      await _categoriesDoc(uid).set(data);
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService pushCategories failed', e, stackTrace);
    }
  }

  @override
  Future<Map<String, dynamic>?> pullCategories(String uid) async {
    try {
      final doc = await _categoriesDoc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService pullCategories failed', e, stackTrace);
      return null;
    }
  }

  @override
  Future<bool> hasCloudData(String uid) async {
    try {
      final snapshot = await _txCollection(uid).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e, stackTrace) {
      AppLogger.error('FirestoreSyncService hasCloudData check failed', e, stackTrace);
      return false;
    }
  }
}
