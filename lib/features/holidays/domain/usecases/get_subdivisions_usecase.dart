import '../entities/subdivision.dart';
import '../repositories/holiday_repository.dart';

/// Use case to fetch regional subdivisions for a country
class GetSubdivisionsUseCase {
  final HolidayRepository repository;

  GetSubdivisionsUseCase(this.repository);

  Future<List<Subdivision>> call(String countryIsoCode) async {
    return await repository.getSubdivisions(countryIsoCode);
  }
}
