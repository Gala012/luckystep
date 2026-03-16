import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';

class JourneyLogic extends GetxController {
  int totalSteps = 0;
  int consecutiveCheckin = 0;
  int waterAchievedDays = 0;

  @override
  void onReady() {
    super.onReady();
    _load();
  }

  Future<void> _load() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 2, 1);
    final startStr = '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
    final endStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final steps = await DbPedometerHelper.getStepsByDateRange(startStr, endStr);
    totalSteps = steps.fold(0, (a, r) => a + r.steps);

    final todayStr = endStr;
    consecutiveCheckin = await DbPedometerHelper.getConsecutiveCheckinDays(todayStr);

    final waters = await DbPedometerHelper.getWaterByDateRange(startStr, endStr);
    waterAchievedDays = waters.where((w) => w.amountMl >= w.goalMl).length;

    update();
  }
}
