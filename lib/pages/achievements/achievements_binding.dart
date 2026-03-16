import 'package:get/get.dart';
import 'achievements_logic.dart';

class AchievementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AchievementsLogic>(() => AchievementsLogic());
  }
}
