import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/screens/analytics_screen.dart';
import 'package:personal_finance_tracker/screens/edit_transaction_screen.dart';
import 'package:personal_finance_tracker/screens/home_screen.dart';
import 'package:personal_finance_tracker/screens/main_navigation_screen.dart';
import 'package:personal_finance_tracker/screens/settings_screen.dart';
import 'package:personal_finance_tracker/screens/transaction_screen.dart';
import 'package:personal_finance_tracker/screens/splash_screen.dart';
import 'package:personal_finance_tracker/screens/onboarding_screen.dart';
import 'package:personal_finance_tracker/screens/activity_screen.dart';
import 'package:personal_finance_tracker/screens/sign_in_screen.dart';
import 'package:personal_finance_tracker/screens/sign_up_screen.dart';

CustomTransitionPage<void> _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class AppRoutes {
  static const String splashScreenRoute = '/splash';
  static const String mainNavigationScreenRoute = '/MainNavigationScreen';
  static const String homeScreenRoute = '/homeScreen';
  static const String transactionScreenRoute = '/trasactionScreen';
  static const String editTransactionScreenRoute = '/editTransactionScreen';
  static const String analyticsScreenRoute = '/analyticsScreen';
  static const String activityScreenRoute = '/activityScreen';
  static const String settingsScreenRoute = '/settingsScreen';
  static const String signInScreenRoute = '/signIn';
  static const String signUpScreenRoute = '/signUp';
  static const String onboardingScreenRoute = '/onboarding';
}

final router = GoRouter(
  initialLocation: AppRoutes.splashScreenRoute,
  routes: [
    GoRoute(
      path: AppRoutes.splashScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.mainNavigationScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const MainNavScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.homeScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.transactionScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: TransactionScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editTransactionScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: EditTransactionScreen(transaction: state.extra as dynamic),
      ),
    ),
    GoRoute(
      path: AppRoutes.analyticsScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const AnalyticsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.activityScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const ActivityScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.settingsScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.signInScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SignInScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.signUpScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboardingScreenRoute,
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const OnboardingScreen(),
      ),
    ),
  ],
);
