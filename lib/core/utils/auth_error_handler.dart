import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:montage/core/errors/failures.dart';

class AuthErrorHandler {
 
  static AuthFailure handle(dynamic error) {
    if (error is FirebaseAuthException) {
      debugPrint('Firebase Auth Error: ${error.code} - ${error.message}');
      return AuthFailure.fromFirebase(error.code);
    }
    
    debugPrint('General Auth Error: $error');
    // For general errors
    return AuthFailure(
      error?.toString() ?? 'Something went wrong. Please try again.',
    );
  }
}
