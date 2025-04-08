// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _weekDaysMeta =
      const VerificationMeta('weekDays');
  @override
  late final GeneratedColumn<String> weekDays = GeneratedColumn<String>(
      'week_days', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, gender, weight, height, weekDays];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('week_days')) {
      context.handle(_weekDaysMeta,
          weekDays.isAcceptableOrUnknown(data['week_days']!, _weekDaysMeta));
    } else if (isInserting) {
      context.missing(_weekDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height'])!,
      weekDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}week_days'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String gender;
  final double weight;
  final double height;
  final String weekDays;
  const User(
      {required this.id,
      required this.name,
      required this.gender,
      required this.weight,
      required this.height,
      required this.weekDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['gender'] = Variable<String>(gender);
    map['weight'] = Variable<double>(weight);
    map['height'] = Variable<double>(height);
    map['week_days'] = Variable<String>(weekDays);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      weight: Value(weight),
      height: Value(height),
      weekDays: Value(weekDays),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String>(json['gender']),
      weight: serializer.fromJson<double>(json['weight']),
      height: serializer.fromJson<double>(json['height']),
      weekDays: serializer.fromJson<String>(json['weekDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String>(gender),
      'weight': serializer.toJson<double>(weight),
      'height': serializer.toJson<double>(height),
      'weekDays': serializer.toJson<String>(weekDays),
    };
  }

  User copyWith(
          {String? id,
          String? name,
          String? gender,
          double? weight,
          double? height,
          String? weekDays}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        weekDays: weekDays ?? this.weekDays,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('weekDays: $weekDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, gender, weight, height, weekDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.weekDays == this.weekDays);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> gender;
  final Value<double> weight;
  final Value<double> height;
  final Value<String> weekDays;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.weekDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String gender,
    required double weight,
    required double height,
    required String weekDays,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        gender = Value(gender),
        weight = Value(weight),
        height = Value(height),
        weekDays = Value(weekDays);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<double>? weight,
    Expression<double>? height,
    Expression<String>? weekDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (weekDays != null) 'week_days': weekDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? gender,
      Value<double>? weight,
      Value<double>? height,
      Value<String>? weekDays,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      weekDays: weekDays ?? this.weekDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (weekDays.present) {
      map['week_days'] = Variable<String>(weekDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('weekDays: $weekDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _forceMeta = const VerificationMeta('force');
  @override
  late final GeneratedColumn<String> force = GeneratedColumn<String>(
      'force', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mechanicMeta =
      const VerificationMeta('mechanic');
  @override
  late final GeneratedColumn<String> mechanic = GeneratedColumn<String>(
      'mechanic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryMusclesMeta =
      const VerificationMeta('primaryMuscles');
  @override
  late final GeneratedColumn<String> primaryMuscles = GeneratedColumn<String>(
      'primary_muscles', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _secondaryMusclesMeta =
      const VerificationMeta('secondaryMuscles');
  @override
  late final GeneratedColumn<String> secondaryMuscles = GeneratedColumn<String>(
      'secondary_muscles', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        force,
        level,
        mechanic,
        equipment,
        primaryMuscles,
        secondaryMuscles,
        instructions,
        category,
        isCustom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('force')) {
      context.handle(
          _forceMeta, force.isAcceptableOrUnknown(data['force']!, _forceMeta));
    } else if (isInserting) {
      context.missing(_forceMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('mechanic')) {
      context.handle(_mechanicMeta,
          mechanic.isAcceptableOrUnknown(data['mechanic']!, _mechanicMeta));
    } else if (isInserting) {
      context.missing(_mechanicMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('primary_muscles')) {
      context.handle(
          _primaryMusclesMeta,
          primaryMuscles.isAcceptableOrUnknown(
              data['primary_muscles']!, _primaryMusclesMeta));
    } else if (isInserting) {
      context.missing(_primaryMusclesMeta);
    }
    if (data.containsKey('secondary_muscles')) {
      context.handle(
          _secondaryMusclesMeta,
          secondaryMuscles.isAcceptableOrUnknown(
              data['secondary_muscles']!, _secondaryMusclesMeta));
    } else if (isInserting) {
      context.missing(_secondaryMusclesMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      force: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}force'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      mechanic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mechanic'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      primaryMuscles: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_muscles'])!,
      secondaryMuscles: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}secondary_muscles'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String name;
  final String force;
  final String level;
  final String mechanic;
  final String equipment;
  final String primaryMuscles;
  final String secondaryMuscles;
  final String instructions;
  final String category;
  final bool isCustom;
  const Exercise(
      {required this.id,
      required this.name,
      required this.force,
      required this.level,
      required this.mechanic,
      required this.equipment,
      required this.primaryMuscles,
      required this.secondaryMuscles,
      required this.instructions,
      required this.category,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['force'] = Variable<String>(force);
    map['level'] = Variable<String>(level);
    map['mechanic'] = Variable<String>(mechanic);
    map['equipment'] = Variable<String>(equipment);
    map['primary_muscles'] = Variable<String>(primaryMuscles);
    map['secondary_muscles'] = Variable<String>(secondaryMuscles);
    map['instructions'] = Variable<String>(instructions);
    map['category'] = Variable<String>(category);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      force: Value(force),
      level: Value(level),
      mechanic: Value(mechanic),
      equipment: Value(equipment),
      primaryMuscles: Value(primaryMuscles),
      secondaryMuscles: Value(secondaryMuscles),
      instructions: Value(instructions),
      category: Value(category),
      isCustom: Value(isCustom),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      force: serializer.fromJson<String>(json['force']),
      level: serializer.fromJson<String>(json['level']),
      mechanic: serializer.fromJson<String>(json['mechanic']),
      equipment: serializer.fromJson<String>(json['equipment']),
      primaryMuscles: serializer.fromJson<String>(json['primaryMuscles']),
      secondaryMuscles: serializer.fromJson<String>(json['secondaryMuscles']),
      instructions: serializer.fromJson<String>(json['instructions']),
      category: serializer.fromJson<String>(json['category']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'force': serializer.toJson<String>(force),
      'level': serializer.toJson<String>(level),
      'mechanic': serializer.toJson<String>(mechanic),
      'equipment': serializer.toJson<String>(equipment),
      'primaryMuscles': serializer.toJson<String>(primaryMuscles),
      'secondaryMuscles': serializer.toJson<String>(secondaryMuscles),
      'instructions': serializer.toJson<String>(instructions),
      'category': serializer.toJson<String>(category),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Exercise copyWith(
          {String? id,
          String? name,
          String? force,
          String? level,
          String? mechanic,
          String? equipment,
          String? primaryMuscles,
          String? secondaryMuscles,
          String? instructions,
          String? category,
          bool? isCustom}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        force: force ?? this.force,
        level: level ?? this.level,
        mechanic: mechanic ?? this.mechanic,
        equipment: equipment ?? this.equipment,
        primaryMuscles: primaryMuscles ?? this.primaryMuscles,
        secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
        instructions: instructions ?? this.instructions,
        category: category ?? this.category,
        isCustom: isCustom ?? this.isCustom,
      );
  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('force: $force, ')
          ..write('level: $level, ')
          ..write('mechanic: $mechanic, ')
          ..write('equipment: $equipment, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('instructions: $instructions, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, force, level, mechanic, equipment,
      primaryMuscles, secondaryMuscles, instructions, category, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.force == this.force &&
          other.level == this.level &&
          other.mechanic == this.mechanic &&
          other.equipment == this.equipment &&
          other.primaryMuscles == this.primaryMuscles &&
          other.secondaryMuscles == this.secondaryMuscles &&
          other.instructions == this.instructions &&
          other.category == this.category &&
          other.isCustom == this.isCustom);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> force;
  final Value<String> level;
  final Value<String> mechanic;
  final Value<String> equipment;
  final Value<String> primaryMuscles;
  final Value<String> secondaryMuscles;
  final Value<String> instructions;
  final Value<String> category;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.force = const Value.absent(),
    this.level = const Value.absent(),
    this.mechanic = const Value.absent(),
    this.equipment = const Value.absent(),
    this.primaryMuscles = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.instructions = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    required String force,
    required String level,
    required String mechanic,
    required String equipment,
    required String primaryMuscles,
    required String secondaryMuscles,
    required String instructions,
    required String category,
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        force = Value(force),
        level = Value(level),
        mechanic = Value(mechanic),
        equipment = Value(equipment),
        primaryMuscles = Value(primaryMuscles),
        secondaryMuscles = Value(secondaryMuscles),
        instructions = Value(instructions),
        category = Value(category);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? force,
    Expression<String>? level,
    Expression<String>? mechanic,
    Expression<String>? equipment,
    Expression<String>? primaryMuscles,
    Expression<String>? secondaryMuscles,
    Expression<String>? instructions,
    Expression<String>? category,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (force != null) 'force': force,
      if (level != null) 'level': level,
      if (mechanic != null) 'mechanic': mechanic,
      if (equipment != null) 'equipment': equipment,
      if (primaryMuscles != null) 'primary_muscles': primaryMuscles,
      if (secondaryMuscles != null) 'secondary_muscles': secondaryMuscles,
      if (instructions != null) 'instructions': instructions,
      if (category != null) 'category': category,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? force,
      Value<String>? level,
      Value<String>? mechanic,
      Value<String>? equipment,
      Value<String>? primaryMuscles,
      Value<String>? secondaryMuscles,
      Value<String>? instructions,
      Value<String>? category,
      Value<bool>? isCustom,
      Value<int>? rowid}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      force: force ?? this.force,
      level: level ?? this.level,
      mechanic: mechanic ?? this.mechanic,
      equipment: equipment ?? this.equipment,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      instructions: instructions ?? this.instructions,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (force.present) {
      map['force'] = Variable<String>(force.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (mechanic.present) {
      map['mechanic'] = Variable<String>(mechanic.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (primaryMuscles.present) {
      map['primary_muscles'] = Variable<String>(primaryMuscles.value);
    }
    if (secondaryMuscles.present) {
      map['secondary_muscles'] = Variable<String>(secondaryMuscles.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('force: $force, ')
          ..write('level: $level, ')
          ..write('mechanic: $mechanic, ')
          ..write('equipment: $equipment, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('instructions: $instructions, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, description, metadata];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(Insertable<Workout> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    } else if (isInserting) {
      context.missing(_metadataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final String id;
  final String title;
  final String? description;
  final String metadata;
  const Workout(
      {required this.id,
      required this.title,
      this.description,
      required this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['metadata'] = Variable<String>(metadata);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      metadata: Value(metadata),
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      metadata: serializer.fromJson<String>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'metadata': serializer.toJson<String>(metadata),
    };
  }

  Workout copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? metadata}) =>
      Workout(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        metadata: metadata ?? this.metadata,
      );
  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.metadata == this.metadata);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> metadata;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String metadata,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        metadata = Value(metadata);
  static Insertable<Workout> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? metadata,
      Value<int>? rowid}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES Workouts(id)');
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES Exercises(id)');
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _setMeta = const VerificationMeta('set');
  @override
  late final GeneratedColumn<int> set = GeneratedColumn<int>(
      'set', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, workoutId, exerciseId, sessionId, set, reps, weight, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('set')) {
      context.handle(
          _setMeta, set.isAcceptableOrUnknown(data['set']!, _setMeta));
    } else if (isInserting) {
      context.missing(_setMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      set: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;
  final String workoutId;
  final String exerciseId;
  final String sessionId;
  final int set;
  final int reps;
  final double weight;
  final bool isCompleted;
  const WorkoutSet(
      {required this.id,
      required this.workoutId,
      required this.exerciseId,
      required this.sessionId,
      required this.set,
      required this.reps,
      required this.weight,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['session_id'] = Variable<String>(sessionId);
    map['set'] = Variable<int>(set);
    map['reps'] = Variable<int>(reps);
    map['weight'] = Variable<double>(weight);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      sessionId: Value(sessionId),
      set: Value(set),
      reps: Value(reps),
      weight: Value(weight),
      isCompleted: Value(isCompleted),
    );
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      set: serializer.fromJson<int>(json['set']),
      reps: serializer.fromJson<int>(json['reps']),
      weight: serializer.fromJson<double>(json['weight']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sessionId': serializer.toJson<String>(sessionId),
      'set': serializer.toJson<int>(set),
      'reps': serializer.toJson<int>(reps),
      'weight': serializer.toJson<double>(weight),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  WorkoutSet copyWith(
          {String? id,
          String? workoutId,
          String? exerciseId,
          String? sessionId,
          int? set,
          int? reps,
          double? weight,
          bool? isCompleted}) =>
      WorkoutSet(
        id: id ?? this.id,
        workoutId: workoutId ?? this.workoutId,
        exerciseId: exerciseId ?? this.exerciseId,
        sessionId: sessionId ?? this.sessionId,
        set: set ?? this.set,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sessionId: $sessionId, ')
          ..write('set: $set, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, workoutId, exerciseId, sessionId, set, reps, weight, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.sessionId == this.sessionId &&
          other.set == this.set &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.isCompleted == this.isCompleted);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> exerciseId;
  final Value<String> sessionId;
  final Value<int> set;
  final Value<int> reps;
  final Value<double> weight;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.set = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String workoutId,
    required String exerciseId,
    required String sessionId,
    required int set,
    required int reps,
    required double weight,
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workoutId = Value(workoutId),
        exerciseId = Value(exerciseId),
        sessionId = Value(sessionId),
        set = Value(set),
        reps = Value(reps),
        weight = Value(weight);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<String>? sessionId,
    Expression<int>? set,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sessionId != null) 'session_id': sessionId,
      if (set != null) 'set': set,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutId,
      Value<String>? exerciseId,
      Value<String>? sessionId,
      Value<int>? set,
      Value<int>? reps,
      Value<double>? weight,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      sessionId: sessionId ?? this.sessionId,
      set: set ?? this.set,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (set.present) {
      map['set'] = Variable<int>(set.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sessionId: $sessionId, ')
          ..write('set: $set, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeekdayWorkoutsTable extends WeekdayWorkouts
    with TableInfo<$WeekdayWorkoutsTable, WeekdayWorkout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeekdayWorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
      'day', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutIdsMeta =
      const VerificationMeta('workoutIds');
  @override
  late final GeneratedColumn<String> workoutIds = GeneratedColumn<String>(
      'workout_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exercisesMeta =
      const VerificationMeta('exercises');
  @override
  late final GeneratedColumn<String> exercises = GeneratedColumn<String>(
      'exercises', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _activeWorkoutMeta =
      const VerificationMeta('activeWorkout');
  @override
  late final GeneratedColumn<String> activeWorkout = GeneratedColumn<String>(
      'active_workout', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, day, workoutIds, exercises, activeWorkout];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekday_workouts';
  @override
  VerificationContext validateIntegrity(Insertable<WeekdayWorkout> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('workout_ids')) {
      context.handle(
          _workoutIdsMeta,
          workoutIds.isAcceptableOrUnknown(
              data['workout_ids']!, _workoutIdsMeta));
    } else if (isInserting) {
      context.missing(_workoutIdsMeta);
    }
    if (data.containsKey('exercises')) {
      context.handle(_exercisesMeta,
          exercises.isAcceptableOrUnknown(data['exercises']!, _exercisesMeta));
    }
    if (data.containsKey('active_workout')) {
      context.handle(
          _activeWorkoutMeta,
          activeWorkout.isAcceptableOrUnknown(
              data['active_workout']!, _activeWorkoutMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeekdayWorkout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeekdayWorkout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day'])!,
      workoutIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_ids'])!,
      exercises: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises'])!,
      activeWorkout: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_workout'])!,
    );
  }

  @override
  $WeekdayWorkoutsTable createAlias(String alias) {
    return $WeekdayWorkoutsTable(attachedDatabase, alias);
  }
}

class WeekdayWorkout extends DataClass implements Insertable<WeekdayWorkout> {
  final String id;
  final String day;
  final String workoutIds;
  final String exercises;
  final String activeWorkout;
  const WeekdayWorkout(
      {required this.id,
      required this.day,
      required this.workoutIds,
      required this.exercises,
      required this.activeWorkout});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day'] = Variable<String>(day);
    map['workout_ids'] = Variable<String>(workoutIds);
    map['exercises'] = Variable<String>(exercises);
    map['active_workout'] = Variable<String>(activeWorkout);
    return map;
  }

  WeekdayWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WeekdayWorkoutsCompanion(
      id: Value(id),
      day: Value(day),
      workoutIds: Value(workoutIds),
      exercises: Value(exercises),
      activeWorkout: Value(activeWorkout),
    );
  }

  factory WeekdayWorkout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeekdayWorkout(
      id: serializer.fromJson<String>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      workoutIds: serializer.fromJson<String>(json['workoutIds']),
      exercises: serializer.fromJson<String>(json['exercises']),
      activeWorkout: serializer.fromJson<String>(json['activeWorkout']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'day': serializer.toJson<String>(day),
      'workoutIds': serializer.toJson<String>(workoutIds),
      'exercises': serializer.toJson<String>(exercises),
      'activeWorkout': serializer.toJson<String>(activeWorkout),
    };
  }

  WeekdayWorkout copyWith(
          {String? id,
          String? day,
          String? workoutIds,
          String? exercises,
          String? activeWorkout}) =>
      WeekdayWorkout(
        id: id ?? this.id,
        day: day ?? this.day,
        workoutIds: workoutIds ?? this.workoutIds,
        exercises: exercises ?? this.exercises,
        activeWorkout: activeWorkout ?? this.activeWorkout,
      );
  @override
  String toString() {
    return (StringBuffer('WeekdayWorkout(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('workoutIds: $workoutIds, ')
          ..write('exercises: $exercises, ')
          ..write('activeWorkout: $activeWorkout')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, day, workoutIds, exercises, activeWorkout);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeekdayWorkout &&
          other.id == this.id &&
          other.day == this.day &&
          other.workoutIds == this.workoutIds &&
          other.exercises == this.exercises &&
          other.activeWorkout == this.activeWorkout);
}

class WeekdayWorkoutsCompanion extends UpdateCompanion<WeekdayWorkout> {
  final Value<String> id;
  final Value<String> day;
  final Value<String> workoutIds;
  final Value<String> exercises;
  final Value<String> activeWorkout;
  final Value<int> rowid;
  const WeekdayWorkoutsCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.workoutIds = const Value.absent(),
    this.exercises = const Value.absent(),
    this.activeWorkout = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeekdayWorkoutsCompanion.insert({
    required String id,
    required String day,
    required String workoutIds,
    this.exercises = const Value.absent(),
    this.activeWorkout = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        day = Value(day),
        workoutIds = Value(workoutIds);
  static Insertable<WeekdayWorkout> custom({
    Expression<String>? id,
    Expression<String>? day,
    Expression<String>? workoutIds,
    Expression<String>? exercises,
    Expression<String>? activeWorkout,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (workoutIds != null) 'workout_ids': workoutIds,
      if (exercises != null) 'exercises': exercises,
      if (activeWorkout != null) 'active_workout': activeWorkout,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeekdayWorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? day,
      Value<String>? workoutIds,
      Value<String>? exercises,
      Value<String>? activeWorkout,
      Value<int>? rowid}) {
    return WeekdayWorkoutsCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      workoutIds: workoutIds ?? this.workoutIds,
      exercises: exercises ?? this.exercises,
      activeWorkout: activeWorkout ?? this.activeWorkout,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (workoutIds.present) {
      map['workout_ids'] = Variable<String>(workoutIds.value);
    }
    if (exercises.present) {
      map['exercises'] = Variable<String>(exercises.value);
    }
    if (activeWorkout.present) {
      map['active_workout'] = Variable<String>(activeWorkout.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeekdayWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('workoutIds: $workoutIds, ')
          ..write('exercises: $exercises, ')
          ..write('activeWorkout: $activeWorkout, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $WeekdayWorkoutsTable weekdayWorkouts =
      $WeekdayWorkoutsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, exercises, workouts, workoutSets, weekdayWorkouts];
}
