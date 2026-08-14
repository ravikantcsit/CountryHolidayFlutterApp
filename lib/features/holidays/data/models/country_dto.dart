import 'localized_string_dto.dart';

/// DTO for Country endpoint response
class CountryDto {
  final String isoCode;
  final List<LocalizedStringDto> name;
  final List<String> officialLanguages;

  const CountryDto({
    required this.isoCode,
    this.name = const [],
    this.officialLanguages = const [],
  });

  factory CountryDto.fromJson(Map<String, dynamic> json) {
    return CountryDto(
      isoCode: json['isoCode'] as String? ?? '',
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

  Map<String, dynamic> toJson() {
    return {
      'isoCode': isoCode,
      'name': name.map((e) => e.toJson()).toList(),
      'officialLanguages': officialLanguages,
    };
  }
}
