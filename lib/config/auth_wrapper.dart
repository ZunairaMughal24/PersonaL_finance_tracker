import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montage/providers/auth_provider.dart';
import 'package:montage/providers/transaction_provider.dart';
import 'package:montage/providers/user_settings_provider.dart';
import 'package:montage/screens/main_navigation_screen.dart';
import 'package:montage/screens/onboarding_screen.dart';
import 'package:montage/screens/splash_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = true;
  late final DateTime _splashStart;

  static const _minSplashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _splashStart = DateTime.now();
    _waitForReadiness();
  }

  Future<void> _waitForReadiness() async {
    final auth = context.read<AuthProvider>();

    // 1. Wait until Auth Service emits ITS FIRST EVENT (initialized)
    while (!auth.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    // 2. If user is null, wait longer to be ABSOLUTELY SURE (Double Check)

    if (auth.currentUser == null) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
    }

    // 3. If we have a user now (or still have one), wait for Data Readiness
    if (auth.currentUser != null) {
      final tx = context.read<TransactionProvider>();
      final settings = context.read<UserSettingsProvider>();

      // Loop until providers are ready for the CURRENT user
      while (!tx.isReady || !settings.isReady) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }
    }

    // 4. Ensure minimum splash time (3s)
    await _ensureMinSplash();

    if (mounted) {
      setState(() => _showSplash = false);
    }
  }

  Future<void> _ensureMinSplash() async {
    final elapsed = DateTime.now().difference(_splashStart);
    if (elapsed < _minSplashDuration) {
      await Future.delayed(_minSplashDuration - elapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.currentUser != null) {
          return const MainNavScreen();
        }
        return const OnboardingScreen();
      },
    );
  }
}
