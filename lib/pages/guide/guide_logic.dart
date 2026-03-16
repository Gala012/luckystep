import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuideLogic extends GetxController {
  static const String _keyFirstLaunch = 'first_launch';

  Future<void> onTapStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
    Get.offAllNamed('/meter_main_frame');
  }
}
