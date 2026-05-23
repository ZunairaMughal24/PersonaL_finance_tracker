import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/models/category_model.dart';
import 'package:montage/services/firestore_sync_service.dart';

class CategoryRepository {
  final FirestoreSyncService _syncService;
  Box? _box;
  String? _userId;

  CategoryRepository({FirestoreSyncService? syncService})
    : _syncService = syncService ?? FirestoreSyncService();

  Future<void> init(String userId) async {
    if (_userId == userId && _box != null) return;
    _userId = userId;
    _box = await Hive.openBox('custom_categories_$userId');
  }

  List<CustomCategory> getAllLocal() {
    if (_box == null) return [];
    List<CustomCategory> cats = [];
    for (final value in _box!.values) {
      try {
        if (value is Map) {
          cats.add(CustomCategory.fromMap(Map<dynamic, dynamic>.from(value)));
        }
      } catch (e) {
        debugPrint('CategoryRepository: legacy data error');
      }
    }
    return cats;
  }

  Future<void> saveLocal(List<CustomCategory> categories) async {
    if (_box == null) return;
    await _box!.clear();
    for (var cat in categories) {
      await _box!.add(cat.toMap());
    }
  }

  Future<void> syncToCloud(List<CustomCategory> categories) async {
    if (_userId != null) {
      await _syncService.pushCategories(_userId!, {
        'categories': categories.map((c) => c.toMap()).toList(),
      });
    }
  }

  Future<List<CustomCategory>> pullFromCloud() async {
    if (_userId == null) return [];
    final data = await _syncService.pullCategories(_userId!);
    if (data != null && data['categories'] != null) {
      final List<dynamic> list = data['categories'];
      return list
          .map((c) => CustomCategory.fromMap(Map<String, dynamic>.from(c)))
          .toList();
    }
    return [];
  }

  void dispose() {
    _box?.close();
    _box = null;
    _userId = null;
  }
}
