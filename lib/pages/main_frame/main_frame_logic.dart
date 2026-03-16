import 'package:get/get.dart';

class MainFrameLogic extends GetxController {
  final currentIndex = 0.obs;

  void setIndex(int i) {
    currentIndex.value = i;
  }
}
