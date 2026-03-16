import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableStepRecord = 'step_record';
const String tableTimerRecord = 'timer_record';
const String tableWaterRecord = 'water_record';
const String tableCheckinRecord = 'checkin_record';
const String tableAchievementRecord = 'achievement_record';

Future<Database> initDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'pedometer.db');
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableStepRecord (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          steps INTEGER NOT NULL DEFAULT 0,
          goal INTEGER NOT NULL DEFAULT 10000
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableTimerRecord (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          start_time TEXT NOT NULL,
          end_time TEXT NOT NULL,
          duration_sec INTEGER NOT NULL,
          type TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableWaterRecord (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          amount_ml INTEGER NOT NULL DEFAULT 0,
          goal_ml INTEGER NOT NULL DEFAULT 2000
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableCheckinRecord (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          checked INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE $tableAchievementRecord (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          achievement_id TEXT NOT NULL,
          unlocked_at TEXT NOT NULL
        )
      ''');
    },
  );
}
