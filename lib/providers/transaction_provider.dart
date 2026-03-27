import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:montage/core/utils/date_formatter.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/models/spending_summary.dart';
import 'package:montage/models/trends_model.dart';
import 'package:montage/services/database_services.dart';
import 'package:montage/services/finance_service.dart';
import 'package:montage/services/firestore_sync_service.dart';
import 'package:montage/services/ai_service.dart';

class TransactionProvider extends ChangeNotifier {
  DatabaseService? db;
  late final AIService _aiService;
  final FirestoreSyncService _syncService = FirestoreSyncService();
  String? _userId;

  static const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  bool _isReady = false;
  List<TransactionModel> _transactions = [];
  String? _cachedInsights;
  Future<String?>? _insightsFuture;

  bool get isReady => _isReady;
  List<TransactionModel> get transactions => _transactions;
  Future<String?>? get insightsFuture => _insightsFuture;
  String? get cachedInsightsValue => _cachedInsights;

  TransactionProvider() {
    _aiService = AIService(_geminiApiKey);
  }

  void updateUser(String? userId) async {
    if (_userId == userId) return;

    _isReady = false;
    _userId = userId;
    if (userId == null) {
      _transactions = [];
      _cachedInsights = null;
      db = null;
      _isReady = true;
      notifyListeners();
      return;
    }

    /// 1. Open Hive Box
    final boxName = 'transactions_$userId';
    final box = await Hive.openBox<TransactionModel>(boxName);
    db = DatabaseService(box);

    // 2. Adaptive Loading Logic
    if (box.isNotEmpty) {
      // Repeat User: Load Local Immediately (Instant-First)
      _loadTransactions();
      _isReady = true;
      notifyListeners();
      
      // Perform background sync to stay up to date
      _performCloudSyncBackground(userId, box);
    } else {
      // Fresh Install: Wait for Cloud Sync (Skeleton-Wait)
      await _restoreTransactionsFromCloud(userId, box);
      _loadTransactions();
      _isReady = true;
      notifyListeners();
    }
  }

  Future<void> _restoreTransactionsFromCloud(String userId, Box<TransactionModel> box) async {
    try {
      final cloudHasData = await _syncService.hasCloudData(userId);
      if (cloudHasData) {
        final cloudTransactions = await _syncService.pullAllTransactions(userId);
        for (final tx in cloudTransactions) {
          await box.add(tx);
        }
        debugPrint('CloudSync: Restored transactions from Firestore.');
      }
    } catch (e) {
      debugPrint('CloudSync restore error: $e');
    }
  }

  Future<void> _performCloudSyncBackground(String userId, Box<TransactionModel> box) async {
    try {
      final cloudHasData = await _syncService.hasCloudData(userId);
      if (!cloudHasData && box.isNotEmpty) {
        // Local exists but cloud empty -> initial push
        await _syncService.pushAllTransactions(userId, box.toMap());
        debugPrint('CloudSync: Pushed local transactions to Firestore.');
      } else if (cloudHasData) {
        // Background update logic could go here if needed
      }
    } catch (e) {
      debugPrint('CloudSync background error: $e');
    }
  }

  void refreshInsights() {
    if (_transactions.isEmpty) {
      _insightsFuture = Future.value(null);
      return;
    }
    // ...
    _insightsFuture = _aiService
        .getSuggestionsAndAppreciation(_transactions)
        .then((val) {
          _cachedInsights = val;
          return val;
        });
    notifyListeners();
  }

  void _checkBalanceAndTriggerHaptic() {
    if (totalBalance < 0) {
      HapticFeedback.heavyImpact();
    }
  }

  void _invalidateInsights() {
    _cachedInsights = null;
    refreshInsights();
  }

  void _loadTransactions() {
    if (db == null) return;
    _transactions = db!.getAllTransaction();
    _invalidateInsights();
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    if (db == null) return;
    await db!.addTransaction(tx);
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();

    // Cloud sync: push the new transaction
    if (_userId != null && tx.key != null) {
      _syncService.pushTransaction(_userId!, tx.key as int, tx);
    }
  }

  Future<void> deleteTransaction(int key, int index) async {
    if (db == null) return;
    await db!.deleteTransaction(key);
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();

    // Cloud sync: delete the transaction
    if (_userId != null) {
      _syncService.deleteTransaction(_userId!, key);
    }
  }

  Future<void> updateTransaction(int key, TransactionModel updatedTx) async {
    if (db == null) return;
    await db!.updateTransaction(key, updatedTx);
    _loadTransactions();
    _checkBalanceAndTriggerHaptic();

    // Cloud sync: update the transaction
    if (_userId != null) {
      _syncService.updateTransaction(_userId!, key, updatedTx);
    }
  }

  double get totalIncome => FinanceService.calculateTotalIncome(_transactions);

  double get totalExpense =>
      FinanceService.calculateTotalExpense(_transactions);

  double get totalBalance =>
      FinanceService.calculateBalance(totalIncome, totalExpense);

  String get displayCurrency =>
      _transactions.isNotEmpty ? _transactions.last.currency : 'USD';

  SpendingSummary get spendingSummary =>
      FinanceService.getSpendingSummary(_transactions);

  List<TransactionModel> getTransactionsByType(bool isIncome) {
    return FinanceService.getTransactionsByType(_transactions, isIncome);
  }

  List<FinancialPeriodData> get weeklyFinancialSummary {
    final Map<String, FinancialPeriodData> dayMap = {
      'Mon': FinancialPeriodData(
        label: 'Mon',
        date: _getThisWeekDay(DateTime.monday),
        income: 0,
        expense: 0,
      ),
      'Tue': FinancialPeriodData(
        label: 'Tue',
        date: _getThisWeekDay(DateTime.tuesday),
        income: 0,
        expense: 0,
      ),
      'Wed': FinancialPeriodData(
        label: 'Wed',
        date: _getThisWeekDay(DateTime.wednesday),
        income: 0,
        expense: 0,
      ),
      'Thu': FinancialPeriodData(
        label: 'Thu',
        date: _getThisWeekDay(DateTime.thursday),
        income: 0,
        expense: 0,
      ),
      'Fri': FinancialPeriodData(
        label: 'Fri',
        date: _getThisWeekDay(DateTime.friday),
        income: 0,
        expense: 0,
      ),
      'Sat': FinancialPeriodData(
        label: 'Sat',
        date: _getThisWeekDay(DateTime.saturday),
        income: 0,
        expense: 0,
      ),
      'Sun': FinancialPeriodData(
        label: 'Sun',
        date: _getThisWeekDay(DateTime.sunday),
        income: 0,
        expense: 0,
      ),
    };

    for (var tx in _transactions) {
      DateTime? parsedDate = DateUtilsCustom.parseDate(tx.date);
      if (parsedDate == null) {
        continue;
      }
      String day = DateFormat('E').format(parsedDate);
      if (dayMap.containsKey(day)) {
        if (tx.isIncome) {
          dayMap[day] = dayMap[day]!.copyWith(
            income: dayMap[day]!.income + tx.amount,
          );
        } else {
          dayMap[day] = dayMap[day]!.copyWith(
            expense: dayMap[day]!.expense + tx.amount,
          );
        }
      }
    }
    return dayMap.values.toList().cast<FinancialPeriodData>();
  }

  DateTime _getThisWeekDay(int dayOfWeek) {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - dayOfWeek));
  }
}
