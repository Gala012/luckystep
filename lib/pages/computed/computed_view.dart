import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'computed_logic.dart';

class ComputedView extends GetView<ComputedLogic> {
  const ComputedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.pilwcj.value
              ? const CircularProgressIndicator(color: Colors.deepPurpleAccent)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.xkhcjp();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
