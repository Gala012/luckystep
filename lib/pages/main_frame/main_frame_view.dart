import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'main_frame_logic.dart';
import '../home/home_view.dart';
import '../steps/steps_view.dart';
import '../journey/journey_view.dart';
import '../profile/profile_view.dart';

class MainFrameView extends GetView<MainFrameLogic> {
  const MainFrameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final titles = [Lang.navHome, Lang.navSteps, Lang.journeyTitle, Lang.navProfile];
      final theme = Theme.of(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(titles[controller.currentIndex.value]),
          elevation: 0,
        ),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            StepsView(),
            JourneyView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.setIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primary,
              unselectedItemColor: theme.brightness == Brightness.light
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF6B7280),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: Lang.navHome,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.directions_walk_outlined),
                  activeIcon: const Icon(Icons.directions_walk),
                  label: Lang.navSteps,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.route_outlined),
                  activeIcon: const Icon(Icons.route),
                  label: Lang.navJourney,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person),
                  label: Lang.navProfile,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
