/// API Constants for OpenHolidays REST API
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://openholidaysapi.org';
  static const String countriesEndpoint = '/Countries';
  static const String subdivisionsEndpoint = '/Subdivisions';
  static const String publicHolidaysEndpoint = '/PublicHolidays';
  static const String schoolHolidaysEndpoint = '/SchoolHolidays';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String defaultLanguage = 'EN';
  static const String userAgent =
      'Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';
}
