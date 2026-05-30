import 'package:flutter/material.dart';
import 'package:montage/core/errors/failures.dart';

class AuthFormViewModel extends ChangeNotifier {
  // Sign In controllers
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController = TextEditingController();

  // Sign Up controllers
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController = TextEditingController();
  final TextEditingController signUpUsernameController = TextEditingController();
  final TextEditingController signUpConfirmPasswordController = TextEditingController();

  // Sign In errors
  String? _signInEmailError;
  String? _signInPasswordError;

  // Sign Up errors
  String? _signUpUsernameError;
  String? _signUpEmailError;
  String? _signUpPasswordError;

  // Password visibility
  bool _isSignInPasswordVisible = false;
  bool _isSignUpPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _rememberMe = false;

  String? get signInEmailError => _signInEmailError;
  String? get signInPasswordError => _signInPasswordError;
  String? get signUpUsernameError => _signUpUsernameError;
  String? get signUpEmailError => _signUpEmailError;
  String? get signUpPasswordError => _signUpPasswordError;
  bool get isSignInPasswordVisible => _isSignInPasswordVisible;
  bool get isSignUpPasswordVisible => _isSignUpPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get rememberMe => _rememberMe;

  void handleSignInFailure(AuthFailure failure) {
    if (failure.code == 'email') {
      _signInEmailError = failure.message;
    } else if (failure.code == 'password') {
      _signInPasswordError = failure.message;
    }
    notifyListeners();
  }

  void handleSignUpFailure(AuthFailure failure) {
    if (failure.code == 'email') {
      _signUpEmailError = failure.message;
    } else if (failure.code == 'password') {
      _signUpPasswordError = failure.message;
    }
    notifyListeners();
  }

  void clearErrors({String? field}) {
    if (field == null) {
      _signInEmailError = null;
      _signInPasswordError = null;
      _signUpUsernameError = null;
      _signUpEmailError = null;
      _signUpPasswordError = null;
    } else {
      if (field == 'signInEmail') _signInEmailError = null;
      if (field == 'signInPassword') _signInPasswordError = null;
      if (field == 'signUpUsername') _signUpUsernameError = null;
      if (field == 'signUpEmail') _signUpEmailError = null;
      if (field == 'signUpPassword') _signUpPasswordError = null;
    }
    notifyListeners();
  }

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
