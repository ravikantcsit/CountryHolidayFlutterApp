/// Pure domain entity representing an administrative state, canton, or province
class Subdivision {
  final String code;
  final String name;
  final String category;

  const Subdivision({
    required this.code,
    required this.name,
    this.category = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subdivision &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Subdivision(code: $code, name: $name, category: $category)';
}
