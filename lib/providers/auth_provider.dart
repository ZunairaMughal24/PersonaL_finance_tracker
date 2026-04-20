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

  // Sign In Controllers
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController = TextEditingController();

  // Sign Up Controllers
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController = TextEditingController();
  final TextEditingController signUpUsernameController = TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  // Sign In Errors
  String? _signInEmailError;
  String? _signInPasswordError;

  // Sign Up Errors
  String? _signUpUsernameError;
  String? _signUpEmailError;
  String? _signUpPasswordError;
  String? _generalError;

  String? get signInEmailError => _signInEmailError;
  String? get signInPasswordError => _signInPasswordError;
  String? get signUpUsernameError => _signUpUsernameError;
  String? get signUpEmailError => _signUpEmailError;
  String? get signUpPasswordError => _signUpPasswordError;
  String? get generalError => _generalError;

  /// Clears validation errors for a specific field or all fields.
  void clearErrors({bool onlyGeneral = false, String? field}) {
    if (onlyGeneral) {
      _generalError = null;
    } else if (field != null) {
      if (field == 'signInEmail') _signInEmailError = null;
      if (field == 'signInPassword') _signInPasswordError = null;
      if (field == 'signUpUsername') _signUpUsernameError = null;
      if (field == 'signUpEmail') _signUpEmailError = null;
      if (field == 'signUpPassword') _signUpPasswordError = null;
    } else {
      _signInEmailError = null;
      _signInPasswordError = null;
      _signUpUsernameError = null;
      _signUpEmailError = null;
      _signUpPasswordError = null;
      _generalError = null;
    }
    notifyListeners();
  }

  /// Resets all controllers and errors
  void resetAuthForm() {
    signInEmailController.clear();
    signInPasswordController.clear();
    signUpEmailController.clear();
    signUpPasswordController.clear();
    signUpUsernameController.clear();
    signUpConfirmPasswordController.clear();
    clearErrors();
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
        signInEmailController.text.trim(),
        signInPasswordController.text.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      final failure = AuthErrorHandler.handle(e);

      // Map to specific fields if code is provided
      if (failure.code == 'email') {
        _signInEmailError = failure.message;
      } else if (failure.code == 'password') {
        _signInPasswordError = failure.message;
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
        signUpEmailController.text.trim(),
        signUpPasswordController.text.trim(),
      );

      if (signUpUsernameController.text.isNotEmpty) {
        await _authService.updateDisplayName(signUpUsernameController.text.trim());
      }

      _isLoading = false;
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      final failure = AuthErrorHandler.handle(e);

      if (failure.code == 'email') {
        _signUpEmailError = failure.message;
      } else if (failure.code == 'password') {
        _signUpPasswordError = failure.message;
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
    signInEmailController.dispose();
    signInPasswordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpUsernameController.dispose();
    signUpConfirmPasswordController.dispose();
    super.dispose();
  }
}
