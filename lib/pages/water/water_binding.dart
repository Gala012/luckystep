import 'package:get/get.dart';
import 'water_logic.dart';

class WaterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaterLogic>(() => WaterLogic());
  }
}
