import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }

  static String formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }
}
