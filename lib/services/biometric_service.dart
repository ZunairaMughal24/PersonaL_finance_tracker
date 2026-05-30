import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:montage/core/interfaces/i_biometric_service.dart';
import 'package:montage/core/utils/app_logger.dart';

class BiometricService implements IBiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (e, stackTrace) {
      AppLogger.error(
        'BiometricService: Error checking availability',
        e,
        stackTrace,
      );
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e, stackTrace) {
      AppLogger.error(
        'BiometricService: Error getting biometrics',
        e,
        stackTrace,
      );
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate({
    String reason = 'Please authenticate to access your finance tracker',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly:
              false, // Allows PIN/Pattern fallback if biometrics fail/unavailable
        ),
      );
    } on PlatformException catch (e, stackTrace) {
      AppLogger.error(
        'BiometricService: Error during authentication',
        e,
        stackTrace,
      );
      return false;
    }
  }
}
