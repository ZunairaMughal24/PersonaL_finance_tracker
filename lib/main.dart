import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/theme/app_theme.dart';
import 'package:montage/firebase_options.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _setPortraitMode();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  await Hive.openBox<TransactionModel>('transactions');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
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
      routerConfig: createRouter(),
      title: 'MONTAGE',
      theme: AppTheme.darkTheme,
    );
  }
}
