import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_finance_tracker/config/router.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/core/theme/app_theme.dart';
import 'package:personal_finance_tracker/firebase_options.dart';
import 'package:personal_finance_tracker/models/transaction_model.dart';
import 'package:personal_finance_tracker/providers/transaction_provider.dart';
import 'package:personal_finance_tracker/providers/user_settings_provider.dart';
import 'package:personal_finance_tracker/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _setPortraitMode();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  await Hive.openBox<TransactionModel>('transactions');

  final userSettingsProvider = UserSettingsProvider();

  final authProvider = AuthProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => userSettingsProvider),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: MyApp(authProvider: authProvider),
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
  final AuthProvider authProvider;
  late final GoRouter _router = createRouter(authProvider);
  MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Finance Tracker',
      theme: AppTheme.darkTheme,
    );
  }
}
