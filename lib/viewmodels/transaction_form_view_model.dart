import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/core/utils/date_formatter.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';

class TransactionFormViewModel extends ChangeNotifier {
  bool _isIncome = true;
  DateTime _selectedDate = DateTime.now();
  String _amount = "0";
  String _selectedCategory = "";
  String _title = "";
  String _selectedCurrency = 'USD';
  bool _showKeypad = false;

  bool get isIncome => _isIncome;
  DateTime get selectedDate => _selectedDate;
  String get amount => _amount;
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
    _amount = tx.amount.toString();
    if (_amount.endsWith(".0")) {
      _amount = _amount.substring(0, _amount.length - 2);
    }
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
    if (_amount == "0") {
      if (value == ".") {
        _amount = "0.";
      } else {
        _amount = value;
      }
    } else {
      if (value == "." && _amount.contains(".")) return;
      if (_amount.length < 10) {
        _amount += value;
      }
    }
    notifyListeners();
  }

  void onBackspace() {
    if (_amount.length > 1) {
      _amount = _amount.substring(0, _amount.length - 1);
    } else {
      _amount = "0";
    }
    notifyListeners();
  }

  void onClear() {
    _amount = "0";
    notifyListeners();
  }

  String? validate() {
    if (_title.isEmpty) return "Please enter a title";
    if (_selectedCategory.isEmpty) return "Please select a category";
    final amountVal = double.tryParse(_amount);
    if (amountVal == null || amountVal <= 0)
      return "Please enter a valid amount";
    return null;
  }

  TransactionModel getTransactionModel() {
    return TransactionModel(
      title: _title.trim(),
      amount: double.parse(_amount),
      isIncome: _isIncome,
      date: DateUtilsCustom.formatDate(_selectedDate),
      category: _selectedCategory,
      currency: _selectedCurrency,
    );
  }
}
