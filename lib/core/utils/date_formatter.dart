import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(targetDate).inDays;

    if (diff == 0) {
      return 'วันนี้ ${DateFormat('HH:mm').format(date)}';
    } else if (diff == 1) {
      return 'เมื่อวาน ${DateFormat('HH:mm').format(date)}';
    } else if (diff == -1) {
      return 'พรุ่งนี้';
    } else if (diff > 1 && diff < 7) {
      return '$diff วันที่แล้ว';
    } else {
      return DateFormat('d MMM yyyy, HH:mm').format(date);
    }
  }

  static String formatMinutesToWuxiaTime(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes นาที';
    }
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (mins == 0) {
      return '$hours ชั่วยาม (ชั่วโมง)';
    }
    return '$hours ชม. $mins นาที';
  }
}
