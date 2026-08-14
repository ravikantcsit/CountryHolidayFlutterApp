import 'localized_string_dto.dart';

/// DTO for Subdivision inside Holiday response
class HolidaySubdivisionDto {
  final String? code;
  final String? shortName;

  const HolidaySubdivisionDto({this.code, this.shortName});

  factory HolidaySubdivisionDto.fromJson(Map<String, dynamic> json) {
    return HolidaySubdivisionDto(
      code: json['code'] as String?,
      shortName: json['shortName'] as String?,
    );
  }
}

/// DTO for Public and School Holidays responses
class HolidayDto {
  final String? id;
  final String startDate;
  final String endDate;
  final String? type;
  final List<LocalizedStringDto> name;
  final List<LocalizedStringDto> comment;
  final bool nationwide;
  final String? regionalScope;
  final String? temporalScope;
  final List<HolidaySubdivisionDto> subdivisions;

  const HolidayDto({
    this.id,
    required this.startDate,
    required this.endDate,
    this.type,
    this.name = const [],
    this.comment = const [],
    this.nationwide = true,
    this.regionalScope,
    this.temporalScope,
    this.subdivisions = const [],
  });

  factory HolidayDto.fromJson(Map<String, dynamic> json) {
    return HolidayDto(
      id: json['id'] as String?,
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      type: json['type'] as String?,
      name: (json['name'] as List<dynamic>?)
              ?.map((e) => LocalizedStringDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      comment: (json['comment'] as List<dynamic>?)
              ?.map((e) => LocalizedStringDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nationwide: json['nationwide'] as bool? ?? true,
      regionalScope: json['regionalScope'] as String?,
      temporalScope: json['temporalScope'] as String?,
      subdivisions: (json['subdivisions'] as List<dynamic>?)
              ?.map((e) =>
                  HolidaySubdivisionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
