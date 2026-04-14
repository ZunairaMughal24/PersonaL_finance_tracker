import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/widgets/image_source_sheet.dart';
import 'package:expressions/expressions.dart';
import 'package:montage/widgets/transaction/category_action_sheet.dart';
import 'package:montage/widgets/transaction/category_editor_dialog.dart';

class TransactionFormViewModel extends ChangeNotifier {
  bool _isIncome = true;
  DateTime _selectedDate = DateTime.now();
  String _amountExpression = "0";
  String _amountResult = "0";
  String _selectedCategory = "";
  String _title = "";
  String _selectedCurrency = 'USD';
  bool _showKeypad = false;
  String? _imagePath;

  bool get isIncome => _isIncome;
  DateTime get selectedDate => _selectedDate;
  String get amountExpression => _amountExpression;
  String get amountResult => _amountResult;
  String get selectedCategory => _selectedCategory;
  String get title => _title;
  String get selectedCurrency => _selectedCurrency;
  bool get showKeypad => _showKeypad;
  String? get imagePath => _imagePath;

  /// True when the expression contains arithmetic operators (pending calculation).
  bool get hasActiveExpression =>
      RegExp(r'[+\-*/]').hasMatch(_amountExpression) &&
      _amountExpression != '-';

  TransactionFormViewModel({TransactionModel? transaction}) {
    if (transaction != null) {
      _loadTransaction(transaction);
    } else {
      _isIncome = false;
    }
  }

