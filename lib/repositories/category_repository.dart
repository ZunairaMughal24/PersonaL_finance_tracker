import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/models/category_model.dart';
import 'package:montage/services/firestore_sync_service.dart';
import 'package:montage/core/constants/app_keys.dart';
import 'package:montage/core/interfaces/i_category_repository.dart';
import 'package:montage/core/interfaces/i_firestore_sync_service.dart';

class CategoryRepository implements ICategoryRepository {
  final IFirestoreSyncService _syncService;
  Box? _box;
  String? _userId;

  CategoryRepository({IFirestoreSyncService? syncService})
    : _syncService = syncService ?? FirestoreSyncService();

  @override
  Future<void> init(String userId) async {
    if (_userId == userId && _box != null) return;
    _userId = userId;
    _box = await Hive.openBox(AppKeys.customCategories(userId));
  }

  @override
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

  @override
  Future<void> saveLocal(List<CustomCategory> categories) async {
    if (_box == null) return;
    await _box!.clear();
    for (var cat in categories) {
      await _box!.add(cat.toMap());
    }
  }

  @override
  Future<void> syncToCloud(List<CustomCategory> categories) async {
    if (_userId != null) {
      await _syncService.pushCategories(_userId!, {
        'categories': categories.map((c) => c.toMap()).toList(),
      });
    }
  }

  @override
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

  @override
  void dispose() {
    _box?.close();
    _box = null;
    _userId = null;
  }
}
