import '../entities/country.dart';
import '../repositories/holiday_repository.dart';

/// Use case to fetch sorted sovereign countries
class GetCountriesUseCase {
  final HolidayRepository repository;

  GetCountriesUseCase(this.repository);

  Future<List<Country>> call() async {
    return await repository.getCountries();
  }
}
