import 'package:flutter_test/flutter_test.dart';
import 'package:country_holiday_app/core/utils/date_utils.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/holiday.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('calculateDurationDays returns 1 for single-day holiday', () {
      final days = AppDateUtils.calculateDurationDays('2026-01-01', '2026-01-01');
      expect(days, 1);
    });

    test('calculateDurationDays returns correct span for multi-day holiday', () {
      final days = AppDateUtils.calculateDurationDays('2026-07-01', '2026-07-15');
      expect(days, 15);
    });

    test('calculateDurationDays fallback to 1 on invalid date strings', () {
      final days = AppDateUtils.calculateDurationDays('invalid', 'dates');
      expect(days, 1);
    });

    test('getDaysRemaining returns non-negative value for future dates', () {
      final now = DateTime.now();
      final futureDate = DateTime(now.year + 1, 1, 1);
      final formatted =
          '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';

      final remaining = AppDateUtils.getDaysRemaining(formatted);
      expect(remaining, isNotNull);
      expect(remaining!, greaterThan(0));
    });

    test('getDaysRemaining returns null for past dates', () {
      final remaining = AppDateUtils.getDaysRemaining('2020-01-01');
      expect(remaining, isNull);
    });

    test('getHolidayStatus returns past for historical date', () {
      final status = AppDateUtils.getHolidayStatus('2020-01-01', '2020-01-01');
      expect(status, HolidayStatus.past);
    });

    test('getHolidayStatus returns upcoming for distant future date', () {
      final status = AppDateUtils.getHolidayStatus('2099-01-01', '2099-01-01');
      expect(status, HolidayStatus.upcoming);
    });

    test('getHolidayStatus returns today for current date span', () {
      final now = DateTime.now();
      final todayFormatted =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final status =
          AppDateUtils.getHolidayStatus(todayFormatted, todayFormatted);
      expect(status, HolidayStatus.today);
    });
  });
}
