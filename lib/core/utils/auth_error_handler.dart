import 'package:firebase_auth/firebase_auth.dart';
import 'package:montage/core/utils/app_logger.dart';
import 'package:montage/core/errors/failures.dart';

class AuthErrorHandler {
  static AuthFailure handle(dynamic error) {
    if (error is FirebaseAuthException) {
      AppLogger.error('Firebase Auth Error', error.code, StackTrace.current);
      return AuthFailure.fromFirebase(error.code);
    }

    AppLogger.error('General Auth Error', error, StackTrace.current);
    // For general errors
    return AuthFailure(
      error?.toString() ?? 'Something went wrong. Please try again.',
    );
  }
}
