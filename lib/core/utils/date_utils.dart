import '../../features/holidays/domain/entities/holiday.dart';

/// Pure date computation utilities corresponding to Android DateUtils
class AppDateUtils {
  AppDateUtils._();

  static int getCurrentYear() {
    return DateTime.now().year;
  }

  static DateTime? parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  static int calculateDurationDays(String startDateStr, String endDateStr) {
    final start = parseDate(startDateStr);
    final end = parseDate(endDateStr);
    if (start == null || end == null) return 1;

    final startNormalized = DateTime(start.year, start.month, start.day);
    final endNormalized = DateTime(end.year, end.month, end.day);
    final diff = endNormalized.difference(startNormalized).inDays + 1;
    return diff > 0 ? diff : 1;
  }

  static int? getDaysRemaining(String startDateStr) {
    final start = parseDate(startDateStr);
    if (start == null) return null;

    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final startMidnight = DateTime(start.year, start.month, start.day);

    final diffDays = startMidnight.difference(todayMidnight).inDays;
    return diffDays >= 0 ? diffDays : null;
  }

  static HolidayStatus getHolidayStatus(String startDateStr, String endDateStr) {
    final start = parseDate(startDateStr);
    final end = parseDate(endDateStr);
    if (start == null || end == null) return HolidayStatus.upcoming;

    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final startMidnight = DateTime(start.year, start.month, start.day);
    final endMidnight = DateTime(end.year, end.month, end.day);

    if (todayMidnight.isBefore(startMidnight)) {
      return HolidayStatus.upcoming;
    } else if (todayMidnight.isAfter(endMidnight)) {
      return HolidayStatus.past;
    } else {
      return HolidayStatus.today;
    }
  }
}
