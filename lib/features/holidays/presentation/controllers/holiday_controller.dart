import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/open_holidays_remote_data_source.dart';
import '../../data/repositories/holiday_repository_impl.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/subdivision.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../../domain/usecases/get_countries_usecase.dart';
import '../../domain/usecases/get_subdivisions_usecase.dart';
import '../../domain/usecases/get_holidays_usecase.dart';
import 'holiday_ui_state.dart';

// --- Dependency Injection Providers ---

final dioProvider = Provider((ref) => DioClient.createDio());

final openHolidaysRemoteDataSourceProvider =
    Provider<OpenHolidaysRemoteDataSource>(
  (ref) => OpenHolidaysRemoteDataSourceImpl(dio: ref.watch(dioProvider)),
);

final holidayRepositoryProvider = Provider<HolidayRepository>(
  (ref) => HolidayRepositoryImpl(
    remoteDataSource: ref.watch(openHolidaysRemoteDataSourceProvider),
  ),
);

final getCountriesUseCaseProvider = Provider(
  (ref) => GetCountriesUseCase(ref.watch(holidayRepositoryProvider)),
);

final getSubdivisionsUseCaseProvider = Provider(
  (ref) => GetSubdivisionsUseCase(ref.watch(holidayRepositoryProvider)),
);

final getHolidaysUseCaseProvider = Provider(
  (ref) => GetHolidaysUseCase(ref.watch(holidayRepositoryProvider)),
);

final holidayNotifierProvider =
    NotifierProvider<HolidayNotifier, HolidayUiState>(
  HolidayNotifier.new,
);

// --- Notifier Implementation ---

class HolidayNotifier extends Notifier<HolidayUiState> {
  @override
  HolidayUiState build() {
    final initialState = HolidayUiState();
    // Trigger initial fetch asynchronously
    Future.microtask(() => loadCountries());
    return initialState;
  }

  GetCountriesUseCase get _getCountriesUseCase =>
      ref.read(getCountriesUseCaseProvider);
  GetSubdivisionsUseCase get _getSubdivisionsUseCase =>
      ref.read(getSubdivisionsUseCaseProvider);
  GetHolidaysUseCase get _getHolidaysUseCase =>
      ref.read(getHolidaysUseCaseProvider);

  Future<void> loadCountries() async {
    state = state.copyWith(isLoadingCountries: true, clearErrorMessage: true);
    try {
      final countryList = await _getCountriesUseCase();

      // BR-01: Default to DE -> US -> First country
      Country? defaultCountry;
      try {
        defaultCountry = countryList.firstWhere((c) => c.isoCode == 'DE');
      } catch (_) {
        try {
          defaultCountry = countryList.firstWhere((c) => c.isoCode == 'US');
        } catch (_) {
          defaultCountry = countryList.isNotEmpty ? countryList.first : null;
        }
      }

      state = state.copyWith(
        isLoadingCountries: false,
        countries: countryList,
        selectedCountry: defaultCountry,
      );

      if (defaultCountry != null) {
        await _loadSubdivisionsAndHolidays(
          defaultCountry.isoCode,
          state.selectedYear,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingCountries: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> selectCountry(Country country) async {
    if (state.selectedCountry?.isoCode == country.isoCode) return;

    state = state.copyWith(
      selectedCountry: country,
      clearSelectedSubdivision: true,
      searchQuery: '',
    );

    await _loadSubdivisionsAndHolidays(country.isoCode, state.selectedYear);
  }

  Future<void> selectSubdivision(Subdivision? subdivision) async {
    state = state.copyWith(
      selectedSubdivision: subdivision,
      clearSelectedSubdivision: subdivision == null,
    );

    final countryIso = state.selectedCountry?.isoCode;
    if (countryIso == null) return;

    await _fetchHolidays(
      countryIso,
      state.selectedYear,
      subdivision?.code,
    );
  }

  Future<void> selectYear(int year) async {
    if (state.selectedYear == year) return;

    state = state.copyWith(selectedYear: year);
    final countryIso = state.selectedCountry?.isoCode;
    if (countryIso == null) return;

    await _fetchHolidays(
      countryIso,
      year,
      state.selectedSubdivision?.code,
    );
  }

  void selectTab(HolidayType tab) {
    state = state.copyWith(selectedTab: tab);
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void showHolidayDetails(Holiday? holiday) {
    state = state.copyWith(
      selectedHolidayDetails: holiday,
      clearSelectedHolidayDetails: holiday == null,
    );
  }

  Future<void> retry() async {
    final selected = state.selectedCountry;
    if (selected == null) {
      await loadCountries();
    } else {
      await _loadSubdivisionsAndHolidays(selected.isoCode, state.selectedYear);
    }
  }

  Future<void> _loadSubdivisionsAndHolidays(
    String countryIsoCode,
    int year,
  ) async {
    try {
      final subList = await _getSubdivisionsUseCase(countryIsoCode);
      state = state.copyWith(
        subdivisions: subList,
        clearSelectedSubdivision: true,
      );
    } catch (_) {
      state = state.copyWith(
        subdivisions: [],
        clearSelectedSubdivision: true,
      );
    }

    await _fetchHolidays(countryIsoCode, year, null);
  }

  Future<void> _fetchHolidays(
    String countryIsoCode,
    int year,
    String? subdivisionCode,
  ) async {
    state = state.copyWith(isLoadingHolidays: true, clearErrorMessage: true);
    try {
      final holidays = await _getHolidaysUseCase(
        countryIsoCode: countryIsoCode,
        year: year,
        subdivisionCode: subdivisionCode,
      );

      state = state.copyWith(
        isLoadingHolidays: false,
        rawHolidays: holidays,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoadingHolidays: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _applyFilters() {
    final raw = state.rawHolidays;
    final query = state.searchQuery.trim().toLowerCase();
    final tab = state.selectedTab;

    final filtered = raw.where((holiday) {
      // Tab filter
      final matchesTab = switch (tab) {
        HolidayType.all => true,
        HolidayType.public => holiday.type == HolidayType.public,
        HolidayType.school => holiday.type == HolidayType.school,
      };

      // Search filter
      final matchesSearch = query.isEmpty ||
          holiday.name.toLowerCase().contains(query) ||
          (holiday.comment?.toLowerCase().contains(query) ?? false);

      return matchesTab && matchesSearch;
    }).toList();

    // BR-10: Next upcoming holiday for Hero Card
    Holiday? nextUpcoming;
    try {
      nextUpcoming = raw.firstWhere(
        (h) =>
            h.status == HolidayStatus.upcoming ||
            h.status == HolidayStatus.today,
      );
    } catch (_) {
      nextUpcoming = null;
    }

    state = state.copyWith(
      filteredHolidays: filtered,
      nextHoliday: nextUpcoming,
      clearNextHoliday: nextUpcoming == null,
    );
  }
}
