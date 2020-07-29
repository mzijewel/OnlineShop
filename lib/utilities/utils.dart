import 'package:intl/intl.dart';

class Utils {
  static String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:MM');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static String getCurrentDate(DateTime dateTime) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }
}