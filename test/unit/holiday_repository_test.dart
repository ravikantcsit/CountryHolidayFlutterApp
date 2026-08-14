import 'package:flutter_test/flutter_test.dart';
import 'package:country_holiday_app/features/holidays/data/datasources/open_holidays_remote_data_source.dart';
import 'package:country_holiday_app/features/holidays/data/models/country_dto.dart';
import 'package:country_holiday_app/features/holidays/data/models/holiday_dto.dart';
import 'package:country_holiday_app/features/holidays/data/models/localized_string_dto.dart';
import 'package:country_holiday_app/features/holidays/data/models/subdivision_dto.dart';
import 'package:country_holiday_app/features/holidays/data/repositories/holiday_repository_impl.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/holiday.dart';

class FakeOpenHolidaysRemoteDataSource implements OpenHolidaysRemoteDataSource {
  @override
  Future<List<CountryDto>> getCountries() async {
    return [
      const CountryDto(
        isoCode: 'US',
        name: [LocalizedStringDto(language: 'EN', text: 'United States')],
      ),
      const CountryDto(
        isoCode: 'DE',
        name: [LocalizedStringDto(language: 'EN', text: 'Germany')],
      ),
    ];
  }

  @override
  Future<List<SubdivisionDto>> getSubdivisions(String countryIsoCode) async {
    return [
      const SubdivisionDto(
        code: 'DE-BY',
        isoCode: 'DE-BY',
        shortName: 'BY',
        name: [LocalizedStringDto(language: 'EN', text: 'Bavaria')],
        category: [LocalizedStringDto(language: 'EN', text: 'State')],
      ),
    ];
  }

  @override
  Future<List<HolidayDto>> getPublicHolidays({
    required String countryIsoCode,
    String language = 'EN',
    required String validFrom,
    required String validTo,
    String? subdivisionCode,
  }) async {
    return [
      const HolidayDto(
        id: '1',
        startDate: '2026-01-01',
        endDate: '2026-01-01',
        type: 'Public',
        name: [LocalizedStringDto(language: 'EN', text: "New Year's Day")],
        nationwide: true,
      ),
    ];
  }

  @override
  Future<List<HolidayDto>> getSchoolHolidays({
    required String countryIsoCode,
    String language = 'EN',
    required String validFrom,
    required String validTo,
    String? subdivisionCode,
  }) async {
    return [
      const HolidayDto(
        id: '2',
        startDate: '2026-07-01',
        endDate: '2026-08-15',
        type: 'School',
        name: [LocalizedStringDto(language: 'EN', text: 'Summer Break')],
        nationwide: false,
      ),
    ];
  }
}

void main() {
  late HolidayRepositoryImpl repository;
  late FakeOpenHolidaysRemoteDataSource fakeDataSource;

  setUp(() {
    fakeDataSource = FakeOpenHolidaysRemoteDataSource();
    repository = HolidayRepositoryImpl(remoteDataSource: fakeDataSource);
  });

  group('HolidayRepositoryImpl Tests', () {
    test('getCountries returns alphabetically sorted domain countries', () async {
      final countries = await repository.getCountries();
      expect(countries.length, 2);
      expect(countries[0].isoCode, 'DE');
      expect(countries[0].name, 'Germany');
      expect(countries[0].flagEmoji, '🇩🇪');
      expect(countries[1].isoCode, 'US');
      expect(countries[1].name, 'United States');
      expect(countries[1].flagEmoji, '🇺🇸');
    });

    test('getSubdivisions returns mapped subdivisions', () async {
      final subdivisions = await repository.getSubdivisions('DE');
      expect(subdivisions.length, 1);
      expect(subdivisions[0].code, 'DE-BY');
      expect(subdivisions[0].name, 'Bavaria');
    });

    test('getHolidays merges and sorts public and school holidays', () async {
      final holidays = await repository.getHolidays(
        countryIsoCode: 'DE',
        year: 2026,
      );

      expect(holidays.length, 2);
      expect(holidays[0].name, "New Year's Day");
      expect(holidays[0].type, HolidayType.public);
      expect(holidays[0].nationwide, isTrue);

      expect(holidays[1].name, 'Summer Break');
      expect(holidays[1].type, HolidayType.school);
      expect(holidays[1].nationwide, isFalse);
    });
  });
}
