import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static const String _keyStepGoal = 'step_goal';
  static const String _keyWaterGoal = 'water_goal';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyStepLastUpdate = 'step_last_update';

  static Future<int> getStepGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStepGoal) ?? 10000;
  }

  static Future<void> setStepGoal(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyStepGoal, v);
  }

  static Future<int> getWaterGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyWaterGoal) ?? 2000;
  }

  static Future<void> setWaterGoal(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyWaterGoal, v);
  }

  static Future<int> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDarkMode) ?? 0;
  }

  static Future<void> setDarkMode(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDarkMode, v);
  }

  static Future<String?> getStepLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStepLastUpdate);
  }

  static Future<void> setStepLastUpdate(String iso) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStepLastUpdate, iso);
  }
}
