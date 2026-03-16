import 'package:get/get.dart';
import 'timer_logic.dart';

class TimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimerLogic>(() => TimerLogic());
  }
}
