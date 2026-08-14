import '../entities/country.dart';
import '../entities/subdivision.dart';
import '../entities/holiday.dart';

/// Abstract contract for Holiday data management
abstract class HolidayRepository {
  Future<List<Country>> getCountries();

  Future<List<Subdivision>> getSubdivisions(String countryIsoCode);

  Future<List<Holiday>> getHolidays({
    required String countryIsoCode,
    required int year,
    String? subdivisionCode,
    String language = 'EN',
  });
}
