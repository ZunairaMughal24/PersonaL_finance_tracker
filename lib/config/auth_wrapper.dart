import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:montage/providers/auth_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _takeToApp();
  }

  void _takeToApp() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
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
