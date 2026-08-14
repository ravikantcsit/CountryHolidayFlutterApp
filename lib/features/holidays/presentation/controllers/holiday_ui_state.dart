import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/subdivision.dart';
import '../../domain/entities/holiday.dart';

/// Immutable presentation state class for the Holiday Dashboard
class HolidayUiState {
  final bool isLoadingCountries;
  final bool isLoadingHolidays;
  final List<Country> countries;
  final Country? selectedCountry;
  final List<Subdivision> subdivisions;
  final Subdivision? selectedSubdivision;
  final int selectedYear;
  final HolidayType selectedTab;
  final String searchQuery;
  final List<Holiday> rawHolidays;
  final List<Holiday> filteredHolidays;
  final Holiday? nextHoliday;
  final Holiday? selectedHolidayDetails;
  final String? errorMessage;

  HolidayUiState({
    this.isLoadingCountries = false,
    this.isLoadingHolidays = false,
    this.countries = const [],
    this.selectedCountry,
    this.subdivisions = const [],
    this.selectedSubdivision,
    int? selectedYear,
    this.selectedTab = HolidayType.all,
    this.searchQuery = '',
    this.rawHolidays = const [],
    this.filteredHolidays = const [],
    this.nextHoliday,
    this.selectedHolidayDetails,
    this.errorMessage,
  }) : selectedYear = selectedYear ?? AppDateUtils.getCurrentYear();

  HolidayUiState copyWith({
    bool? isLoadingCountries,
    bool? isLoadingHolidays,
    List<Country>? countries,
    Country? selectedCountry,
    bool clearSelectedCountry = false,
    List<Subdivision>? subdivisions,
    Subdivision? selectedSubdivision,
    bool clearSelectedSubdivision = false,
    int? selectedYear,
    HolidayType? selectedTab,
    String? searchQuery,
    List<Holiday>? rawHolidays,
    List<Holiday>? filteredHolidays,
    Holiday? nextHoliday,
    bool clearNextHoliday = false,
    Holiday? selectedHolidayDetails,
    bool clearSelectedHolidayDetails = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HolidayUiState(
      isLoadingCountries: isLoadingCountries ?? this.isLoadingCountries,
      isLoadingHolidays: isLoadingHolidays ?? this.isLoadingHolidays,
      countries: countries ?? this.countries,
      selectedCountry: clearSelectedCountry
          ? null
          : (selectedCountry ?? this.selectedCountry),
      subdivisions: subdivisions ?? this.subdivisions,
      selectedSubdivision: clearSelectedSubdivision
          ? null
          : (selectedSubdivision ?? this.selectedSubdivision),
      selectedYear: selectedYear ?? this.selectedYear,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      rawHolidays: rawHolidays ?? this.rawHolidays,
      filteredHolidays: filteredHolidays ?? this.filteredHolidays,
      nextHoliday:
          clearNextHoliday ? null : (nextHoliday ?? this.nextHoliday),
      selectedHolidayDetails: clearSelectedHolidayDetails
          ? null
          : (selectedHolidayDetails ?? this.selectedHolidayDetails),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
