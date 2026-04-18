import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montage/services/auth_service.dart';
import 'package:montage/core/utils/auth_error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _user = _authService.currentUser;
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Field-level error states
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  String? get usernameError => _usernameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get generalError => _generalError;

  /// Clears validation errors for a specific field or all fields.
  void clearErrors({bool onlyGeneral = false}) {
    if (onlyGeneral) {
      _generalError = null;
    } else {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    }
    notifyListeners();
  }

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
    clearErrors();
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
      final failure = AuthErrorHandler.handle(e);
      
      // Map to specific fields if code is provided
      if (failure.code == 'email') {
        _emailError = failure.message;
      } else if (failure.code == 'password') {
        _passwordError = failure.message;
      } else {
        _generalError = failure.message;
      }
      
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _generalError = 'An unexpected error occurred.';
      notifyListeners();
      return null;
    }
  }

  Future<UserCredential?> signUp() async {
    _isLoading = true;
    clearErrors();
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
      final failure = AuthErrorHandler.handle(e);
      
      if (failure.code == 'email') {
        _emailError = failure.message;
      } else if (failure.code == 'password') {
        _passwordError = failure.message;
      } else {
        _generalError = failure.message;
      }
      
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _generalError = 'Could not create account. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _isLoading = false;
    notifyListeners();
  }

  User? get currentUser => _user;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
