import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:personal_finance_tracker/core/contants/appTheme.dart';


import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setPortraitMode();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  await Hive.openBox('transactionUpdates');
  await Hive.openBox<TransactionModel>('transactions');

  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: const MyApp(),
    ),
  );
}

void _setPortraitMode() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Finance Tracker',
      theme: AppTheme.lightTheme,
    );
  }
}
