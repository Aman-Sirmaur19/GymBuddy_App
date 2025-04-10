import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import '../database/database.dart' as database;
import '../models/journal.dart';

class JournalProvider extends ChangeNotifier {
  final database.AppDatabase db;

  JournalProvider(this.db);

  List<Journal> _journals = [];

  List<Journal> get journals => _journals;

  /// Fetch and update journal list for selected date
  Future<void> fetchJournalsByDate(DateTime date) async {
    final driftJournals = await db.getJournalsByDate(date);
    _journals = driftJournals.map((j) => Journal.fromDrift(j)).toList();
    notifyListeners();
  }

  /// Optional: fetch all journals if needed elsewhere
  Future<List<Journal>> getAllJournals() async {
    final entries = await db.getAllJournals();
    return entries.map((j) => Journal.fromDrift(j)).toList();
  }

  /// Add or update journal
  Future<void> addOrUpdateJournal(Journal journal) async {
    final journalCompanion = database.JournalsCompanion(
      id: Value(journal.id),
      note: Value(journal.note),
      date: Value(journal.date.toIso8601String().split('T').first),
      time: Value(journal.time.toIso8601String()),
    );

    await db.insertJournal(journalCompanion);
    await fetchJournalsByDate(journal.date); // Refresh after insert/update
  }

  /// Delete journal by id
  Future<void> deleteJournal(String id, DateTime date) async {
    await db.deleteJournalById(id);
    await fetchJournalsByDate(date); // Refresh after deletion
  }
}
