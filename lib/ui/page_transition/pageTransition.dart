import 'package:flutter/cupertino.dart';

// ignore: non_constant_identifier_names
Route<dynamic> JackPageTransition(
    {required Widget widget, RouteSettings? settings, VoidCallback? callBack}) {
  callBack?.call();
  return CupertinoPageRoute(
      builder: (BuildContext context) {
        return widget;
      },
      settings: settings);
}
