import 'package:flutter_test/flutter_test.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/services/finance_service.dart';
import 'package:montage/core/utils/date_formatter.dart';

void main() {
  group('FinanceService Tests', () {
    final List<TransactionModel> transactions = [
      TransactionModel(
        amount: 100.0,
        title: 'Salary',
        category: 'Work',
        date: '2024-01-01',
        isIncome: true,
      ),
      TransactionModel(
        amount: 50.0,
        title: 'Groceries',
        category: 'Food',
        date: '2024-01-02',
        isIncome: false,
      ),
      TransactionModel(
        amount: 30.0,
        title: 'Utilities',
        category: 'Bills',
        date: '2024-01-03',
        isIncome: false,
      ),
    ];

    test('calculateTotalIncome handles mixed transactions', () {
      expect(FinanceService.calculateTotalIncome(transactions), 100.0);
    });

    test('calculateTotalExpense handles mixed transactions', () {
      expect(FinanceService.calculateTotalExpense(transactions), 80.0);
    });

    test('calculateBalance correctly subtracts expenses', () {
      expect(FinanceService.calculateBalance(100, 80), 20.0);
    });

    test('getSpendingSummary aggregates categories correctly', () {
      final summary = FinanceService.getSpendingSummary(transactions);
      expect(summary.categoryTotals['Food'], 50.0);
      expect(summary.categoryTotals['Bills'], 30.0);
      expect(summary.grandTotal, 80.0);
    });
  });

  group('DateUtilsCustom Tests', () {
    test('parseDate returns null for invalid formats', () {
      expect(DateUtilsCustom.parseDate('invalid-date'), isNull);
      expect(DateUtilsCustom.parseDate(''), isNull);
    });

    test('parseDate correctly parses ISO format', () {
      final date = DateUtilsCustom.parseDate('2024-03-26');
      expect(date, isNotNull);
      expect(date?.year, 2024);
      expect(date?.month, 3);
      expect(date?.day, 26);
    });
  });
}
