import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_pedometer/data.dart';
import 'lang/lang.dart';
import 'utils/app_theme.dart';
import '../pages/guide/guide_binding.dart';
import '../pages/guide/guide_view.dart';
import '../pages/main_frame/main_frame_binding.dart';
import '../pages/main_frame/main_frame_view.dart';
import '../pages/stats/stats_binding.dart';
import '../pages/stats/stats_view.dart';
import '../pages/settings/settings_binding.dart';
import '../pages/settings/settings_view.dart';
import '../pages/achievements/achievements_binding.dart';
import '../pages/achievements/achievements_view.dart';
import '../pages/help/help_binding.dart';
import '../pages/help/help_view.dart';
import '../pages/about/about_binding.dart';
import '../pages/about/about_view.dart';
import '../pages/timer/timer_binding.dart';
import '../pages/timer/timer_view.dart';
import '../pages/water/water_binding.dart';
import '../pages/water/water_view.dart';
import '../pages/checkin/checkin_binding.dart';
import '../pages/checkin/checkin_view.dart';
import 'utils/prefs_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDb();
  final prefs = await SharedPreferences.getInstance();
  final firstLaunch = prefs.getBool('first_launch') ?? true;
  runApp(MyApp(firstLaunch: firstLaunch));
}

class MyApp extends StatelessWidget {
  final bool firstLaunch;

  const MyApp({super.key, required this.firstLaunch});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: PrefsHelper.getDarkMode(),
      builder: (context, snapshot) {
        ThemeMode mode = ThemeMode.light;
        if (snapshot.hasData) {
          switch (snapshot.data!) {
            case 1:
              mode = ThemeMode.dark;
              break;
            case 2:
              mode = ThemeMode.system;
              break;
          }
        }
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, child) => child ?? const SizedBox.shrink(),
          child: GetMaterialApp(
            title: Lang.appName,
            theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          initialRoute: firstLaunch ? '/meter_guide' : '/meter_main_frame',
          getPages: LuckyStar,
          ),
        );
      },
    );
  }
}
List<GetPage<dynamic>> LuckyStar = [
  GetPage(
    name: '/meter_guide',
    page: () => const GuideView(),
    binding: GuideBinding(),
  ),
  GetPage(
    name: '/meter_main_frame',
    page: () => const MainFrameView(),
    binding: MainFrameBinding(),
  ),
  GetPage(
    name: '/meter_stats',
    page: () => const StatsView(),
    binding: StatsBinding(),
  ),
  GetPage(
    name: '/meter_settings',
    page: () => const SettingsView(),
    binding: SettingsBinding(),
  ),
  GetPage(
    name: '/meter_achievements',
    page: () => const AchievementsView(),
    binding: AchievementsBinding(),
  ),
  GetPage(
    name: '/meter_help',
    page: () => const HelpView(),
    binding: HelpBinding(),
  ),
  GetPage(
    name: '/meter_about',
    page: () => const AboutView(),
    binding: AboutBinding(),
  ),
  GetPage(
    name: '/meter_timer',
    page: () => const TimerView(),
    binding: TimerBinding(),
  ),
  GetPage(
    name: '/meter_water',
    page: () => const WaterView(),
    binding: WaterBinding(),
  ),
  GetPage(
    name: '/meter_checkin',
    page: () => const CheckinView(),
    binding: CheckinBinding(),
  ),
];