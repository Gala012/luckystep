import 'package:get/get.dart';

import 'computed_logic.dart';

class ComputedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ComputedLogic(),
      permanent: true,
    );
  }
}
