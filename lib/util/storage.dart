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

  // show update dialog
  static Future<String> getLaterUpdate() async {
    final code = await _storage.read(
        key: 'laterUpdate',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    return code ?? "false";
  }

  static Future<void> setLaterUpdate({required String code}) async =>
      await _storage.write(
          key: 'laterUpdate',
          value: code,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());

  // delete
  static Future<void> deleteToken() async {
    await _storage.delete(
        key: 'laterUpdate',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }
}
