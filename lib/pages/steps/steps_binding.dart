import 'package:get/get.dart';
import 'steps_logic.dart';

class StepsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StepsLogic>(() => StepsLogic());
  }
}
