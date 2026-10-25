import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/registration_model.dart';

class RegistrationLocalDataSource {
  RegistrationLocalDataSource._();
  static final RegistrationLocalDataSource instance =
      RegistrationLocalDataSource._();

  Database? _database;
  static const _dbName = 'registrations.db';
  static const _tableName = 'registrations';
  static const _dbVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final Directory appSupportDir = await getApplicationSupportDirectory();
    await appSupportDir.create(recursive: true);
    final String path = join(appSupportDir.path, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        governorate TEXT NOT NULL,
        district TEXT NOT NULL,
        village_street TEXT NOT NULL,
        business_type TEXT NOT NULL,
        farm_area TEXT NOT NULL DEFAULT '',
        farm_area_unit TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_registrations_full_name ON $_tableName(full_name)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_registrations_phone ON $_tableName(phone)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_registrations_governorate ON $_tableName(governorate)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_registrations_district ON $_tableName(district)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_registrations_village_street ON $_tableName(village_street)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_registrations_business_type ON $_tableName(business_type)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE $_tableName ADD COLUMN farm_area TEXT NOT NULL DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE $_tableName ADD COLUMN farm_area_unit TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<int> insertRegistration(RegistrationModel registration) async {
    final db = await database;
    return db.insert(
      _tableName,
      registration.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<RegistrationModel>> getAllRegistrations() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'id DESC');
    return maps.map((map) => RegistrationModel.fromMap(map)).toList();
  }

  Future<int> countRegistrations() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM $_tableName',
    );
    final value = result.first['count'];
    return value is int ? value : int.tryParse('$value') ?? 0;
  }

  Future<List<RegistrationModel>> searchRegistrations(String query) async {
    final db = await database;
    final q = query.trim();
    if (q.isEmpty) {
      return getAllRegistrations();
    }
    final like = '%$q%';
    final maps = await db.query(
      _tableName,
      where: '''
        full_name LIKE ? OR
        phone LIKE ? OR
        governorate LIKE ? OR
        district LIKE ? OR
        village_street LIKE ? OR
        business_type LIKE ?
      ''',
      whereArgs: [like, like, like, like, like, like],
      orderBy: 'id DESC',
    );
    return maps.map((map) => RegistrationModel.fromMap(map)).toList();
  }

  Future<RegistrationModel?> getRegistrationById(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return RegistrationModel.fromMap(maps.first);
  }

  Future<int> updateRegistration(RegistrationModel registration) async {
    final db = await database;
    if (registration.id == null) return 0;
    return db.update(
      _tableName,
      registration.toMap(),
      where: 'id = ?',
      whereArgs: [registration.id],
    );
  }

  Future<int> deleteRegistration(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
