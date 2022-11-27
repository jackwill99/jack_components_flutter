import 'package:flutter/material.dart';

class TestApi {
  static Future<bool> test(BuildContext context, Map data) async {
    late bool check;
    try {
      final value = {};
      if (!value['error']) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;
    }

    return check;
  }
}
