import 'package:get/get.dart';
import 'checkin_logic.dart';

class CheckinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckinLogic>(() => CheckinLogic());
  }
}
