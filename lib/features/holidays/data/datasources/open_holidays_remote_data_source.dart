import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/country_dto.dart';
import '../models/subdivision_dto.dart';
import '../models/holiday_dto.dart';

abstract class OpenHolidaysRemoteDataSource {
  Future<List<CountryDto>> getCountries();

  Future<List<SubdivisionDto>> getSubdivisions(String countryIsoCode);

  Future<List<HolidayDto>> getPublicHolidays({
    required String countryIsoCode,
    String language = ApiConstants.defaultLanguage,
    required String validFrom,
    required String validTo,
    String? subdivisionCode,
  });

  Future<List<HolidayDto>> getSchoolHolidays({
    required String countryIsoCode,
    String language = ApiConstants.defaultLanguage,
    required String validFrom,
    required String validTo,
    String? subdivisionCode,
  });
}

class OpenHolidaysRemoteDataSourceImpl implements OpenHolidaysRemoteDataSource {
  final Dio dio;

  OpenHolidaysRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CountryDto>> getCountries() async {
    try {
      final response = await dio.get(ApiConstants.countriesEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => CountryDto.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerFailure('Failed to load countries', statusCode: response.statusCode);
    } on DioException catch (e) {
      throw NetworkFailure(e.message ?? 'Network error fetching countries');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<SubdivisionDto>> getSubdivisions(String countryIsoCode) async {
    try {
      final response = await dio.get(
        ApiConstants.subdivisionsEndpoint,
        queryParameters: {'countryIsoCode': countryIsoCode},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => SubdivisionDto.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw NetworkFailure(e.message ?? 'Network error fetching subdivisions');
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<HolidayDto>> getPublicHolidays({
    required String countryIsoCode,
    String language = ApiConstants.defaultLanguage,
    required String validFrom,
    required String validTo,
    String? subdivisionCode,
  }) async {
    try {
      final query = <String, dynamic>{
        'countryIsoCode': countryIsoCode,
        'languageIsoCode': language,
        'validFrom': validFrom,
        'validTo': validTo,
      };
      if (subdivisionCode != null && subdivisionCode.isNotEmpty) {
        query['subdivisionCode'] = subdivisionCode;
      }

      final response = await dio.get(
        ApiConstants.publicHolidaysEndpoint,
        queryParameters: query,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => HolidayDto.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<HolidayDto>> getSchoolHolidays({
    required String countryIsoCode,
    String language = ApiConstants.defaultLanguage,
    required String validFrom,
    required String validTo,
    String? subdivisionCode,
  }) async {
    try {
      final query = <String, dynamic>{
        'countryIsoCode': countryIsoCode,
        'languageIsoCode': language,
        'validFrom': validFrom,
        'validTo': validTo,
      };
      if (subdivisionCode != null && subdivisionCode.isNotEmpty) {
        query['subdivisionCode'] = subdivisionCode;
      }

      final response = await dio.get(
        ApiConstants.schoolHolidaysEndpoint,
        queryParameters: query,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => HolidayDto.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
