import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

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

  // Sign In / Sign Up
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController =
      TextEditingController(); // For Profile Name
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

  // Firebase Authentication
  Future<UserCredential?> signIn() async {
    _isLoading = true;
    notifyListeners();
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<UserCredential?> signUp() async {
    _isLoading = true;
    notifyListeners();
    try {
      final credential = await _authService.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (usernameController.text.isNotEmpty) {
        await _authService.updateDisplayName(usernameController.text.trim());
      }

      _isLoading = false;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _isLoading = false;
    notifyListeners();
  }

  User? get currentUser => _authService.currentUser;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
