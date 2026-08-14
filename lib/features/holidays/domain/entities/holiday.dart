enum HolidayType {
  public,
  school,
  all,
}

enum HolidayStatus {
  today,
  upcoming,
  past,
}

/// Pure domain entity representing a public or school holiday
class Holiday {
  final String id;
  final String name;
  final String startDate; // yyyy-MM-dd
  final String endDate; // yyyy-MM-dd
  final HolidayType type;
  final String? comment;
  final bool nationwide;
  final String? regionalScope;
  final List<String> subdivisions;
  final HolidayStatus status;
  final int? daysRemaining;
  final int durationDays;

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.comment,
    this.nationwide = true,
    this.regionalScope,
    this.subdivisions = const [],
    this.status = HolidayStatus.upcoming,
    this.daysRemaining,
    this.durationDays = 1,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Holiday &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Holiday(id: $id, name: $name, start: $startDate, end: $endDate, type: $type, status: $status)';
}
