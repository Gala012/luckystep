class StepRecord {
  final int? id;
  final String date;
  final int steps;
  final int goal;

  StepRecord({this.id, required this.date, required this.steps, required this.goal});

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'steps': steps,
        'goal': goal,
      };

  factory StepRecord.fromMap(Map<String, dynamic> m) => StepRecord(
        id: m['id'] as int?,
        date: m['date'] as String,
        steps: m['steps'] as int,
        goal: m['goal'] as int,
      );
}

class TimerRecord {
  final int? id;
  final String startTime;
  final String endTime;
  final int durationSec;
  final String type;

  TimerRecord({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.durationSec,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'start_time': startTime,
        'end_time': endTime,
        'duration_sec': durationSec,
        'type': type,
      };

  factory TimerRecord.fromMap(Map<String, dynamic> m) => TimerRecord(
        id: m['id'] as int?,
        startTime: m['start_time'] as String,
        endTime: m['end_time'] as String,
        durationSec: m['duration_sec'] as int,
        type: m['type'] as String,
      );
}

class WaterRecord {
  final int? id;
  final String date;
  final int amountMl;
  final int goalMl;

  WaterRecord({
    this.id,
    required this.date,
    required this.amountMl,
    required this.goalMl,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'amount_ml': amountMl,
        'goal_ml': goalMl,
      };

  factory WaterRecord.fromMap(Map<String, dynamic> m) => WaterRecord(
        id: m['id'] as int?,
        date: m['date'] as String,
        amountMl: m['amount_ml'] as int,
        goalMl: m['goal_ml'] as int,
      );
}

class CheckinRecord {
  final int? id;
  final String date;
  final int checked;

  CheckinRecord({this.id, required this.date, required this.checked});

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'checked': checked,
      };

  factory CheckinRecord.fromMap(Map<String, dynamic> m) => CheckinRecord(
        id: m['id'] as int?,
        date: m['date'] as String,
        checked: m['checked'] as int,
      );
}

class AchievementRecord {
  final int? id;
  final String achievementId;
  final String unlockedAt;

  AchievementRecord({
    this.id,
    required this.achievementId,
    required this.unlockedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'achievement_id': achievementId,
        'unlocked_at': unlockedAt,
      };

  factory AchievementRecord.fromMap(Map<String, dynamic> m) => AchievementRecord(
        id: m['id'] as int?,
        achievementId: m['achievement_id'] as String,
        unlockedAt: m['unlocked_at'] as String,
      );
}
