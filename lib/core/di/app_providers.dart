import 'package:montage/providers/auth_provider.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/repositories/category_repository.dart';
import 'package:montage/repositories/transaction_repository.dart';
import 'package:montage/repositories/user_settings_repository.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    Provider<TransactionRepository>(create: (_) => TransactionRepository()),
    Provider<UserSettingsRepository>(create: (_) => UserSettingsRepository()),
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
    ChangeNotifierProxyProvider<TransactionProvider, TransactionListViewModel>(
      create: (context) => TransactionListViewModel(
        context.read<TransactionProvider>(),
        isHistoryMode: false,
      ),
      update: (context, provider, previous) =>
          previous ?? TransactionListViewModel(provider, isHistoryMode: false),
    ),
    ChangeNotifierProvider(create: (_) => SpeechViewModel()),
  ];
}
