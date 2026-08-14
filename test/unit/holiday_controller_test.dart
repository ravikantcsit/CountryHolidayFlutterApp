import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/country.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/holiday.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/subdivision.dart';
import 'package:country_holiday_app/features/holidays/domain/repositories/holiday_repository.dart';
import 'package:country_holiday_app/features/holidays/presentation/controllers/holiday_controller.dart';

class MockHolidayRepository implements HolidayRepository {
  @override
  Future<List<Country>> getCountries() async {
    return [
      Country(isoCode: 'DE', name: 'Germany'),
      Country(isoCode: 'US', name: 'United States'),
    ];
  }

  @override
  Future<List<Subdivision>> getSubdivisions(String countryIsoCode) async {
    return [
      const Subdivision(code: 'DE-BY', name: 'Bavaria'),
    ];
  }

  @override
  Future<List<Holiday>> getHolidays({
    required String countryIsoCode,
    required int year,
    String? subdivisionCode,
    String language = 'EN',
  }) async {
    return [
      const Holiday(
        id: '1',
        name: "New Year's Day",
        startDate: '2026-01-01',
        endDate: '2026-01-01',
        type: HolidayType.public,
      ),
      const Holiday(
        id: '2',
        name: 'Summer Break',
        startDate: '2026-07-01',
        endDate: '2026-08-15',
        type: HolidayType.school,
      ),
    ];
  }
}

void main() {
  group('HolidayNotifier Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          holidayRepositoryProvider.overrideWithValue(MockHolidayRepository()),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state loads countries and defaults to Germany (DE)', () async {
      final notifier = container.read(holidayNotifierProvider.notifier);
      await notifier.loadCountries();

      final state = container.read(holidayNotifierProvider);
      expect(state.isLoadingCountries, isFalse);
      expect(state.countries.length, 2);
      expect(state.selectedCountry?.isoCode, 'DE');
      expect(state.filteredHolidays.length, 2);
    });

    test('filtering by tab switches public and school holidays', () async {
      final notifier = container.read(holidayNotifierProvider.notifier);
      await notifier.loadCountries();

      notifier.selectTab(HolidayType.public);
      var state = container.read(holidayNotifierProvider);
      expect(state.filteredHolidays.length, 1);
      expect(state.filteredHolidays.first.type, HolidayType.public);

      notifier.selectTab(HolidayType.school);
      state = container.read(holidayNotifierProvider);
      expect(state.filteredHolidays.length, 1);
      expect(state.filteredHolidays.first.type, HolidayType.school);

      notifier.selectTab(HolidayType.all);
      state = container.read(holidayNotifierProvider);
      expect(state.filteredHolidays.length, 2);
    });

    test('searching query filters holiday list in real-time', () async {
      final notifier = container.read(holidayNotifierProvider.notifier);
      await notifier.loadCountries();

      notifier.updateSearchQuery('summer');
      final state = container.read(holidayNotifierProvider);
      expect(state.filteredHolidays.length, 1);
      expect(state.filteredHolidays.first.name, 'Summer Break');
    });
  });
}
