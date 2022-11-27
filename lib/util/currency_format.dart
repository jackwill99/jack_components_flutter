import 'package:intl/intl.dart';

class JackCurrencyFormat {
  static String format({required String amount}) {
    final currency =
        NumberFormat.currency(locale: "en", symbol: "", decimalDigits: 0);
    return currency.format(int.parse(amount));
  }
}
