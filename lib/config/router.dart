import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montage/screens/analytics_screen.dart';
import 'package:montage/screens/edit_transaction_screen.dart';
import 'package:montage/screens/home_screen.dart';
import 'package:montage/screens/main_navigation_screen.dart';
import 'package:montage/screens/settings_screen.dart';
import 'package:montage/screens/transaction_screen.dart';
import 'package:montage/screens/splash_screen.dart';
import 'package:montage/screens/onboarding_screen.dart';
import 'package:montage/screens/activity_screen.dart';
import 'package:montage/screens/sign_in_screen.dart';
import 'package:montage/screens/sign_up_screen.dart';
import 'package:montage/config/auth_wrapper.dart';
import 'package:montage/screens/image_view_screen.dart';
import 'package:montage/screens/personal_information_screen.dart';

// ─── Route Constants

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
  static const String imageViewScreenRoute = '/imageView';
  static const String personalInformationScreenRoute = '/personalInformation';

  static const String rootRoute = '/';

  static const Set<String> publicRoutes = {
    splashScreenRoute,
    signInScreenRoute,
    signUpScreenRoute,
    onboardingScreenRoute,
  };
}

// ─── Page Transition

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

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.rootRoute,
    routes: [
      GoRoute(
        path: AppRoutes.rootRoute,
        builder: (context, state) => const AuthWrapper(),
      ),
      // ── Public Routes
      GoRoute(
        path: AppRoutes.splashScreenRoute,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
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

      // ── Protected Routes
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
        path: AppRoutes.imageViewScreenRoute,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: ImageViewScreen(imagePath: state.extra as String),
        ),
      ),
      GoRoute(
        path: AppRoutes.personalInformationScreenRoute,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const PersonalInformationScreen(),
        ),
      ),
    ],
  );
}
