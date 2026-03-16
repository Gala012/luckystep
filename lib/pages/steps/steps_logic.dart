import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../db_pedometer/db_pedometer_entity.dart';
import '../../utils/prefs_helper.dart';
import '../../utils/step_service.dart';
import '../../lang/lang.dart';

class StepsLogic extends GetxController {
  int stepGoal = 10000;
  List<StepRecord> recentSteps = [];

  int get todaySteps => Get.isRegistered<StepService>() ? Get.find<StepService>().todaySteps.value : 0;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    stepGoal = await PrefsHelper.getStepGoal();
    if (Get.isRegistered<StepService>()) {
      await Get.find<StepService>().refresh();
    }
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day - 6);
    final startStr = '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
    final endStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    recentSteps = await DbPedometerHelper.getStepsByDateRange(startStr, endStr);
    update();
  }

  void showSetGoal() {
    final ctrl = TextEditingController(text: stepGoal.toString());
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Lang.stepsSetGoal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: Lang.stepsGoal,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text(Lang.commonCancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final v = int.tryParse(ctrl.text);
                      if (v != null && v > 0) {
                        await PrefsHelper.setStepGoal(v);
                        stepGoal = v;
                        update();
                        Get.back();
                      }
                    },
                    child: Text(Lang.commonSave),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

}
