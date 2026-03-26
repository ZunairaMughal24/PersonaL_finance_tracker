import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:montage/models/transaction_model.dart';

/// Service for handling offline-first cloud synchronization between Hive and Firestore.
class FirestoreSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //References
  CollectionReference<Map<String, dynamic>> _txCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('transactions');

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('settings')
      .doc('user_prefs');

  DocumentReference<Map<String, dynamic>> _categoriesDoc(String uid) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('custom_categories');

  //Transaction Sync (Push)
  Future<void> pushTransaction(String uid, int key, TransactionModel tx) async {
    try {
      await _txCollection(uid).doc(key.toString()).set(tx.toMap());
    } catch (e) {
      debugPrint('FirestoreSyncService: push failed – $e');
    }
  }

  Future<void> updateTransaction(
    String uid,
    int key,
    TransactionModel tx,
  ) async {
    try {
      await _txCollection(uid).doc(key.toString()).set(tx.toMap());
    } catch (e) {
      debugPrint('FirestoreSyncService: update failed – $e');
    }
  }

  Future<void> deleteTransaction(String uid, int key) async {
    try {
      await _txCollection(uid).doc(key.toString()).delete();
    } catch (e) {
      debugPrint('FirestoreSyncService: delete failed – $e');
    }
  }

  //Transaction Sync (Pull)
  Future<List<TransactionModel>> pullAllTransactions(String uid) async {
    try {
      final snapshot = await _txCollection(uid).get();
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('FirestoreSyncService: pull failed – $e');
      return [];
    }
  }

  Future<void> pushAllTransactions(
    String uid,
    Map<dynamic, TransactionModel> entries,
  ) async {
    try {
      final batch = _firestore.batch();
      for (final entry in entries.entries) {
        batch.set(
          _txCollection(uid).doc(entry.key.toString()),
          entry.value.toMap(),
        );
      }
      await batch.commit();
    } catch (e) {
      debugPrint('FirestoreSyncService: pushAll failed – $e');
    }
  }

  //Settings Sync
  Future<void> pushSettings(String uid, Map<String, dynamic> settings) async {
    try {
      await _settingsDoc(uid).set(settings);
    } catch (e) {
      debugPrint('FirestoreSyncService: pushSettings failed – $e');
    }
  }

  Future<Map<String, dynamic>?> pullSettings(String uid) async {
    try {
      final doc = await _settingsDoc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint('FirestoreSyncService: pullSettings failed – $e');
      return null;
    }
  }

  //Custom Categories Sync
  Future<void> pushCategories(String uid, Map<String, dynamic> data) async {
    try {
      await _categoriesDoc(uid).set(data);
    } catch (e) {
      debugPrint('FirestoreSyncService: pushCategories failed – $e');
    }
  }

  Future<Map<String, dynamic>?> pullCategories(String uid) async {
    try {
      final doc = await _categoriesDoc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint('FirestoreSyncService: pullCategories failed – $e');
      return null;
    }
  }

  //Helper Methods
  Future<bool> hasCloudData(String uid) async {
    try {
      final snapshot = await _txCollection(uid).limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('FirestoreSyncService: hasCloudData check failed – $e');
      return false;
    }
  }
}
