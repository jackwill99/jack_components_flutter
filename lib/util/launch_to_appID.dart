// ignore_for_file: file_names

import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class JackLaunchAppId {
  /// androidAppId is your Bundle ID (and) iOSAppId is your applicationName/id...
  /// When u go ur www.appstoreconnect.com, u will see appStoreId of ur application
  ///
  static launch(
      {required String androidAppId, required String iOSAppId}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? androidAppId : iOSAppId;

      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/$appId",
      );
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
