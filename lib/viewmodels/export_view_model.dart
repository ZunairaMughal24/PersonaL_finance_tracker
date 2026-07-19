import 'package:flutter/foundation.dart';
import 'package:montage/domain/entities/transaction.dart';
import 'package:montage/services/export_service.dart';

class ExportViewModel extends ChangeNotifier {
  Future<void> exportAsText(List<Transaction> transactions, String userName) {
    return ExportService.exportToText(transactions, userName);
  }

  Future<void> exportAsPdf(
    List<Transaction> transactions,
    String currency,
    String userName,
  ) {
    return ExportService.exportToPDF(transactions, currency, userName);
  }

  Future<void> exportAsCsv(List<Transaction> transactions, String userName) {
    return ExportService.exportToExcel(transactions, userName);
  }

  List<Transaction> resolveTransactions({
    required bool includeHistory,
    required List<Transaction> currentTransactions,
    required List<Transaction> allTransactions,
  }) {
    return includeHistory ? allTransactions : currentTransactions;
  }
}
