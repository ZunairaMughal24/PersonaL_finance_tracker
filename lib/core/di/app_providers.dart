import 'package:montage/core/interfaces/i_category_repository.dart';
import 'package:montage/core/interfaces/i_transaction_repository.dart';
import 'package:montage/core/interfaces/i_user_settings_repository.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/providers/category_provider.dart';
import 'package:montage/providers/transaction_filter_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/repositories/category_repository.dart';
import 'package:montage/repositories/transaction_repository.dart';
import 'package:montage/repositories/user_settings_repository.dart';
import 'package:montage/viewmodels/home_view_model.dart';
import 'package:montage/viewmodels/speech_view_model.dart';
import 'package:montage/viewmodels/transaction_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    Provider<ITransactionRepository>(create: (_) => TransactionRepository()),
    Provider<IUserSettingsRepository>(create: (_) => UserSettingsRepository()),
    Provider<ICategoryRepository>(create: (_) => CategoryRepository()),
    ChangeNotifierProxyProvider2<
      AuthProvider,
      ITransactionRepository,
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
      IUserSettingsRepository,
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
      ICategoryRepository,
      CategoryProvider
    >(
      create: (_) => CategoryProvider(),
      update: (_, auth, repo, cat) => cat!
        ..updateRepository(repo)
        ..updateUser(auth.currentUser?.uid),
    ),
    ChangeNotifierProxyProvider2<
      TransactionProvider,
      UserSettingsProvider,
      HomeViewModel
    >(
      create: (context) => HomeViewModel(
        context.read<TransactionProvider>(),
        context.read<UserSettingsProvider>(),
      ),
      update: (context, tx, settings, previous) =>
          previous ?? HomeViewModel(tx, settings),
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
