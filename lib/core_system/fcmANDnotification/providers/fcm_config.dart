import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jack_components/core_system/fcmANDnotification/providers/fcm_notification_config.dart';
import 'package:jack_components/core_system/fcmANDnotification/providers/permissions.dart';
import 'package:rxdart/rxdart.dart';

class JackFCMConfig {
  late void Function(RemoteMessage message) onMessageListen;
  late void Function(RemoteMessage message) onMessageOpened;

  JackFCMConfig({required this.onMessageListen, required this.onMessageOpened});

  static late Stream<String> _tokenStream;

  // final setupToken = Provider.of<JackFCMToken>(context, listen: false);
  final BehaviorSubject<String?> _setupToken = BehaviorSubject<String?>();

  Future<void> firebaseSetup({required String vapidKey}) async {
    requestPermission();

    if (!kIsWeb) {
      /// Local Notification setup
      await JackFCMNotificationConfig.setupFlutterNotifications();
    }

    FirebaseMessaging.instance.getToken(vapidKey: vapidKey).then(
      (value) {
        print("----------------------token----------------------");
        _setupToken.add(value);
        // setupToken.addToken(value);
      },
    );

    /// if u need uncomment this
    // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    // _tokenStream.listen(_setupToken.add);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessageListen(message);
      // showFlutterNotification(
      //   message,
      // );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpened(message);
      // openedShowNotification(
      //   message,
      // );
    });
  }

  ValueStream<String?> get onToken {
    return _setupToken.stream;
  }

  /// It is assumed that all messages contain a data field with the key 'type'
  /// call this method in application initial cycle and if initialMessage , do ur actions
  static Future<RemoteMessage?> onMessageTerminatedOpen() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    return initialMessage;
  }
}
