import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';

class StatsLogic extends GetxController {
  List<FlSpot> stepSpots = [];
  List<FlSpot> waterSpots = [];
  List<String> dateLabels = [];
  int totalSteps = 0;
  int totalWater = 0;
  int stepDays = 0;
  int waterDays = 0;

  @override
  void onReady() {
    super.onReady();
    _load();
  }

  Future<void> _load() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    final startStr = _formatDate(start);
    final endStr = _formatDate(now);

    final steps = await DbPedometerHelper.getStepsByDateRange(startStr, endStr);
    final stepMap = {for (final r in steps) r.date: r.steps};

    final waters = await DbPedometerHelper.getWaterByDateRange(startStr, endStr);
    final waterMap = {for (final r in waters) r.date: r.amountMl};

    stepSpots = [];
    waterSpots = [];
    dateLabels = [];
    for (var i = 0; i < 7; i++) {
      final d = start.add(Duration(days: i));
      final dateStr = _formatDate(d);
      dateLabels.add('${d.month}/${d.day}');
      stepSpots.add(FlSpot(i.toDouble(), (stepMap[dateStr] ?? 0).toDouble()));
      waterSpots.add(FlSpot(i.toDouble(), (waterMap[dateStr] ?? 0).toDouble()));
    }

    totalSteps = steps.fold(0, (a, r) => a + r.steps);
    totalWater = waters.fold(0, (a, r) => a + r.amountMl);
    stepDays = steps.where((r) => r.steps > 0).length;
    waterDays = waters.where((r) => r.amountMl > 0).length;

    update();
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
