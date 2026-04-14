import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:montage/models/category_model.dart';
import 'package:montage/services/firestore_sync_service.dart';
import 'package:montage/core/utils/category_utils.dart';

class CategoryProvider with ChangeNotifier {
  final FirestoreSyncService _syncService = FirestoreSyncService();
  String? _userId;
  Box? _box;
  List<CustomCategory> _customCategories = [];

  List<CustomCategory> get customCategories => _customCategories;

  void updateUser(String? uid) async {
    _userId = uid;
    if (uid == null) {
      _box = null;
      _customCategories = [];
      notifyListeners();
      return;
    }

    _box = await Hive.openBox('custom_categories_$uid');
    _loadFromBox();
    notifyListeners();

    final cloudData = await _syncService.pullCategories(uid);
    if (cloudData != null && cloudData['categories'] != null) {
      final List<dynamic> catList = cloudData['categories'];
      _customCategories = catList
          .map((c) => CustomCategory.fromMap(Map<String, dynamic>.from(c)))
          .toList();
      await _saveToBox();
      notifyListeners();
    }
  }

  void _loadFromBox() {
    if (_box == null) return;
    _customCategories = [];
    for (final value in _box!.values) {
      try {
        if (value is Map) {
          _customCategories.add(
            CustomCategory.fromMap(Map<dynamic, dynamic>.from(value)),
          );
        }
      } catch (e) {
        debugPrint('CategoryProvider: skipping legacy data');
      }
    }
  }

  Future<void> _saveToBox() async {
    if (_box == null) return;
    await _box!.clear();
    for (var cat in _customCategories) {
      await _box!.add(cat.toMap());
    }
  }

  void _syncToFirestore() {
    if (_userId != null) {
      _syncService.pushCategories(_userId!, {
        'categories': _customCategories.map((c) => c.toMap()).toList(),
      });
    }
  }

  List<Map<String, dynamic>> getMergedCategories(bool isIncome) {
    // Get Static Categories
    final List<Map<String, dynamic>> staticCats = isIncome
        ? CategoryUtils.incomeCategories
        : CategoryUtils.expenseCategories;

    // Map Custom Categories to the UI format
    final List<Map<String, dynamic>> userCats = _customCategories
        .where((c) => c.isIncome == isIncome)
        .map(
          (c) => {
            'name': c.name,
            'icon': IconData(c.iconCodePoint, fontFamily: 'MaterialIcons'),
            'color': c.color,
          },
        )
        .toList();

    // Combine and ensure 'Other' is last
    List<Map<String, dynamic>> combined = List<Map<String, dynamic>>.from(
      staticCats,
    );

    // Find 'Other' if it exists to preserve its position at the end
    final otherIndex = combined.indexWhere((c) => c['name'] == "Other");
    Map<String, dynamic>? otherCat;
    if (otherIndex != -1) {
      otherCat = combined.removeAt(otherIndex);
    }

    combined.addAll(userCats);

    if (otherCat != null) {
      combined.add(otherCat);
    } else {
      combined.add({
        'name': "Other",
        'icon': Icons.more_horiz_rounded,
        'color': const Color(0xFFB0B8D4),
      });
    }

    return combined;
  }

  String? validateCategory(String name, bool isIncome, {String? excludeName}) {
    final normalized = name.trim().toLowerCase();
    if (normalized.isEmpty) return "Name cannot be empty";

    final staticCats = isIncome
        ? ["salary", "business", "gifts", "investment", "other"]
        : [
            "food",
            "transport",
            "rent",
            "health",
            "shopping",
            "entertainment",
            "other",
          ];

    if (staticCats.contains(normalized)) return "Existing default category";

    final exists = _customCategories.any(
      (c) =>
          c.isIncome == isIncome &&
          c.name.toLowerCase() == normalized &&
          c.name.toLowerCase() != excludeName?.toLowerCase(),
    );

    if (exists) return "Category already exists";
    return null;
  }

  Future<void> addCustomCategory(
    String name,
    IconData icon,
    bool isIncome, {
    Color? color,
  }) async {
    _customCategories.add(
      CustomCategory(
        name: name.trim(),
        iconCodePoint: icon.codePoint,
        isIncome: isIncome,
        colorValue: color?.toARGB32(),
      ),
    );
    await _saveToBox();
    notifyListeners();
    _syncToFirestore();
  }

  Future<void> updateCustomCategory(
    String oldName,
    String newName,
    IconData icon,
    bool isIncome, {
    Color? color,
  }) async {
    final index = _customCategories.indexWhere(
      (c) => c.name == oldName && c.isIncome == isIncome,
    );
    if (index != -1) {
      _customCategories[index] = CustomCategory(
        name: newName.trim(),
        iconCodePoint: icon.codePoint,
        isIncome: isIncome,
        colorValue: color?.toARGB32(),
      );
      await _saveToBox();
      notifyListeners();
      _syncToFirestore();
    }
  }

  Future<void> deleteCustomCategory(String name, bool isIncome) async {
    _customCategories.removeWhere(
      (c) => c.name == name && c.isIncome == isIncome,
    );
    await _saveToBox();
    notifyListeners();
    _syncToFirestore();
  }

  CustomCategory? getCategoryByName(String name, bool isIncome) {
    try {
      return _customCategories.firstWhere(
        (c) =>
            c.name.toLowerCase() == name.toLowerCase() &&
            c.isIncome == isIncome,
      );
    } catch (_) {
      return null;
    }
  }

  /// Look up a custom category by name only (any type).

  CustomCategory? findByName(String name) {
    try {
      return _customCategories.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get the icon for a category, checking custom categories first.
  IconData getIconForCategory(String category) {
    // First check static categories
    final allStatic = [
      ...CategoryUtils.expenseCategories,
      ...CategoryUtils.incomeCategories,
    ];
    for (final cat in allStatic) {
      if ((cat['name'] as String).toLowerCase() == category.toLowerCase()) {
        return cat['icon'] as IconData;
      }
    }
    // Then check custom categories
    final custom = findByName(category);
    if (custom != null) {
      return custom.icon;
    }
    return Icons.category_rounded;
  }

  /// Get the color for a category, checking custom categories first.
  Color getCategoryColor(String category) {
    // First check static categories
    final allStatic = [
      ...CategoryUtils.expenseCategories,
      ...CategoryUtils.incomeCategories,
    ];
    for (final cat in allStatic) {
      if ((cat['name'] as String).toLowerCase() == category.toLowerCase()) {
        return cat['color'] as Color;
      }
    }
    // Then check custom categories
    final custom = findByName(category);
    if (custom != null) {
      return custom.color;
    }
    return const Color(0xFFB0B8D4);
  }
}
