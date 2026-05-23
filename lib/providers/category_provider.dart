import 'package:flutter/material.dart';
import 'package:montage/models/category_model.dart';
import 'package:montage/core/utils/category_utils.dart';
import 'package:montage/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  late CategoryRepository _repository;
  List<CustomCategory> _customCategories = [];

  List<CustomCategory> get customCategories => _customCategories;

  CategoryProvider({CategoryRepository? repository}) {
    if (repository != null) {
      _repository = repository;
    }
  }

  void updateRepository(CategoryRepository repository) {
    _repository = repository;
  }

  void updateUser(String? uid) async {
    if (uid == null) {
      _customCategories = [];
      notifyListeners();
      return;
    }

    await _repository.init(uid);
    _customCategories = _repository.getAllLocal();
    notifyListeners();

    final cloud = await _repository.pullFromCloud();
    if (cloud.isNotEmpty) {
      _customCategories = cloud;
      await _repository.saveLocal(_customCategories);
      notifyListeners();
    }
  }

  void _syncToFirestore() {
    _repository.syncToCloud(_customCategories);
  }

  List<Map<String, dynamic>> getMergedCategories(bool isIncome) {
    final List<Map<String, dynamic>> staticCats = isIncome
        ? CategoryUtils.incomeCategories
        : CategoryUtils.expenseCategories;

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

    List<Map<String, dynamic>> combined = List<Map<String, dynamic>>.from(
      staticCats,
    );

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
    await _repository.saveLocal(_customCategories);
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
      await _repository.saveLocal(_customCategories);
      notifyListeners();
      _syncToFirestore();
    }
  }

  Future<void> deleteCustomCategory(String name, bool isIncome) async {
    _customCategories.removeWhere(
      (c) => c.name == name && c.isIncome == isIncome,
    );
    await _repository.saveLocal(_customCategories);
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

  CustomCategory? findByName(String name) {
    try {
      return _customCategories.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  IconData getIconForCategory(String category) {
    final allStatic = [
      ...CategoryUtils.expenseCategories,
      ...CategoryUtils.incomeCategories,
    ];
    for (final cat in allStatic) {
      if ((cat['name'] as String).toLowerCase() == category.toLowerCase())
        return cat['icon'] as IconData;
    }
    final custom = findByName(category);
    return custom?.icon ?? Icons.category_rounded;
  }

  Color getCategoryColor(String category) {
    final allStatic = [
      ...CategoryUtils.expenseCategories,
      ...CategoryUtils.incomeCategories,
    ];
    for (final cat in allStatic) {
      if ((cat['name'] as String).toLowerCase() == category.toLowerCase())
        return cat['color'] as Color;
    }
    final custom = findByName(category);
    return custom?.color ?? const Color(0xFFB0B8D4);
  }
}
