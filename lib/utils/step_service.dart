import 'dart:async';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db_pedometer/db_pedometer_helper.dart';
import '../db_pedometer/db_pedometer_entity.dart';
import 'prefs_helper.dart';

class StepService extends GetxService {
  final todaySteps = 0.obs;
  StreamSubscription<StepCount>? _subscription;
  Timer? _refreshTimer;

  static String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> _requestPermission() async {
    if (GetPlatform.isAndroid) {
      final status = await Permission.activityRecognition.request();
      if (!status.isGranted) return;
    }
  }

  Future<void> _startListening() async {
    await _requestPermission();
    try {
      _subscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: (_) {},
      );
    } catch (_) {}
    _loadToday();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _loadToday();
    });
  }

  void _onStepCount(StepCount event) {
    final count = event.steps;
    _updateSteps(count);
  }

  Future<void> _loadToday() async {
    try {
      final today = _todayStr();
      final r = await DbPedometerHelper.getStepByDate(today);
      if (r != null) {
        todaySteps.value = r.steps;
        if (r.steps >= 10000) {
          await DbPedometerHelper.unlockAchievement('steps_10k');
        }
      }
    } catch (_) {}
  }

  Future<void> _updateSteps(int count) async {
    try {
      final today = _todayStr();
      final goal = await PrefsHelper.getStepGoal();
      await DbPedometerHelper.upsertStep(StepRecord(
        date: today,
        steps: count,
        goal: goal,
      ));
      todaySteps.value = count;
      await PrefsHelper.setStepLastUpdate(DateTime.now().toIso8601String());
      if (count >= 10000) {
        await DbPedometerHelper.unlockAchievement('steps_10k');
      }
    } catch (_) {}
  }

  Future<void> refresh() async {
    await _loadToday();
  }
}
