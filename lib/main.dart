import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/themes/app_theme.dart';
import 'package:montage/firebase_options.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _setPortraitMode();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TransactionProvider>(
          create: (_) => TransactionProvider(),
          update: (_, auth, tx) => tx!..updateUser(auth.currentUser?.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserSettingsProvider>(
          create: (_) => UserSettingsProvider(),
          update: (_, auth, settings) => settings!
            ..updateUser(
              auth.currentUser?.uid,
              displayName: auth.currentUser?.displayName,
              email: auth.currentUser?.email,
            ),
        ),
        ChangeNotifierProvider(create: (_) => SpeechViewModel()),
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
