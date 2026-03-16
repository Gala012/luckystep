import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../utils/prefs_helper.dart';

class WaterLogic extends GetxController {
  int todayAmount = 0;
  int waterGoal = 2000;

  @override
  void onReady() {
    super.onReady();
    _load();
  }

  Future<void> _load() async {
    waterGoal = await PrefsHelper.getWaterGoal();
    final today = _todayStr();
    todayAmount = await DbPedometerHelper.getWaterAmountByDate(today);
    if (todayAmount >= 2000) {
      await DbPedometerHelper.unlockAchievement('water_2l');
    }
    update();
  }

  String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> addWater(int ml) async {
    final today = _todayStr();
    await DbPedometerHelper.addWater(today, ml, waterGoal);
    todayAmount += ml;
    if (todayAmount >= 2000) {
      await DbPedometerHelper.unlockAchievement('water_2l');
    }
    update();
  }
}
