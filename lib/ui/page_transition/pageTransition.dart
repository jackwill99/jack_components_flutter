import 'package:flutter/cupertino.dart';

// ignore: non_constant_identifier_names
Route<dynamic> JackPageTransition(
    {required Widget widget, RouteSettings? settings}) {
  return CupertinoPageRoute(
      builder: (BuildContext context) {
        return widget;
      },
      settings: settings);
}
