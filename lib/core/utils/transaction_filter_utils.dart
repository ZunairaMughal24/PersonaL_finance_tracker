import 'package:flutter/material.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/core/utils/date_formatter.dart';

class TransactionFilterUtils {
  static List<TransactionModel> filter({
    required List<TransactionModel> transactions,
    String query = "",
    DateTimeRange? dateRange,
    String? category,
    bool? isIncome,
  }) {
    final filtered = transactions.where((tx) {
      // 1. Search Query
      final search = query.trim().toLowerCase();
      bool matchesSearch = true;
      if (search.isNotEmpty) {
        matchesSearch =
            tx.title.toLowerCase().contains(search) ||
            tx.category.toLowerCase().contains(search);
      }

      // 2. Date Range
      bool matchesDate = true;
      if (dateRange != null) {
        final txDate = DateUtilsCustom.parseDate(tx.date);
        if (txDate == null) {
          matchesDate = false;
        } else {
          // Add 1 day buffer to start/end to include the selected days
          matchesDate =
              txDate.isAfter(
                dateRange.start.subtract(const Duration(days: 1)),
              ) &&
              txDate.isBefore(dateRange.end.add(const Duration(days: 1)));
        }
      }

      // 3. Category
      bool matchesCategory = true;
      if (category != null && category != 'All') {
        matchesCategory = tx.category == category;
      }

      // 4. Income/Expense Type
      final matchesType = isIncome == null || tx.isIncome == isIncome;

      return matchesSearch && matchesDate && matchesCategory && matchesType;
    }).toList();

    return filtered;
  }

  static void sortByDate(
    List<TransactionModel> transactions, {
    bool descending = true,
  }) {
    transactions.sort((a, b) {
      final dateA =
          DateUtilsCustom.parseDate(a.date) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final dateB =
          DateUtilsCustom.parseDate(b.date) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return descending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
  }
}
