import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:voita_app/utils/services/string_extension.dart';

class TimeFormatter {
  static String getMinutes(DateTime dateTime, int duration) {
    return DateFormat.jm('uk').format(dateTime);
  }

  static String getDay(DateTime dateTime) {
    initializeDateFormatting('uk', null);
    // Get hours and minutes
    String dayOfWeek = DateFormat.E('uk').format(dateTime).capitalize();

    // Get day of the month
    String dayOfMonth = DateFormat.d('uk').format(dateTime);

    // Get month name
    String monthName = DateFormat.MMMM('uk').format(dateTime).capitalize().toGenitive();

    // Combine the formatted strings
    String formattedDateTime = '$dayOfWeek, $dayOfMonth $monthName';

    return formattedDateTime;
  }
}