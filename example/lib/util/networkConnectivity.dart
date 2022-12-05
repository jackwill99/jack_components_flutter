import 'package:flutter/cupertino.dart';
import 'package:ntp/ntp.dart';

class NetworkConnect with ChangeNotifier {
  late bool online;
  late bool passNTP;
  late DateTime ntp;

  void updateStatus(String value) async {
    if (value != "none") {
      DateTime startDate = DateTime.now().toLocal();
      int offset = await NTP.getNtpOffset(localTime: startDate);
      online = true;
      passNTP = (offset > -3000 && offset < 3000) ? true : false;
      ntp = await NTP.now();
    } else {
      passNTP = false;
      online = false;
    }
    notifyListeners();
  }
}
