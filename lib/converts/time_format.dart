import 'package:intl/intl.dart';

class DateTimeFormat {
  static final DateFormat _dateFormatRequest = new DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = new DateFormat('HH:mm:ss');
  static final DateFormat _dateTimeFormatDisplay =
      new DateFormat('yyyy/MM/dd HH:mm:ss');

  static String formatDate(DateTime dateTime) {
    try {
      return _dateFormatRequest.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static String formatDateTimes(DateTime dateTime) {
    try {
      return _dateFormatRequest.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static String formatTime(DateTime dateTime) {
    try {
      return _dateTimeFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static String formatDateDisplay(DateTime dateTime) {
    try {
      return _dateTimeFormatDisplay.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static int formatDateTimeUnix(DateTime dateTime) {
    try {
      return dateTime.toUtc().millisecondsSinceEpoch ~/ 1000;
    } catch (e) {
      return null;
    }
  }

  static int formatDateTimeToMinutes(String start, String end) {
    try {
      final DateTime startDateTime = DateTime.parse(start.replaceAll('/', '-'));
      final DateTime endDateTime = DateTime.parse(end.replaceAll('/', '-'));
      final DateTime startDateTimeRemoveSecond = DateTime(
          startDateTime.year,
          startDateTime.month,
          startDateTime.day,
          startDateTime.hour,
          startDateTime.minute);
      final DateTime endDateTimeRemoveSecond = DateTime(
          endDateTime.year,
          endDateTime.month,
          endDateTime.day,
          endDateTime.hour,
          endDateTime.minute);
      return endDateTimeRemoveSecond
          .difference(startDateTimeRemoveSecond)
          .inMinutes;
    } catch (e) {
      return 0;
    }
  }

  static bool isSameDay(String start, String end) {
    try {
      final DateTime startDateTime = DateTime.parse(start.replaceAll('/', '-'));
      final DateTime endDateTime = DateTime.parse(end.replaceAll('/', '-'));
      return startDateTime.year == endDateTime.year &&
          startDateTime.month == endDateTime.month &&
          startDateTime.day == endDateTime.day;
    } catch (e) {
      return false;
    }
  }
}
