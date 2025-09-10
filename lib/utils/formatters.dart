import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatPrice(num value) {
    return currency.format(value);
  }
}
