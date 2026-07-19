import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/services/media_service.dart';
import 'package:expressions/expressions.dart';

class TransactionFormViewModel extends ChangeNotifier {
  final MediaService _mediaService = MediaService();

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

  bool get hasActiveExpression =>
      RegExp(r'[+\-*/]').hasMatch(_amountExpression) &&
      _amountExpression != '-';

  TransactionFormViewModel({Transaction? transaction}) {
    if (transaction != null) {
      _loadTransaction(transaction);
    } else {
      _isIncome = false;
    }
  }

  void _loadTransaction(Transaction tx) {
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
    _selectedDate = DateUtilsCustom.parseDate(tx.date) ?? DateTime.now();
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

  bool _isSavingImage = false;

  Future<void> handleImageSelected(String path, String name) async {
    if (_isSavingImage) return;
    _isSavingImage = true;
    try {
      final newPath = await _mediaService.saveImageLocally(path, name);
      if (newPath != null) setImagePath(newPath);
    } finally {
      _isSavingImage = false;
    }
  }

  Future<void> pickAndSetImage(ImageSource source) async {
    final XFile? image = await _mediaService.pickImage(source);
    if (image != null) {
      await handleImageSelected(image.path, image.name);
    }
  }

  void onKeyPressed(String value) {
    if (RegExp(r'[0-9.]').hasMatch(value)) {
      if (_amountExpression == "0") {
        _amountExpression = value == "." ? "0." : value;
      } else {
        if (value == "." && _amountExpression.contains(".")) {
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
        _amountExpression =
            _amountExpression.substring(0, _amountExpression.length - 1) + value;
      }
    }
    _evaluateExpression();
    notifyListeners();
  }

  void _evaluateExpression() {
    try {
      _amountResult = _calculate(_amountExpression);
    } catch (_) {}
  }

  String _calculate(String expression) {
    if (expression.isEmpty || expression == "0" || expression == "-") return "0";
    try {
      String expStr = expression;
      if (RegExp(r'[+\-*/]$').hasMatch(expStr)) {
        expStr = expStr.substring(0, expStr.length - 1);
      }
      final Expression parsedExpression = Expression.parse(expStr);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(parsedExpression, {});
      if (result == null) return "0";
      String resultStr = result.toString();
      if (result is double) {
        if (result.isInfinite || result.isNaN) return "0";
        if (resultStr.endsWith(".0")) {
          resultStr = resultStr.substring(0, resultStr.length - 2);
        } else {
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
      return _amountResult;
    }
  }

  void onBackspace() {
    if (_amountExpression.length > 1) {
      _amountExpression = _amountExpression.substring(0, _amountExpression.length - 1);
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

  void onEqualPressed() {
    _evaluateExpression();
    _amountExpression = _amountResult;
    notifyListeners();
  }

  String? validate() {
    if (_selectedCategory.isEmpty) return "Please select a category";
    final amountVal = double.tryParse(_amountResult);
    if (amountVal == null || amountVal <= 0) return "Please enter a valid amount";
    return null;
  }

  Transaction buildTransaction() {
    return Transaction(
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
    required TransactionProvider provider,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final error = validate();
    if (error != null) {
      onError(error);
      return;
    }
    await provider.addTransaction(buildTransaction());
    onSuccess();
  }

  Future<void> updateTransaction({
    required TransactionProvider provider,
    required int id,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final error = validate();
    if (error != null) {
      onError(error);
      return;
    }
    await provider.updateTransaction(id, buildTransaction());
    onSuccess();
  }
}
