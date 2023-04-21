import 'package:intl/intl.dart';

class Utils {
  static String formatPrice(double price) {
    return '\$ ${price.toStringAsFixed(2)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }
}
