import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_pedometer/db_pedometer_helper.dart';
import '../../db_pedometer/db_pedometer_entity.dart';
import '../../lang/lang.dart';

class TimerLogic extends GetxController {
  int elapsedSec = 0;
  int targetSec = 0;
  bool isCountDown = false;
  bool isRunning = false;
  Timer? _timer;

  String get displayTime {
    int sec = isCountDown ? (targetSec - elapsedSec).clamp(0, targetSec) : elapsedSec;
    final h = sec ~/ 3600;
    final m = (sec % 3600) ~/ 60;
    final s = sec % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void start() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSec++;
      if (isCountDown && elapsedSec >= targetSec) {
        pause();
      }
      update();
    });
    update();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
    update();
  }

  void reset() {
    pause();
    elapsedSec = 0;
    update();
  }

  void setCountUp() {
    if (isRunning) return;
    isCountDown = false;
    elapsedSec = 0;
    targetSec = 0;
    update();
  }

  void setCountDown() {
    if (isRunning) return;
    isCountDown = true;
    update();
  }

  void setTargetMinutes(int minutes) {
    if (isRunning) return;
    targetSec = minutes * 60;
    elapsedSec = 0;
    update();
  }

  void showSetMinutes() {
    final minCtrl = TextEditingController(text: (targetSec ~/ 60).toString());
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              Lang.timerCustom,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Lang.timerCustomHint,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: minCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: Lang.timerSetMinutes,
                hintText: Lang.timerCustomPlaceholder,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(Lang.commonCancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final m = int.tryParse(minCtrl.text);
                      if (m != null && m >= 0) {
                        targetSec = m * 60;
                        elapsedSec = 0;
                        update();
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(Lang.commonConfirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> saveRecord() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(seconds: elapsedSec));
    await DbPedometerHelper.insertTimer(TimerRecord(
      startTime: start.toIso8601String(),
      endTime: now.toIso8601String(),
      durationSec: elapsedSec,
      type: isCountDown ? 'count_down' : 'count_up',
    ));
  }
}
