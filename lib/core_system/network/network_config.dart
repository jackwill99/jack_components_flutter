import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

class JackNetworkConfig {
  static final Connectivity _connectivity = Connectivity();

  static late StreamSubscription<ConnectivityResult> connectivitySubscription;
  static final BehaviorSubject<ConnectivityResult> _controller =
      BehaviorSubject<ConnectivityResult>();

  static void _updateNetworkSubscription() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      debugPrint("_updateNetworkSubscription");
      _controller.add(event);

      ///* I assume that will not need
      // _updateConnectionStatus(event);
    });
  }

  static Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print('_updateConnectionStatus');
    _controller.add(result);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    _updateNetworkSubscription();
    debugPrint('network config done');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    return _updateConnectionStatus(result);
  }

  /// get the network status
  static BehaviorSubject<ConnectivityResult> get getStatus {
    return _controller;
  }
}
