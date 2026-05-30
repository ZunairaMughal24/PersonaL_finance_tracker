import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:montage/core/errors/failures.dart';
import 'package:montage/services/auth_service.dart';
import 'package:montage/core/utils/auth_error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  StreamSubscription<User?>? _authSubscription;
  bool _isLoading = false;

  AuthProvider() {
    _user = _authService.currentUser;
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  User? get currentUser => _user;

  Future<AuthFailure?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthErrorHandler.handle(e);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return const AuthFailure('An unexpected error occurred.');
    }
  }

  Future<AuthFailure?> signUp(
    String email,
    String password,
    String username,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.createUserWithEmailAndPassword(email, password);
      if (username.isNotEmpty) {
        await _authService.updateDisplayName(username);
      }
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthErrorHandler.handle(e);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return const AuthFailure('Could not create account. Please try again.');
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