  void _loadTransaction(TransactionModel tx) {
    _title = tx.title;
    _isIncome = tx.isIncome;
    _amountResult = tx.amount.toString();
    if (_amountResult.endsWith(".0")) {
      _amountResult = _amountResult.substring(0, _amountResult.length - 2);
    }
    _amountExpression = _amountResult;
    _selectedCategory = tx.category;
    _selectedCurrency = tx.currency;
    _imagePath = tx.imagePath;

    _selectedDate = DateTime.now();
    try {
      final parts = tx.date.split('/');
      if (parts.length == 3) {
        _selectedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setCurrency(String value) {
    _selectedCurrency = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  void toggleType(bool value) {
    _isIncome = value;
    _selectedCategory = "";
    notifyListeners();
  }

  void toggleKeypad(bool show) {
    _showKeypad = show;
    notifyListeners();
  }

  void setImagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

  bool _isPickingImage = false;

  Future<void> pickImage(BuildContext context) async {
    if (_isPickingImage) return;

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ImageSourceSheet(),
    );

    if (source != null) {
      _isPickingImage = true;
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final String name = image.name;
          final File file = File(image.path);
          final File newImage = await file.copy('${directory.path}/$name');
          setImagePath(newImage.path);
        }
      } finally {
        _isPickingImage = false;
      }
    }
  }

  void onKeyPressed(String value) {
    if (RegExp(r'[0-9.]').hasMatch(value)) {
      if (_amountExpression == "0") {
        if (value == ".") {
          _amountExpression = "0.";
        } else {
          _amountExpression = value;
        }
      } else {
        if (value == "." && _amountExpression.contains(".")) {
          // Check if the last number already has a dot
          final parts = _amountExpression.split(RegExp(r'[+\-*/]'));
          if (parts.isNotEmpty && parts.last.contains(".")) return;
        }

        _amountExpression += value;
      }
    } else if (RegExp(r'[+\-*/]').hasMatch(value)) {
      if (_amountExpression == "0" && value == "-") {
        _amountExpression = "-";
      } else if (_amountExpression != "-" &&
          !RegExp(r'[+\-*/]$').hasMatch(_amountExpression)) {
        _amountExpression += value;
      } else if (RegExp(r'[+\-*/]$').hasMatch(_amountExpression)) {
        // Replace last operator
        _amountExpression =
            _amountExpression.substring(0, _amountExpression.length - 1) +
            value;
      }
    }

    _evaluateExpression();
    notifyListeners();
  }

  void _evaluateExpression() {
    try {
      _amountResult = _calculate(_amountExpression);
    } catch (_) {
      // Keep previous result if error
    }
  }

  String _calculate(String expression) {
    if (expression.isEmpty || expression == "0" || expression == "-") {
      return "0";
    }

    try {
      String expStr = expression;
      // Remove trailing operator for calculation
      if (RegExp(r'[+\-*/]$').hasMatch(expStr)) {
        expStr = expStr.substring(0, expStr.length - 1);
      }

      // Replace symbols for expressions package if necessary
      final Expression parsedExpression = Expression.parse(expStr);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(parsedExpression, {});

      if (result == null) return "0";

      String resultStr = result.toString();

      if (result is double) {
        if (result.isInfinite || result.isNaN) return "0";
        if (resultStr.endsWith(".0")) {
          resultStr = resultStr.substring(0, resultStr.length - 2);
        } else {
          // Limit to 2 decimal places for financial data
          resultStr = result.toStringAsFixed(2);
          if (resultStr.endsWith(".00")) {
            resultStr = resultStr.substring(0, resultStr.length - 3);
          } else if (resultStr.endsWith("0") && resultStr.contains(".")) {
            resultStr = resultStr.substring(0, resultStr.length - 1);
          }
        }
      }

      return resultStr;
    } catch (e) {
      debugPrint("Calculation error: $e");
      return _amountResult;
    }
  }

  void onBackspace() {
    if (_amountExpression.length > 1) {
      _amountExpression = _amountExpression.substring(
        0,
        _amountExpression.length - 1,
      );
    } else {
      _amountExpression = "0";
    }
    _evaluateExpression();
    notifyListeners();
  }

  void onClear() {
    _amountExpression = "0";
    _amountResult = "0";
    notifyListeners();
  }

  /// Evaluates the current expression and collapses it to the result.
  void onEqualPressed() {
    _evaluateExpression();
    _amountExpression = _amountResult;
    notifyListeners();
  }

  String? validate() {
    if (_selectedCategory.isEmpty) return "Please select a category";
    final amountVal = double.tryParse(_amountResult);
    if (amountVal == null || amountVal <= 0) {
      return "Please enter a valid amount";
    }
    return null;
  }

  TransactionModel getTransactionModel() {
    return TransactionModel(
      title: _title.trim(),
      amount: double.tryParse(_amountResult) ?? 0.0,
      isIncome: _isIncome,
      date: DateUtilsCustom.formatDate(_selectedDate),
      category: _selectedCategory,
      currency: _selectedCurrency,
      imagePath: _imagePath,
    );
  }

  Future<void> saveTransaction({
    required dynamic provider,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final error = validate();
    if (error != null) {
      onError(error);
      return;
    }

    await provider.addTransaction(getTransactionModel());
    onSuccess();
  }

  Future<void> updateTransaction({
    required dynamic provider,
    required int key,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final error = validate();
    if (error != null) {
      onError(error);
      return;
    }

    await provider.updateTransaction(key, getTransactionModel());
    onSuccess();
  }

  // ── CATEGORY MANAGEMENT LOGIC
  void handleCategoryAction({
    required BuildContext context,
    required String catName,
    required dynamic catProvider,
  }) {
    final customCat = catProvider.getCategoryByName(catName, _isIncome);
    if (customCat == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryActionSheet(
        categoryName: catName,
        onEdit: () {
          showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (context) => CategoryEditorDialog(
              isIncome: _isIncome,
              initialCategory: customCat,
              onSubmitted: (newName, newIcon, {Color? color}) {
                catProvider.updateCustomCategory(
                  catName,
                  newName,
                  newIcon,
                  _isIncome,
                  color: color,
                );
                if (_selectedCategory == catName) {
                  setCategory(newName);
                }
              },
            ),
          );
        },
        onDelete: () {
          catProvider.deleteCustomCategory(catName, _isIncome);
          if (_selectedCategory == catName) {
            setCategory("Other");
          }
        },
      ),
    );
  }
}
