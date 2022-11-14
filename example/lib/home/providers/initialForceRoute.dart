import 'package:flutter/cupertino.dart';

class ForceRoute with ChangeNotifier {
  String? routeName;

  void updateRoute(String? value) {
    routeName = value;
    notifyListeners();
  }
}

/// and then use in home screen goTo your initial route
/// final initRoute = context.read<ForceRoute>().routeName;
//       if (initRoute != null) {
//         Navigator.of(context).pushNamed(initRoute);
//       }
