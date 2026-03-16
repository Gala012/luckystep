import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../lang/lang.dart';

class AchievementItem {
  final String id;
  final String name;
  final IconData icon;

  AchievementItem({required this.id, required this.name, required this.icon});
}

class AchievementsLogic extends GetxController {
  List<AchievementItem> items = [];
  static final List<AchievementItem> allAchievements = [
    AchievementItem(id: 'steps_10k', name: Lang.achievementSteps10kName, icon: Icons.directions_walk),
    AchievementItem(id: 'checkin_7', name: Lang.achievementCheckin7Name, icon: Icons.check_circle),
    AchievementItem(id: 'water_2l', name: Lang.achievementWater2lName, icon: Icons.water_drop),
  ];

  @override
  void onReady() {
    super.onReady();
    _load();
  }

  Future<void> _load() async {
    final unlocked = await DbPedometerHelper.getAchievements();
    final ids = unlocked.map((r) => r.achievementId).toSet();
    items = allAchievements.where((a) => ids.contains(a.id)).toList();
    update();
  }
}
