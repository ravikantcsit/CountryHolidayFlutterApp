import '../entities/holiday.dart';
import '../repositories/holiday_repository.dart';

/// Use case to fetch public and school holidays
class GetHolidaysUseCase {
  final HolidayRepository repository;

  GetHolidaysUseCase(this.repository);

  Future<List<Holiday>> call({
    required String countryIsoCode,
    required int year,
    String? subdivisionCode,
    String language = 'EN',
  }) async {
    return await repository.getHolidays(
      countryIsoCode: countryIsoCode,
      year: year,
      subdivisionCode: subdivisionCode,
      language: language,
    );
  }
}
