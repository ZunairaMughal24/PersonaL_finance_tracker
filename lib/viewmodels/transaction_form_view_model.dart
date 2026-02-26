import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/utils/date_formatter.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';

class TransactionFormViewModel extends ChangeNotifier {
  bool _isIncome = true;
  DateTime _selectedDate = DateTime.now();
  String _amountExpression = "0";
  String _amountResult = "0";
  String _selectedCategory = "";
  String _title = "";
  String _selectedCurrency = 'USD';
  bool _showKeypad = false;

  bool get isIncome => _isIncome;
  DateTime get selectedDate => _selectedDate;
  String get amountExpression => _amountExpression;
  String get amountResult => _amountResult;
  String get selectedCategory => _selectedCategory;
  String get title => _title;
  String get selectedCurrency => _selectedCurrency;
  bool get showKeypad => _showKeypad;

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

  void onKeyPressed(String value) {
    if (RegExp(r'[0-9.]').hasMatch(value)) {
      if (_amountExpression == "0") {
        if (value == ".") {
          _amountExpression = "0.";
        } else {
          _amountExpression = value;
        }
      } else {
        if (value == "." && _amountExpression.endsWith(".")) return;

        final int digitCount = _amountExpression
            .replaceAll(RegExp(r'[^0-9]'), '')
            .length;
        if (digitCount >= 10 && RegExp(r'[0-9]').hasMatch(value)) return;

        _amountExpression += value;
      }
    } else if (RegExp(r'[+\-*/]').hasMatch(value)) {
      if (_amountExpression == "0" && value == "-") {
        _amountExpression = "-";
      } else if (!RegExp(r'[+\-*/]$').hasMatch(_amountExpression)) {
        _amountExpression += value;
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
    try {
      String exp = expression;
      if (RegExp(r'[+\-*/]$').hasMatch(exp)) {
        exp = exp.substring(0, exp.length - 1);
      }

      return exp;
    } catch (_) {
      return "0";
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

  String? validate() {
    if (_selectedCategory.isEmpty) return "Please select a category";
    final amountVal = double.tryParse(_amountResult);
    if (amountVal == null || amountVal <= 0)
      return "Please enter a valid amount";
    return null;
  }

  TransactionModel getTransactionModel() {
    return TransactionModel(
      title: _title.isEmpty ? "Note" : _title.trim(),
      amount: double.tryParse(_amountResult) ?? 0.0,
      isIncome: _isIncome,
      date: DateUtilsCustom.formatDate(_selectedDate),
      category: _selectedCategory,
      currency: _selectedCurrency,
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
}
