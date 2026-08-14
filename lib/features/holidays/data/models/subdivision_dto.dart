import 'localized_string_dto.dart';

/// DTO for Subdivision endpoint response
class SubdivisionDto {
  final String code;
  final String? isoCode;
  final String? shortName;
  final List<LocalizedStringDto> category;
  final List<LocalizedStringDto> name;
  final List<String> officialLanguages;

  const SubdivisionDto({
    required this.code,
    this.isoCode,
    this.shortName,
    this.category = const [],
    this.name = const [],
    this.officialLanguages = const [],
  });

  factory SubdivisionDto.fromJson(Map<String, dynamic> json) {
    return SubdivisionDto(
      code: json['code'] as String? ?? '',
      isoCode: json['isoCode'] as String?,
      shortName: json['shortName'] as String?,
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => LocalizedStringDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      name: (json['name'] as List<dynamic>?)
              ?.map((e) => LocalizedStringDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      officialLanguages: (json['officialLanguages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
