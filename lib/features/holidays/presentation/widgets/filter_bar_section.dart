import 'package:flutter/material.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/subdivision.dart';

/// Interactive filter bar with Year chips, Subdivision chips, and Holiday Type tabs
class FilterBarSection extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int> onYearSelected;
  final HolidayType selectedTab;
  final ValueChanged<HolidayType> onTabSelected;
  final List<Subdivision> subdivisions;
  final Subdivision? selectedSubdivision;
  final ValueChanged<Subdivision?> onSubdivisionSelected;

  const FilterBarSection({
    super.key,
    required this.selectedYear,
    required this.onYearSelected,
    required this.selectedTab,
    required this.onTabSelected,
    required this.subdivisions,
    required this.selectedSubdivision,
    required this.onSubdivisionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = const [2024, 2025, 2026, 2027];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Year Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: years.map((year) {
              final isSelected = selectedYear == year;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(
                    '$year',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primary,
                  checkmarkColor: theme.colorScheme.onPrimary,
                  onSelected: (_) => onYearSelected(year),
                ),
              );
            }).toList(),
          ),
        ),

        // Subdivision Chips (if available)
        if (subdivisions.isNotEmpty) ...[
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('All States / Regions'),
                    selected: selectedSubdivision == null,
                    onSelected: (_) => onSubdivisionSelected(null),
                  ),
                ),
                ...subdivisions.map((sub) {
                  final isSelected = selectedSubdivision?.code == sub.code;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(sub.name),
                      selected: isSelected,
                      onSelected: (_) => onSubdivisionSelected(sub),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],

        const SizedBox(height: 6),

        // Segmented Control (All / Public / School)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: SegmentedButton<HolidayType>(
            segments: const [
              ButtonSegment(
                value: HolidayType.all,
                label: Text('All'),
              ),
              ButtonSegment(
                value: HolidayType.public,
                label: Text('Public'),
              ),
              ButtonSegment(
                value: HolidayType.school,
                label: Text('School'),
              ),
            ],
            selected: {selectedTab},
            onSelectionChanged: (newSelection) {
              if (newSelection.isNotEmpty) {
                onTabSelected(newSelection.first);
              }
            },
          ),
        ),
      ],
    );
  }
}
