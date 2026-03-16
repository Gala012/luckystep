import 'package:sqflite/sqflite.dart';
import 'data.dart';
import 'db_pedometer_entity.dart';

class DbPedometerHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<StepRecord?> getStepByDate(String date) async {
    final d = await db;
    final list = await d.query(
      tableStepRecord,
      where: 'date = ?',
      whereArgs: [date],
    );
    if (list.isEmpty) return null;
    return StepRecord.fromMap(list.first);
  }

  static Future<void> upsertStep(StepRecord r) async {
    final d = await db;
    await d.insert(
      tableStepRecord,
      r.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<StepRecord>> getStepsByDateRange(
      String start, String end) async {
    final d = await db;
    final list = await d.query(
      tableStepRecord,
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
      orderBy: 'date ASC',
    );
    return list.map((m) => StepRecord.fromMap(m)).toList();
  }

  static Future<int> insertTimer(TimerRecord r) async {
    final d = await db;
    return d.insert(tableTimerRecord, r.toMap());
  }

  static Future<List<TimerRecord>> getTimerRecords({int limit = 50}) async {
    final d = await db;
    final list = await d.query(
      tableTimerRecord,
      orderBy: 'id DESC',
      limit: limit,
    );
    return list.map((m) => TimerRecord.fromMap(m)).toList();
  }

  static Future<WaterRecord?> getWaterByDate(String date) async {
    final d = await db;
    final list = await d.query(
      tableWaterRecord,
      where: 'date = ?',
      whereArgs: [date],
    );
    if (list.isEmpty) return null;
    return WaterRecord.fromMap(list.first);
  }

  static Future<int> getWaterAmountByDate(String date) async {
    final r = await getWaterByDate(date);
    return r?.amountMl ?? 0;
  }

  static Future<void> addWater(String date, int amountMl, int goalMl) async {
    final d = await db;
    final existing = await getWaterByDate(date);
    final newAmount = (existing?.amountMl ?? 0) + amountMl;
    if (existing != null) {
      await d.update(
        tableWaterRecord,
        {'amount_ml': newAmount, 'goal_ml': goalMl},
        where: 'date = ?',
        whereArgs: [date],
      );
    } else {
      await d.insert(tableWaterRecord, {
        'date': date,
        'amount_ml': newAmount,
        'goal_ml': goalMl,
      });
    }
  }

  static Future<List<WaterRecord>> getWaterByDateRange(
      String start, String end) async {
    final d = await db;
    final list = await d.query(
      tableWaterRecord,
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
      orderBy: 'date ASC',
    );
    return list.map((m) => WaterRecord.fromMap(m)).toList();
  }

  static Future<CheckinRecord?> getCheckinByDate(String date) async {
    final d = await db;
    final list = await d.query(
      tableCheckinRecord,
      where: 'date = ?',
      whereArgs: [date],
    );
    if (list.isEmpty) return null;
    return CheckinRecord.fromMap(list.first);
  }

  static Future<void> upsertCheckin(CheckinRecord r) async {
    final d = await db;
    await d.insert(
      tableCheckinRecord,
      r.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CheckinRecord>> getCheckinByDateRange(
      String start, String end) async {
    final d = await db;
    final list = await d.query(
      tableCheckinRecord,
      where: 'date >= ? AND date <= ? AND checked = 1',
      whereArgs: [start, end],
      orderBy: 'date ASC',
    );
    return list.map((m) => CheckinRecord.fromMap(m)).toList();
  }

  static Future<int> getConsecutiveCheckinDays(String today) async {
    int count = 0;
    var dt = _parseDate(today);
    while (true) {
      final d = _formatDate(dt);
      final r = await getCheckinByDate(d);
      if (r == null || r.checked == 0) break;
      count++;
      dt = dt.subtract(const Duration(days: 1));
    }
    return count;
  }

  static DateTime _parseDate(String s) {
    final parts = s.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  static Future<List<AchievementRecord>> getAchievements() async {
    final d = await db;
    final list = await d.query(tableAchievementRecord, orderBy: 'unlocked_at DESC');
    return list.map((m) => AchievementRecord.fromMap(m)).toList();
  }

  static Future<bool> hasAchievement(String achievementId) async {
    final d = await db;
    final list = await d.query(
      tableAchievementRecord,
      where: 'achievement_id = ?',
      whereArgs: [achievementId],
    );
    return list.isNotEmpty;
  }

  static Future<void> unlockAchievement(String achievementId) async {
    final exists = await hasAchievement(achievementId);
    if (exists) return;
    final d = await db;
    final now = DateTime.now().toIso8601String();
    await d.insert(
      tableAchievementRecord,
      AchievementRecord(
        achievementId: achievementId,
        unlockedAt: now,
      ).toMap(),
    );
  }
}
