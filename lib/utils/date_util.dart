import 'package:intl/intl.dart';

class DateUtil {

  static DateTime milliToDate(int millisecondsSinceEpoch) {
    return DateTime.fromMicrosecondsSinceEpoch(millisecondsSinceEpoch * 1000);
  }

  static String dateToString(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  static String milliToString(int millisecondsSinceEpoch, String format) {
    return DateFormat(format).format(DateUtil.milliToDate(millisecondsSinceEpoch));
  }

}