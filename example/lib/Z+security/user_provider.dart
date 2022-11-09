// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  int id;

  User({
    required this.id,
  });
}

class UserInfo with ChangeNotifier {
  late User user;
  late String token;

  static UserInfo instance = UserInfo();

  void updateUser(User value) {
    user = value;
    notifyListeners();
  }

  void updateToken(String value) {
    token = value;
    print('token setup');
    notifyListeners();
  }
}
