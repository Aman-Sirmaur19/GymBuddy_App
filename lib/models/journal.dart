import '../database/database.dart';

class Journal {
  final String id;
  final String note;
  final DateTime date; // only date (e.g. 2025-04-06)
  final DateTime time; // time when it was written (e.g. 2025-04-07 15:45)

  Journal({
    required this.id,
    required this.note,
    required this.date,
    required this.time,
  });

  factory Journal.fromJson(String id, Map<String, dynamic> json) {
    return Journal(
      id: id,
      note: json['note'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
    };
  }

  factory Journal.fromDrift(JournalEntry entry) {
    return Journal(
      id: entry.id,
      note: entry.note,
      date: DateTime.parse(entry.date),
      time: DateTime.parse(entry.time),
    );
  }
}
