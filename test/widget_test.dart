import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_holiday_app/app.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/country.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/holiday.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/subdivision.dart';
import 'package:country_holiday_app/features/holidays/domain/repositories/holiday_repository.dart';
import 'package:country_holiday_app/features/holidays/presentation/controllers/holiday_controller.dart';

class SmokeTestHolidayRepository implements HolidayRepository {
  @override
  Future<List<Country>> getCountries() async => [Country(isoCode: 'DE', name: 'Germany')];

  @override
  Future<List<Subdivision>> getSubdivisions(String countryIsoCode) async => [];

  @override
  Future<List<Holiday>> getHolidays({
    required String countryIsoCode,
    required int year,
    String? subdivisionCode,
    String language = 'EN',
  }) async => [];
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          holidayRepositoryProvider.overrideWithValue(SmokeTestHolidayRepository()),
        ],
        child: const CountryHolidayApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CountryHolidayApp), findsOneWidget);
  });
}
