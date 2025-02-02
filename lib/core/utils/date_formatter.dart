import 'package:intl/intl.dart';
class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MM-dd-yyyy HH:mm').format(dateTime);
  }
}