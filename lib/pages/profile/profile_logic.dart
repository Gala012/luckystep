import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../lang/lang.dart';
import '../../utils/prefs_helper.dart';
import '../../utils/step_service.dart';

class ProfileLogic extends GetxController {
  int totalSteps = 0;
  int consecutiveCheckin = 0;
  int waterAchievedDays = 0;
  int timerCount = 0;
  String stepLastUpdate = '';
  bool refreshingSteps = false;

  int get todaySteps => Get.isRegistered<StepService>() ? Get.find<StepService>().todaySteps.value : 0;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 2, 1);
    final startStr = '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
    final endStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final steps = await DbPedometerHelper.getStepsByDateRange(startStr, endStr);
    totalSteps = steps.fold(0, (a, r) => a + r.steps);

    consecutiveCheckin = await DbPedometerHelper.getConsecutiveCheckinDays(endStr);

    final waters = await DbPedometerHelper.getWaterByDateRange(startStr, endStr);
    waterAchievedDays = waters.where((w) => w.amountMl >= w.goalMl).length;

    final timers = await DbPedometerHelper.getTimerRecords(limit: 999);
    timerCount = timers.length;

    final lastUpdate = await PrefsHelper.getStepLastUpdate();
    stepLastUpdate = _formatLastUpdate(lastUpdate);

    update();
  }

  String _formatLastUpdate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return '${Lang.commonToday} $timeStr';
      }
      return '${dt.month}/${dt.day} $timeStr';
    } catch (_) {
      return '-';
    }
  }

  Future<void> refreshSteps() async {
    if (refreshingSteps) return;
    refreshingSteps = true;
    update();
    try {
      if (Get.isRegistered<StepService>()) {
        await Get.find<StepService>().refresh();
      }
      await load();
    } finally {
      refreshingSteps = false;
      update();
    }
  }
}
