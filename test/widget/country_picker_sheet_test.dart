import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/country.dart';
import 'package:country_holiday_app/features/holidays/presentation/widgets/country_picker_sheet.dart';

void main() {
  testWidgets('CountryPickerSheet displays countries and filters on input',
      (tester) async {
    final countries = [
      Country(isoCode: 'DE', name: 'Germany'),
      Country(isoCode: 'FR', name: 'France'),
      Country(isoCode: 'US', name: 'United States'),
    ];

    Country? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountryPickerSheet(
            countries: countries,
            selectedCountry: countries[0],
            onCountrySelected: (c) => selected = c,
          ),
        ),
      ),
    );

    expect(find.text('Select Country'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
    expect(find.text('United States'), findsOneWidget);

    // Search filter
    await tester.enterText(find.byType(TextField), 'fra');
    await tester.pump();

    expect(find.text('Germany'), findsNothing);
    expect(find.text('France'), findsOneWidget);
    expect(find.text('United States'), findsNothing);

    // Tap France
    await tester.tap(find.text('France'));
    expect(selected?.isoCode, 'FR');
  });
}
