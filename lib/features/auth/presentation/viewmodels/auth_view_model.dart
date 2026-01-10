import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  bool _isSignInPasswordVisible = false;
  bool _isSignUpPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isSignInPasswordVisible => _isSignInPasswordVisible;
  bool get isSignUpPasswordVisible => _isSignUpPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // Sign In
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Sign Up (Reuse username/password or create new ones if needed, but for simplicity reusing)
  // Actually, separating them is cleaner as requested by user ("Clean Architecture")
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  void toggleSignInPasswordVisibility() {
    _isSignInPasswordVisible = !_isSignInPasswordVisible;
    notifyListeners();
  }

  void toggleSignUpPasswordVisibility() {
    _isSignUpPasswordVisible = !_isSignUpPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUp() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
