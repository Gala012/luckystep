import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import 'settings_logic.dart';

class SettingsView extends GetView<SettingsLogic> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.settingsTitle),
      ),
      body: GetBuilder<SettingsLogic>(
        builder: (logic) {
          return ListView(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            children: [
              ListTile(
                title: Text(Lang.settingsStepGoal),
                subtitle: Text('${logic.stepGoal}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => logic.showStepGoalSheet(),
              ),
              ListTile(
                title: Text(Lang.settingsWaterGoal),
                subtitle: Text('${logic.waterGoal} ml'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => logic.showWaterGoalSheet(),
              ),
              ListTile(
                title: Text(Lang.settingsTheme),
                subtitle: Text(logic.themeLabel),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => logic.showThemeSheet(),
              ),
            ],
          );
        },
      ),
    );
  }
}
