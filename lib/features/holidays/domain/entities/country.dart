import '../../../../core/utils/flag_utils.dart';

/// Pure domain entity representing a sovereign country
class Country {
  final String isoCode;
  final String name;
  final List<String> officialLanguages;
  final String flagEmoji;

  Country({
    required this.isoCode,
    required this.name,
    this.officialLanguages = const [],
    String? flagEmoji,
  }) : flagEmoji = flagEmoji ?? FlagUtils.getCountryFlagEmoji(isoCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() => 'Country(isoCode: $isoCode, name: $name, flag: $flagEmoji)';
}
