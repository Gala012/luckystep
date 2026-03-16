import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';
import '../../utils/prefs_helper.dart';

class SettingsLogic extends GetxController {
  int stepGoal = 10000;
  int waterGoal = 2000;
  int themeMode = 0;

  String get themeLabel {
    switch (themeMode) {
      case 1:
        return Lang.settingsThemeDark;
      case 2:
        return Lang.settingsThemeSystem;
      default:
        return Lang.settingsThemeLight;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _load();
  }

  Future<void> _load() async {
    stepGoal = await PrefsHelper.getStepGoal();
    waterGoal = await PrefsHelper.getWaterGoal();
    themeMode = await PrefsHelper.getDarkMode();
    update();
  }

  void showStepGoalSheet() {
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
            Text(Lang.settingsStepGoal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                Expanded(child: OutlinedButton(onPressed: () => Get.back(), child: Text(Lang.commonCancel))),
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

  void showWaterGoalSheet() {
    final ctrl = TextEditingController(text: waterGoal.toString());
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
            Text(Lang.settingsWaterGoal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: Lang.waterGoal,
                suffixText: Lang.waterMl,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Get.back(), child: Text(Lang.commonCancel))),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final v = int.tryParse(ctrl.text);
                      if (v != null && v > 0) {
                        await PrefsHelper.setWaterGoal(v);
                        waterGoal = v;
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

  void showThemeSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(Lang.settingsThemeLight),
              onTap: () async {
                await PrefsHelper.setDarkMode(0);
                themeMode = 0;
                Get.changeThemeMode(ThemeMode.light);
                update();
                Get.back();
              },
            ),
            ListTile(
              title: Text(Lang.settingsThemeDark),
              onTap: () async {
                await PrefsHelper.setDarkMode(1);
                themeMode = 1;
                Get.changeThemeMode(ThemeMode.dark);
                update();
                Get.back();
              },
            ),
            ListTile(
              title: Text(Lang.settingsThemeSystem),
              onTap: () async {
                await PrefsHelper.setDarkMode(2);
                themeMode = 2;
                Get.changeThemeMode(ThemeMode.system);
                update();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
