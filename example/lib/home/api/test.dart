import 'package:example/apiConstants.dart';
import 'package:flutter/material.dart';

class TestApi {
  static Future<bool> test(BuildContext context, Map data) async {
    late bool check;
    try {
      await ApiConstants.api()
          .postDio(
        data: data,
        path: ApiConstants.home,
      )
          .then((value) {
        if (!value['error']) {
          final data = value['data'];
          check = true;
        } else {
          check = false;
        }
      });
    } catch (e) {
      check = false;
    }

    return check;
  }
}
