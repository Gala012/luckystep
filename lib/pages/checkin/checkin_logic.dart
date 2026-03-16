import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../db_pedometer/db_pedometer_entity.dart';
import '../../lang/lang.dart';

class CheckinLogic extends GetxController {
  bool checkedToday = false;
  int consecutiveDays = 0;
  int thisMonthDays = 0;
  int thisMonthTotal = 0;
  List<String> recentCheckinDates = [];
  List<CalendarDay> calendarDays = [];
  String motivationText = '';

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final today = _formatDate(DateTime.now());
    final now = DateTime.now();

    final r = await DbPedometerHelper.getCheckinByDate(today);
    checkedToday = r != null && r.checked == 1;
    consecutiveDays = await DbPedometerHelper.getConsecutiveCheckinDays(today);
    if (consecutiveDays >= 7) {
      await DbPedometerHelper.unlockAchievement('checkin_7');
    }

    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    thisMonthTotal = monthEnd.day;
    final monthRecords = await DbPedometerHelper.getCheckinByDateRange(
      _formatDate(monthStart),
      _formatDate(monthEnd),
    );
    thisMonthDays = monthRecords.length;

    final weekAgo = now.subtract(const Duration(days: 6));
    recentCheckinDates = (await DbPedometerHelper.getCheckinByDateRange(
      _formatDate(weekAgo),
      today,
    ))
        .map((e) => e.date)
        .toList();

    final checkinSet = monthRecords.map((e) => e.date).toSet();
    calendarDays = _buildCalendar(now, checkinSet);
    _buildMotivation();
    update();
  }

  List<CalendarDay> _buildCalendar(DateTime now, Set<String> checkinSet) {
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final padStart = monthStart.weekday - 1;

    final days = <CalendarDay>[];
    for (var i = 0; i < padStart; i++) {
      days.add(CalendarDay(day: 0, dateStr: '', checked: false));
    }
    for (var d = 1; d <= monthEnd.day; d++) {
      final dateStr = _formatDate(DateTime(now.year, now.month, d));
      days.add(CalendarDay(
        day: d,
        dateStr: dateStr,
        checked: checkinSet.contains(dateStr),
      ));
    }
    return days;
  }

  void _buildMotivation() {
    if (consecutiveDays >= 30) {
      motivationText = Lang.checkinMotivation30.replaceAll('%d', '$consecutiveDays');
    } else if (consecutiveDays >= 14) {
      motivationText = Lang.checkinMotivation14.replaceAll('%d', '$consecutiveDays');
    } else if (consecutiveDays >= 7) {
      motivationText = Lang.checkinMotivation7.replaceAll('%d', '$consecutiveDays');
    } else if (consecutiveDays >= 3) {
      motivationText = Lang.checkinMotivation3.replaceAll('%d', '$consecutiveDays');
    } else if (consecutiveDays >= 1) {
      motivationText = Lang.checkinMotivation1;
    } else if (checkedToday) {
      motivationText = Lang.checkinMotivationToday;
    } else {
      motivationText = Lang.checkinMotivationEmpty;
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> doCheckin() async {
    if (checkedToday) return;
    final today = _formatDate(DateTime.now());
    await DbPedometerHelper.upsertCheckin(CheckinRecord(date: today, checked: 1));
    await load();
    if (consecutiveDays >= 7) {
      await DbPedometerHelper.unlockAchievement('checkin_7');
    }
  }
}

class CalendarDay {
  final int day;
  final String dateStr;
  final bool checked;

  CalendarDay({
    required this.day,
    required this.dateStr,
    required this.checked,
  });
}
