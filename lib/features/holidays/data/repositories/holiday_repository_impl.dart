import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/subdivision.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../datasources/open_holidays_remote_data_source.dart';
import '../models/holiday_dto.dart';
import '../models/localized_string_dto.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final OpenHolidaysRemoteDataSource remoteDataSource;

  HolidayRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Country>> getCountries() async {
    final dtos = await remoteDataSource.getCountries();
    final countries = dtos.map((dto) {
      final name = _getLocalizedText(dto.name, 'EN') ?? dto.isoCode;
      return Country(
        isoCode: dto.isoCode,
        name: name,
        officialLanguages: dto.officialLanguages,
      );
    }).toList();

    countries.sort((a, b) => a.name.compareTo(b.name));
    return countries;
  }

  @override
  Future<List<Subdivision>> getSubdivisions(String countryIsoCode) async {
    final dtos = await remoteDataSource.getSubdivisions(countryIsoCode);
    final subdivisions = dtos.map((dto) {
      final name = _getLocalizedText(dto.name, 'EN') ?? dto.code;
      final category = _getLocalizedText(dto.category, 'EN') ?? '';
      return Subdivision(
        code: dto.code,
        name: name,
        category: category,
      );
    }).toList();

    subdivisions.sort((a, b) => a.name.compareTo(b.name));
    return subdivisions;
  }

  @override
  Future<List<Holiday>> getHolidays({
    required String countryIsoCode,
    required int year,
    String? subdivisionCode,
    String language = 'EN',
  }) async {
    final validFrom = '$year-01-01';
    final validTo = '$year-12-31';

    // Parallel retrieval with individual error shielding
    final publicResults = await remoteDataSource.getPublicHolidays(
      countryIsoCode: countryIsoCode,
      language: language,
      validFrom: validFrom,
      validTo: validTo,
      subdivisionCode: subdivisionCode,
    );

    final schoolResults = await remoteDataSource.getSchoolHolidays(
      countryIsoCode: countryIsoCode,
      language: language,
      validFrom: validFrom,
      validTo: validTo,
      subdivisionCode: subdivisionCode,
    );

    final publicHolidays = publicResults.map(
      (dto) => _mapHolidayDtoToDomain(dto, HolidayType.public, language),
    );

    final schoolHolidays = schoolResults.map(
      (dto) => _mapHolidayDtoToDomain(dto, HolidayType.school, language),
    );

    // Merge and deduplicate by key: name_startDate_type
    final combined = [...publicHolidays, ...schoolHolidays];
    final seenKeys = <String>{};
    final deduplicated = <Holiday>[];

    for (final h in combined) {
      final key = '${h.name}_${h.startDate}_${h.type.name}';
      if (seenKeys.add(key)) {
        deduplicated.add(h);
      }
    }

    // Sort chronologically
    deduplicated.sort((a, b) => a.startDate.compareTo(b.startDate));
    return deduplicated;
  }

  Holiday _mapHolidayDtoToDomain(
    HolidayDto dto,
    HolidayType defaultType,
    String language,
  ) {
    final name = _getLocalizedText(dto.name, language) ??
        _getLocalizedText(dto.name, 'EN') ??
        'Holiday';
    final comment = _getLocalizedText(dto.comment, language);

    final durationDays = AppDateUtils.calculateDurationDays(
      dto.startDate,
      dto.endDate,
    );
    final status = AppDateUtils.getHolidayStatus(dto.startDate, dto.endDate);
    final daysRemaining = AppDateUtils.getDaysRemaining(dto.startDate);

    final subCodes = dto.subdivisions
        .map((s) => s.shortName ?? s.code ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    return Holiday(
      id: dto.id ?? '${dto.startDate}_$name',
      name: name,
      startDate: dto.startDate,
      endDate: dto.endDate,
      type: defaultType,
      comment: comment,
      nationwide: dto.nationwide,
      regionalScope: dto.regionalScope,
      subdivisions: subCodes,
      status: status,
      daysRemaining: daysRemaining,
      durationDays: durationDays,
    );
  }

  String? _getLocalizedText(
    List<LocalizedStringDto>? list,
    String targetLanguage,
  ) {
    if (list == null || list.isEmpty) return null;

    final targetLower = targetLanguage.toLowerCase();
    for (final item in list) {
      if (item.language?.toLowerCase() == targetLower && item.text != null) {
        return item.text;
      }
    }

    for (final item in list) {
      if (item.language?.toLowerCase() == 'en' && item.text != null) {
        return item.text;
      }
    }

    return list.first.text;
  }
}
