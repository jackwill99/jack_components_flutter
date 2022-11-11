// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jack_components/ui/dialog/jack_dialog_morphism.dart';
import 'package:jack_components/util/launch_to_appID.dart';
import 'package:jack_components/util/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class JackUpgradeApp {
  late String androidAppId;
  late String iOSAppId;

  JackUpgradeApp({
    required BuildContext context,
    required this.androidAppId,
    required this.iOSAppId,
  }) {
    print("----------------------checkLatestVersion----------------------");
    _checkLatestVersion(context);
  }

  static bool doNotAskAgain = false;
  static BuildContext? ctx;

  static void _updateDoNotAsk(bool value) {
    doNotAskAgain = value;
  }

  static void _updateContext(BuildContext? value) {
    ctx = value;
  }

  _checkLatestVersion(BuildContext context) async {
    //Add query here to get the minimum and latest app version

    //Change
    // var response = await queryBuilder.query();
    const response = {"success": true, "min": "1.0.0", "lat": "1.0.0"};
    if (response['success'] == true) {
      //Change
      //Parse the result here to get the info
      Version minAppVersion = Version.parse(response['min'] as String);
      Version latestAppVersion = Version.parse(response['lat'] as String);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Version currentVersion = Version.parse(packageInfo.version);
      print("----------------------upgrade----------------------");
      print(latestAppVersion > currentVersion);
      if (minAppVersion > currentVersion) {
        print("----------------------one----------------------");
        if (ctx != null) {
          return;
        } else {
          _updateContext(context);
        }
        _showUpdateDialog(
          context,
          "Please update the app to continue",
        );
      } else if (latestAppVersion > currentVersion) {
        print("----------------------two----------------------");
        bool later = false;
        await JackAuthStorage.deleteToken();
        later =
            await JackAuthStorage.getLaterUpdate() == "false" ? false : true;
        if (later) {
          return;
        }
        if (ctx != null) {
          return;
        } else {
          _updateContext(context);
        }
        print('after ctx');
        _showUpdateDialog(context, "Please update the app to continue",
            laterBtn: true);
      } else {
        // Navigator.of(context).pop();
        // _updateContext(null);
      }
    }
  }

  _onUpdateNowClicked() {
    JackLaunchAppId.launch(androidAppId: androidAppId, iOSAppId: iOSAppId);
  }

  _updateDoNotShowAgain() async {
    await JackAuthStorage.setLaterUpdate(code: "true");
  }

  _showUpdateDialog(context, String message, {bool laterBtn = false}) async {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext cct) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return WillPopScope(
          onWillPop: () async => laterBtn ? true : false,
          child: JackUIDialogMorphism(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            description: Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            confirmFunc: _onUpdateNowClicked,
            confirmText: btnLabel,
            undoFunc: laterBtn
                ? () {
                    if (doNotAskAgain) {
                      _updateDoNotShowAgain();
                    }
                    _updateContext(null);
                    Navigator.of(cct).pop();
                  }
                : null,
            undoText: laterBtn ? "Later" : null,
            body: laterBtn ? const DoNotAskCheckbox() : null,
            topImage: Image.asset(
              "assets/images/update.png",
              height: 170,
            ),
            gradientStart: 0.9,
            gradientEnd: 0.6,
          ),
        );
      },
    );
  }
}

class DoNotAskCheckbox extends StatefulWidget {
  const DoNotAskCheckbox({Key? key}) : super(key: key);

  @override
  State<DoNotAskCheckbox> createState() => _DoNotAskCheckboxState();
}

class _DoNotAskCheckboxState extends State<DoNotAskCheckbox> {
  bool doNotAskAgain = false;

  void updateShow() {
    setState(() {
      doNotAskAgain = !doNotAskAgain;
    });
    JackUpgradeApp._updateDoNotAsk(!doNotAskAgain);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: doNotAskAgain,
            onChanged: (val) => updateShow(),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: updateShow,
          child: const Text(
            "Don't ask me again",
          ),
        ),
      ],
    );
  }
}
