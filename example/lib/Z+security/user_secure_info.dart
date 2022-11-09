import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      );

  // token
  static Future<String> getAuthToken() async =>
      await _storage.read(
          key: 'authtoken',
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions()) ??
      "";
  static Future<void> setAuthToken({required String token}) async =>
      await _storage.write(
          key: 'authtoken',
          value: token,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());

  // user expeired time
  static Future<String> getExpTime() async {
    final code = await _storage.read(
        key: 'expTimeToLeave',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    return code!;
  }

  static Future<void> setExpTime({required String code}) async =>
      await _storage.write(
          key: 'expTimeToLeave',
          value: code,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());

  // delete
  static Future<void> deleteToken() async {
    await _storage.delete(
        key: 'authtoken',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());

    await _storage.delete(
        key: 'expTimeToLeave',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }
}
