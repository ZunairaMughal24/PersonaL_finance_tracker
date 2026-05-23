import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:montage/config/router.dart';
import 'package:montage/core/themes/app_theme.dart';
import 'package:montage/firebase_options.dart';
import 'package:montage/models/transaction_model.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/repositories/transaction_repository.dart';
import 'package:montage/repositories/user_settings_repository.dart';
import 'package:montage/repositories/category_repository.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    debugPrint('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  _setPortraitMode();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<TransactionRepository>(create: (_) => TransactionRepository()),
        Provider<UserSettingsRepository>(
          create: (_) => UserSettingsRepository(),
        ),
        Provider<CategoryRepository>(create: (_) => CategoryRepository()),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          TransactionRepository,
          TransactionProvider
        >(
          create: (_) => TransactionProvider(),
          update: (_, auth, repo, tx) {
            return tx!
              ..updateRepository(repo)
              ..updateUser(auth.currentUser?.uid);
          },
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          UserSettingsRepository,
          UserSettingsProvider
        >(
          create: (_) => UserSettingsProvider(),
          update: (_, auth, repo, settings) => settings!
            ..updateRepository(repo)
            ..updateUser(
              auth.currentUser?.uid,
              displayName: auth.currentUser?.displayName,
              email: auth.currentUser?.email,
            ),
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          CategoryRepository,
          CategoryProvider
        >(
          create: (_) => CategoryProvider(),
          update: (_, auth, repo, cat) => cat!
            ..updateRepository(repo)
            ..updateUser(auth.currentUser?.uid),
        ),
        ChangeNotifierProvider(create: (_) => TransactionFilterProvider()),
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
