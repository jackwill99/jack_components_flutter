import 'package:flutter/cupertino.dart';

class NetworkConnect with ChangeNotifier {
  late bool online;

  void updateStatus(String value) {
    if (value != "none") {
      online = true;
    } else {
      online = false;
    }
    notifyListeners();
  }
}
