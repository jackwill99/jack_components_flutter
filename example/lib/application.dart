import 'dart:async';
import 'dart:io';

import 'package:example/Z+security/user_provider.dart';
import 'package:example/Z+security/user_secure_info.dart';
import 'package:example/home/providers/initialForceRoute.dart';
import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:jack_components/core_system/local_notification_api/local_notification_api.dart';
import 'package:jack_components/core_system/network/network_config.dart';
import 'package:jack_components/ui/loading/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Application extends StatefulWidget {
  static const routeName = '/Application';

  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();

    /// Network Connectivity
    JackNetworkConfig.initConnectivity();

    /// LocalNotification intialization
    JackLocalNotificationApi.init();

    /// listening clicked LocalNotification
    JackLocalNotificationApi.listenNotifications((event) {
      print(event.payload);
      print('listening clicked localNotfiaction');
    });

    /// listening clicked LocalNotification when app is killed
    JackLocalNotificationApi.listenKilledNotifications((event) {
      print(event.notificationResponse?.payload);
      print('listening clicked LocalNotification when app is killed');
      context
          .read<ForceRoute>()
          .updateRoute(event.notificationResponse?.payload);
    });
  }

  @override
  void dispose() {
    // JackNetworkConnectivity().connectivitySubscription.cancel();
    super.dispose();
  }

  Future<Map> initialize() async {
    // AuthStorage.deleteToken();
    String localToken = await AuthStorage.getAuthToken();
    print("initialization secure storage get --> $localToken");
    if (localToken.isNotEmpty) {
      if (!mounted) return {"token": ""};
      context.read<UserInfo>().updateToken(localToken);
    }

    /// just temporary test
    context.read<UserInfo>().updateToken(localToken);
    await AuthStorage.setExpTime(
      code: DateTime.now()
          .add(
            const Duration(minutes: 10),
          )
          .toString(),
    );
    return {"token": localToken};
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (Platform.isAndroid) {
      // await Permission.sms.request();
      await Permission.storage.request();
    } else if (Platform.isIOS) {
      await Permission.photos.request();
    }
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialize(),
        builder: (context, snapshot) {
          late Widget children;
          final loading = JackUILoadingSpinner(ctx: context);
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (data != null && data['token'].isNotEmpty) {
              children = const MyHomeScreen(
                title: "Title",
              );
            } else {
              children = const MyHomeScreen(
                title: "Title",
              );
            }
          } else if (snapshot.hasError) {
          } else {
            children = Scaffold(
              body: Center(
                child: loading.loadingWidget(),
              ),
            );
          }
          return children;
        });
  }
}
