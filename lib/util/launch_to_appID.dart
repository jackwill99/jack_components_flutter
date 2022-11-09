// ignore_for_file: file_names

import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class JackLaunchAppId {
  static launch(
      {required String androidAppId, required String iOSAppId}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? androidAppId : iOSAppId;

      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
