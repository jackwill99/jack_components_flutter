import 'package:jack_components/util/api.dart';

class ApiConstants {
  static const base = "https://google.com";
  static const home = "/jack_will";

  /// api
  static JackApi api() => JackApi(
        baseUrl: base,
        logoutFunc: () {},
        connectTimeout: 6000,
        receiveTimeout: 6000,
      );
}
