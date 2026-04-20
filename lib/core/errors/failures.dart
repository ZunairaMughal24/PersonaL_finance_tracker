abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});

  factory AuthFailure.fromFirebase(String code) {
    final cleanCode = code.replaceFirst('auth/', '');
    switch (cleanCode) {
      case 'user-not-found':
        return const AuthFailure(
          'No account exists with this email.',
          code: 'email',
        );
      case 'wrong-password':
        return const AuthFailure(
          'Incorrect password. Please try again.',
          code: 'password',
        );
      case 'invalid-credential':
        return const AuthFailure('Invalid email or password.', code: 'email');
      case 'email-already-in-use':
        return const AuthFailure(
          'This email is already registered.',
          code: 'email',
        );
      case 'invalid-email':
        return const AuthFailure(
          'Please enter a valid email address.',
          code: 'email',
        );
      case 'weak-password':
        return const AuthFailure(
          'Password is too weak. Try a stronger one.',
          code: 'password',
        );
      case 'too-many-requests':
        return const AuthFailure('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return const AuthFailure('Check your internet connection.');
      case 'operation-not-allowed':
        return const AuthFailure(
          'Operation not allowed. Please contact support.',
        );
      case 'user-disabled':
        return const AuthFailure(
          'This user account has been disabled.',
          code: 'email',
        );
      default:
        return const AuthFailure('Something went wrong. Please try again.');
    }
  }
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}
