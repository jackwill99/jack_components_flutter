import 'package:flutter/cupertino.dart';

/// Navigator.of(context).push(JackRoute(HomePage(),),),
///
class JackPageTransition {
  final Widget routePage;

  JackPageTransition({required this.routePage}) {
    route(routePage);
  }

  static Route<dynamic> route(Widget value) {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return value;
      },
    );
  }
}
