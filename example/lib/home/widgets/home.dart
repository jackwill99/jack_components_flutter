// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:example/Z+security/user_provider.dart';
import 'package:example/Z+security/user_secure_info.dart';
import 'package:flutter/material.dart';
import 'package:jack_components/core_system/camera/widget/camera.dart';
import 'package:jack_components/core_system/network/network_config.dart';
import 'package:jack_components/core_system/upgrade/widgets/upgrade_app.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  final int counter;

  const MyHome({
    Key? key,
    required this.counter,
  }) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late Timer timer;
  String token = "";
  int id = 0;

  //TODO : Remove this
  late List<CameraDescription> firstCamera;

  Future<void> initCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras;
  }

  StreamSubscription? sub;

  @override
  void initState() {
    super.initState();
    startTimer();

    ///TODO remove this
    initCamera();
    subscription();
  }

  void subscription() async {
    print('subscription');
    sub = JackNetworkConfig.getStatus.stream.listen((event) {
      print("----------------------jack networkconfig----------------------");
      print(event);
      if (event.name != 'none') {
        JackUpgradeApp(
          context: context,
          androidAppId: 'com.zds.ctoc.zds_ctoc',
          iOSAppId: 'com.zdsmyanmar.app.ios.c2c',
        );
        checkNotification();
        print('there is internet');
      }
      if (event.name == "none") {
        print('none internet');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        token = context.read<UserInfo>().token;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
  }

  void startTimer() async {
    final expTimer = await AuthStorage.getExpTime();
    final expTime = DateTime.parse(expTimer);
    final remainTime = expTime.difference(DateTime.now());
    print(
        "----------------------${remainTime.inHours.toString()}----------------------");
    timer = Timer(remainTime, () {
      logoutUser();
    });
  }

  void logoutUser() async {
    timer.cancel();
    await AuthStorage.deleteToken();
    if (!mounted) return;
    Navigator.of(context).pushNamed("/");
  }

  void checkNotification() async {
    print("----------------------internet comeback----------------------");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              'You have pushed the button this many times: 2000',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            widget.counter.toString(),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => JackCamera(
                    camera: firstCamera,
                  ),
                ),
              )
                  .then((value) {
                print("----------------------then----------------------");
                print(value);
              });
            },
            child: Text(
              "Camera",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
