import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:country_holiday_app/features/holidays/domain/entities/holiday.dart';
import 'package:country_holiday_app/features/holidays/presentation/widgets/holiday_card.dart';

void main() {
  testWidgets('HolidayCard renders name, dates, and badges accurately',
      (tester) async {
    const holiday = Holiday(
      id: '1',
      name: 'Independence Day',
      startDate: '2026-07-04',
      endDate: '2026-07-04',
      type: HolidayType.public,
      nationwide: true,
    );

    var clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HolidayCard(
            holiday: holiday,
            onClick: () => clicked = true,
          ),
        ),
      ),
    );

    expect(find.text('Independence Day'), findsOneWidget);
    expect(find.text('2026-07-04'), findsOneWidget);
    expect(find.text('Public'), findsOneWidget);
    expect(find.text('Nationwide'), findsOneWidget);

    await tester.tap(find.byType(HolidayCard));
    expect(clicked, isTrue);
  });
}
