/// DTO representing localized multi-language text entries
class LocalizedStringDto {
  final String? language;
  final String? text;

  const LocalizedStringDto({
    this.language,
    this.text,
  });

  factory LocalizedStringDto.fromJson(Map<String, dynamic> json) {
    return LocalizedStringDto(
      language: json['language'] as String?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'text': text,
    };
  }
}
