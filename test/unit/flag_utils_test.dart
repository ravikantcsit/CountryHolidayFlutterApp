import 'package:flutter_test/flutter_test.dart';
import 'package:country_holiday_app/core/utils/flag_utils.dart';

void main() {
  group('FlagUtils Tests', () {
    test('generate correct emoji for Germany (DE)', () {
      final flag = FlagUtils.getCountryFlagEmoji('DE');
      expect(flag, '🇩🇪');
    });

    test('generate correct emoji for United States (US)', () {
      final flag = FlagUtils.getCountryFlagEmoji('US');
      expect(flag, '🇺🇸');
    });

    test('generate fallback globe for invalid length', () {
      expect(FlagUtils.getCountryFlagEmoji(''), '🌐');
      expect(FlagUtils.getCountryFlagEmoji('D'), '🌐');
      expect(FlagUtils.getCountryFlagEmoji('DEU'), '🌐');
    });

    test('generate fallback globe for non-alphabet characters', () {
      expect(FlagUtils.getCountryFlagEmoji('12'), '🌐');
      expect(FlagUtils.getCountryFlagEmoji('@#'), '🌐');
    });

    test('handle lowercase input correctly', () {
      expect(FlagUtils.getCountryFlagEmoji('de'), '🇩🇪');
      expect(FlagUtils.getCountryFlagEmoji('us'), '🇺🇸');
    });
  });
}
