import 'package:get/get.dart';
import '../../utils/step_service.dart';
import 'main_frame_logic.dart';
import '../home/home_binding.dart';
import '../steps/steps_binding.dart';
import '../journey/journey_binding.dart';
import '../profile/profile_binding.dart';

class MainFrameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StepService(), permanent: true);
    Get.lazyPut<MainFrameLogic>(() => MainFrameLogic());
    HomeBinding().dependencies();
    StepsBinding().dependencies();
    JourneyBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
