// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    const response = {"success": true};

    if (response['success']!) {
      //Change
      //Parse the result here to get the info
      Version minAppVersion = Version.parse("1.0.0");
      Version latestAppVersion = Version.parse("1.0.2");

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Version currentVersion = Version.parse(packageInfo.version);
      print("----------------------upgrade----------------------");
      print(latestAppVersion > currentVersion);
      if (minAppVersion > currentVersion) {
        if (ctx != null) {
          print('ctx exist');
          return;
        } else {
          _updateContext(context);
        }
        _showUpdateDialog(
          context,
          "Please update the app to continue",
        );
      } else if (latestAppVersion > currentVersion) {
        bool later = false;
        await AuthStorage.deleteToken();
        later = await AuthStorage.getLaterUpdate() == "false" ? false : true;
        if (later) {
          return;
        }
        if (ctx != null) {
          print('ctx exist');
          return;
        } else {
          _updateContext(context);
        }
        print('after ctx');
        _showUpdateDialog(context, "Please update the app to continue",
            laterBtn: true);
      } else {
        Navigator.of(context).pop();
        _updateContext(null);
      }
    }
  }

  _onUpdateNowClicked() {
    JackLaunchAppId.launch(androidAppId: androidAppId, iOSAppId: iOSAppId);
  }

  _updateDoNotShowAgain() async {
    await AuthStorage.setLaterUpdate(code: "true");
  }

  _showUpdateDialog(context, String message, {bool laterBtn = false}) async {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return WillPopScope(
          onWillPop: () async => laterBtn ? true : false,
          child: JackUIDialogMorphism(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            description: Text(
              message,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            confirmFunc: _onUpdateNowClicked,
            confirmText: btnLabel,
            undoFunc: laterBtn
                ? () {
                    if (doNotAskAgain) {
                      _updateDoNotShowAgain();
                    }
                    _updateContext(null);
                    Navigator.of(context).pop();
                  }
                : null,
            undoText: laterBtn ? "Later" : null,
            body: laterBtn ? const DoNotAskCheckbox() : null,
            topImage: Image.asset(
              "assets/img/update_t.png",
              height: 120.h,
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
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
