import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0, // Set to 0 if you don't want decimal places
  ).format(amount);
}
