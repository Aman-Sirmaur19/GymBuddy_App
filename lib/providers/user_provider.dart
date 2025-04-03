import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import '../database/database.dart' as database;
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final database.AppDatabase db;
  User? _user;

  UserProvider(this.db);

  Future<void> loadUser() async {
    final userData = await db.getUser();
    _user = userData != null
        ? User.fromJson(userData.id.toString(), {
            ...userData.toJson(),
            'weekDays': jsonDecode(userData.weekDays)
            // Convert JSON string to List<String>
          })
        : null;
  }

  User? get user => _user;

  Future<void> updateUser(User user) async {
    final dbUser = database.UsersCompanion(
      id: Value(user.id),
      name: Value(user.name),
      gender: Value(user.gender),
      weight: Value(user.weight),
      height: Value(user.height),
      weekDays: Value(
          jsonEncode(user.weekDays)), // Convert List<String> to JSON string
    );

    await db
        .updateUser(dbUser); // Ensure db.updateUser() accepts UsersCompanion
    _user = user;
    notifyListeners();
  }
}
