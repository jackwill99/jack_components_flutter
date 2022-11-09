import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jack_components/core_system/fcmANDnotification/providers/fcm_notification_config.dart';
import 'package:jack_components/core_system/fcmANDnotification/providers/permissions.dart';
import 'package:jack_components/core_system/fcmANDnotification/widgets/openedShowNotification.dart';
import 'package:jack_components/core_system/fcmANDnotification/widgets/showFlutterNotification.dart';
import 'package:rxdart/rxdart.dart';

class JackFCMConfig {
  static late Stream<String> _tokenStream;

  // final setupToken = Provider.of<JackFCMToken>(context, listen: false);
  static final BehaviorSubject<String?> _setupToken =
      BehaviorSubject<String?>();

  static Future<void> firebaseSetup({required String vapidKey}) async {
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
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(_setupToken.add);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(
        message,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      openedShowNotification(
        message,
      );
    });
  }

  static ValueStream<String?> get onToken {
    return _setupToken.stream;
  }
}
