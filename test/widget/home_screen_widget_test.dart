import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/country.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/holiday.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/subdivision.dart';
import 'package:country_holiday_app/features/holidays/domain/repositories/holiday_repository.dart';
import 'package:country_holiday_app/features/holidays/presentation/controllers/holiday_controller.dart';
import 'package:country_holiday_app/features/holidays/presentation/screens/home_screen.dart';

class FakeHolidayRepository implements HolidayRepository {
  @override
  Future<List<Country>> getCountries() async {
    return [
      Country(isoCode: 'DE', name: 'Germany'),
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
    ];
  }
}

void main() {
  testWidgets('HomeScreen renders header, search bar, filters, and holiday cards',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          holidayRepositoryProvider.overrideWithValue(FakeHolidayRepository()),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Initial pump & settling microtasks
    await tester.pumpAndSettle();

    expect(find.text('Global Holidays'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Search holiday name...'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Public'), findsWidgets);
    expect(find.text('School'), findsOneWidget);
    expect(find.text("New Year's Day"), findsWidgets);
  });
}
