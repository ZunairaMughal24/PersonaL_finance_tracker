import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:montage/screens/main_navigation_screen.dart';
import 'package:montage/screens/onboarding_screen.dart';
import 'package:montage/screens/splash_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _minSplashOver = false;
  late final Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    _authStateStream = FirebaseAuth.instance.authStateChanges();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _minSplashOver = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStateStream,
      builder: (context, snapshot) {
        debugPrint(
          'AuthWrapper State: ${snapshot.connectionState}, Data UID: ${snapshot.data?.uid}, Show Splash: ${!_minSplashOver}',
        );

        // Show splash screen while waiting for Firebase
        if (snapshot.connectionState == ConnectionState.waiting ||
            !_minSplashOver) {
          return const SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavScreen();
        }

        return const OnboardingScreen();
      },
    );
  }
}
