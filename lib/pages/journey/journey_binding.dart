import 'package:get/get.dart';
import 'journey_logic.dart';

class JourneyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JourneyLogic>(() => JourneyLogic());
  }
}
