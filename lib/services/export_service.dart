import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/core/utils/date_formatter.dart';

class ExportService {
  static String _getPeriodText(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return "All Time";
    final dates = transactions
        .map((t) => DateUtilsCustom.parseDate(t.date))
        .whereType<DateTime>()
        .toList();
    if (dates.isEmpty) return "All Time";
    dates.sort();
    final start = DateFormat('MMMM dd, yyyy').format(dates.first);
    final end = DateFormat('MMMM dd, yyyy').format(dates.last);
    if (start == end) return start;
    return "$start - $end";
  }

  static Future<void> exportToCSV(
    List<TransactionModel> transactions,
    String userName,
  ) async {
    List<List<dynamic>> rows = [];

    // Header Info
    rows.add(["Montage Financial Report"]);
    rows.add(["User:", userName]);
    rows.add(["Period:", _getPeriodText(transactions)]);
    rows.add([]);

    // Data Header
    rows.add(["Date", "Description", "Category", "Type", "Amount"]);

    for (var tx in transactions) {
      final date = DateUtilsCustom.parseDate(tx.date) ?? DateTime.now();
      rows.add([
        DateFormat('MMM dd, yyyy').format(date),
        tx.title,
        tx.category,
        tx.isIncome ? "Income" : "Expense",
        tx.amount,
      ]);
    }

    String csvContent = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path =
        "${directory.path}/montage_transactions_${DateTime.now().millisecondsSinceEpoch}.csv";
    final file = File(path);
    await file.writeAsString(csvContent);

    await Share.shareXFiles([
      XFile(path),
    ], text: 'My Transactions Export (CSV)');
  }

  static Future<void> exportToPDF(
    List<TransactionModel> transactions,
    String currency,
    String userName,
  ) async {
    final pdf = pw.Document();
    final periodText = _getPeriodText(transactions);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Montage - $userName Financial Report",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  "Report Period: $periodText",
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: [
              "Date",
              "Description",
              "Category",
              "Type",
              "Amount ($currency)",
            ],
            data: transactions.map((tx) {
              final date = DateUtilsCustom.parseDate(tx.date) ?? DateTime.now();
              return [
                DateFormat('MMM dd, yyyy').format(date),
                tx.title,
                tx.category,
                tx.isIncome ? "Income" : "Expense",
                tx.amount.toStringAsFixed(2),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.blueGrey800,
            ),
            cellHeight: 30,
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(2),
            },
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerRight,
            },
          ),
        ],
      ),
    );

    final directory = await getTemporaryDirectory();
    final path =
        "${directory.path}/montage_report_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([
      XFile(path),
    ], text: 'My Transactions Report (PDF)');
  }
}
