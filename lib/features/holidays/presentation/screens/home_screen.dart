import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/holiday_controller.dart';
import '../widgets/country_picker_sheet.dart';
import '../widgets/error_view.dart';
import '../widgets/filter_bar_section.dart';
import '../widgets/holiday_card.dart';
import '../widgets/holiday_detail_sheet.dart';
import '../widgets/loading_view.dart';
import '../widgets/next_holiday_hero_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/top_app_bar_header.dart';

/// Main Holiday Dashboard screen
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(holidayNotifierProvider);
    final controller = ref.read(holidayNotifierProvider.notifier);

    return Scaffold(
      appBar: TopAppBarHeader(
        selectedCountry: state.selectedCountry,
        onCountryClick: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => CountryPickerSheet(
              countries: state.countries,
              selectedCountry: state.selectedCountry,
              onCountrySelected: (c) => controller.selectCountry(c),
            ),
          );
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Column(
            children: [
              // Search Input
              SearchBarWidget(
                query: state.searchQuery,
                onQueryChange: (q) => controller.updateSearchQuery(q),
              ),

              // Filters (Years, Subdivisions, Holiday Types)
              FilterBarSection(
                selectedYear: state.selectedYear,
                onYearSelected: (y) => controller.selectYear(y),
                selectedTab: state.selectedTab,
                onTabSelected: (t) => controller.selectTab(t),
                subdivisions: state.subdivisions,
                selectedSubdivision: state.selectedSubdivision,
                onSubdivisionSelected: (s) => controller.selectSubdivision(s),
              ),

              // Content Feed
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoadingHolidays || state.isLoadingCountries) {
                      return const LoadingView();
                    }

                    if (state.errorMessage != null) {
                      return ErrorView(
                        message: state.errorMessage!,
                        onRetry: () => controller.retry(),
                      );
                    }

                    if (state.filteredHolidays.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            state.searchQuery.isNotEmpty
                                ? 'No holidays found matching "${state.searchQuery}"'
                                : 'No holidays recorded for this selection.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final showHero = state.searchQuery.isEmpty &&
                        state.nextHoliday != null;

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 32),
                      itemCount: state.filteredHolidays.length + (showHero ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (showHero && index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NextHolidayHeroCard(
                                nextHoliday: state.nextHoliday,
                                onCardClick: (holiday) {
                                  _showHolidayDetails(context, holiday);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  'All ${state.selectedYear} Holidays (${state.filteredHolidays.length})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        }

                        final holidayIndex = showHero ? index - 1 : index;
                        final holiday = state.filteredHolidays[holidayIndex];

                        return HolidayCard(
                          holiday: holiday,
                          onClick: () => _showHolidayDetails(context, holiday),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHolidayDetails(BuildContext context, dynamic holiday) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => HolidayDetailSheet(holiday: holiday),
    );
  }
}
