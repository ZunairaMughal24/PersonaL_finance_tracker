import 'package:local_auth/local_auth.dart';

abstract class IBiometricService {
  Future<bool> isBiometricAvailable();
  Future<List<BiometricType>> getAvailableBiometrics();
  Future<bool> authenticate({String reason});
}
