import 'package:flutter_test/flutter_test.dart';
import 'package:country_holiday_app/core/network/dio_client.dart';
import 'package:country_holiday_app/features/holidays/data/datasources/open_holidays_remote_data_source.dart';
import 'package:country_holiday_app/features/holidays/data/repositories/holiday_repository_impl.dart';

void main() {
  test('Live network test against openholidaysapi.org', () async {
    final dio = DioClient.createDio();
    final dataSource = OpenHolidaysRemoteDataSourceImpl(dio: dio);
    final repository = HolidayRepositoryImpl(remoteDataSource: dataSource);

    final countries = await repository.getCountries();
    expect(countries, isNotEmpty);
    expect(countries.any((c) => c.isoCode == 'DE'), isTrue);

    final holidays = await repository.getHolidays(
      countryIsoCode: 'DE',
      year: 2026,
    );
    expect(holidays, isNotEmpty);
  }, tags: ['integration']);
}
