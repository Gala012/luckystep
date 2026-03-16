import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../utils/prefs_helper.dart';
import '../../utils/step_service.dart';

class HomeLogic extends GetxController {
  int stepGoal = 10000;
  int waterGoal = 2000;
  int todayWaterMl = 0;
  bool checkedToday = false;
  int consecutiveCheckin = 0;

  int get todaySteps => Get.isRegistered<StepService>() ? Get.find<StepService>().todaySteps.value : 0;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    stepGoal = await PrefsHelper.getStepGoal();
    waterGoal = await PrefsHelper.getWaterGoal();
    if (Get.isRegistered<StepService>()) {
      await Get.find<StepService>().refresh();
    }
    final today = _todayStr();
    todayWaterMl = await DbPedometerHelper.getWaterAmountByDate(today);
    final checkin = await DbPedometerHelper.getCheckinByDate(today);
    checkedToday = checkin != null && checkin.checked == 1;
    consecutiveCheckin = await DbPedometerHelper.getConsecutiveCheckinDays(today);
    update(['water', 'checkin']);
  }

  String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
