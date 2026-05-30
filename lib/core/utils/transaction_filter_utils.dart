import 'package:flutter/material.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/core/utils/date_formatter.dart';

class TransactionFilterUtils {
  static List<Transaction> filter({
    required List<Transaction> transactions,
    String query = "",
    DateTimeRange? dateRange,
    String? category,
    bool? isIncome,
  }) {
    return transactions.where((tx) {
      final search = query.trim().toLowerCase();
      bool matchesSearch = true;
      if (search.isNotEmpty) {
        matchesSearch =
            tx.title.toLowerCase().contains(search) ||
            tx.category.toLowerCase().contains(search);
      }

      bool matchesDate = true;
      if (dateRange != null) {
        final txDate = DateUtilsCustom.parseDate(tx.date);
        if (txDate == null) {
          matchesDate = false;
        } else {
          matchesDate =
              txDate.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
              txDate.isBefore(dateRange.end.add(const Duration(days: 1)));
        }
      }

      bool matchesCategory = true;
      if (category != null && category != 'All') {
        matchesCategory = tx.category == category;
      }

      final matchesType = isIncome == null || tx.isIncome == isIncome;

      return matchesSearch && matchesDate && matchesCategory && matchesType;
    }).toList();
  }

  static void sortByDate(List<Transaction> transactions, {bool descending = true}) {
    transactions.sort((a, b) {
      final dateA =
          DateUtilsCustom.parseDate(a.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB =
          DateUtilsCustom.parseDate(b.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return descending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
  }
}
