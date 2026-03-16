import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import '../main_frame/main_frame_logic.dart';
import '../../../utils/step_service.dart';
import 'home_logic.dart';

class HomeView extends GetView<HomeLogic> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepsCard(context, theme),
          SizedBox(height: ScreenUtil().setHeight(16)),
          _buildWaterCard(context, theme),
          SizedBox(height: ScreenUtil().setHeight(16)),
          _buildCheckinCard(context, theme),
          SizedBox(height: ScreenUtil().setHeight(24)),
          _buildQuickActions(context, theme),
        ],
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context, ThemeData theme) {
    final logic = Get.find<HomeLogic>();
    return Obx(() {
      final steps = Get.isRegistered<StepService>() ? Get.find<StepService>().todaySteps.value : 0;
      return _GlassCard(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Lang.homeSteps,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/meter_stats'),
                    child: Text(
                      Lang.homeStats,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$steps',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primary,
                      fontSize: ScreenUtil().setSp(40),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ' / ${logic.stepGoal} ${Lang.homeStepsGoal}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              ClipRRect(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
                child: LinearProgressIndicator(
                  value: logic.stepGoal > 0
                      ? (steps / logic.stepGoal).clamp(0.0, 1.0)
                      : 0,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  minHeight: ScreenUtil().setHeight(8),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWaterCard(BuildContext context, ThemeData theme) {
    return GetBuilder<HomeLogic>(
      id: 'water',
      builder: (logic) {
        return _GlassCard(
          onTap: () async {
            await Get.toNamed('/meter_water');
            Get.find<HomeLogic>().load();
          },
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.homeWaterToday,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenUtil().setHeight(12)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${logic.todayWaterMl}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppTheme.water,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ' / ${logic.waterGoal} ml',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(12)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
                  child: LinearProgressIndicator(
                    value: logic.waterGoal > 0
                        ? (logic.todayWaterMl / logic.waterGoal).clamp(0.0, 1.0)
                        : 0,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.water),
                    minHeight: ScreenUtil().setHeight(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckinCard(BuildContext context, ThemeData theme) {
    return GetBuilder<HomeLogic>(
      id: 'checkin',
      builder: (logic) {
        return _GlassCard(
          onTap: () async {
            await Get.toNamed('/meter_checkin');
            Get.find<HomeLogic>().load();
          },
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Row(
              children: [
                Container(
                  width: ScreenUtil().setWidth(48),
                  height: ScreenUtil().setWidth(48),
                  decoration: BoxDecoration(
                    color: logic.checkedToday
                        ? AppTheme.cta.withValues(alpha: 0.15)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                  ),
                  child: Icon(
                    logic.checkedToday ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: ScreenUtil().setSp(28),
                    color: logic.checkedToday ? AppTheme.cta : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Lang.homeCheckinToday,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(4)),
                      Text(
                        logic.checkedToday
                            ? '${Lang.checkinConsecutive} ${logic.consecutiveCheckin} ${Lang.commonDays}'
                            : Lang.checkinDo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.homeQuickEntry,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.timer,
                label: Lang.homeTimer,
                onTap: () => Get.toNamed('/meter_timer'),
                theme: theme,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(12)),
            Expanded(
              child: _ActionCard(
                icon: Icons.water_drop,
                label: Lang.homeWater,
                onTap: () => Get.toNamed('/meter_water'),
                theme: theme,
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.check_circle,
                label: Lang.homeCheckin,
                onTap: () => Get.toNamed('/meter_checkin'),
                theme: theme,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(12)),
            Expanded(
              child: _ActionCard(
                icon: Icons.route,
                label: Lang.homeJourney,
                onTap: () => Get.find<MainFrameLogic>().setIndex(2),
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _GlassCard({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppTheme.transitionDuration,
      child: Material(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
        elevation: theme.cardTheme.elevation ?? 2,
        shadowColor: theme.cardTheme.shadowColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
          child: child,
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(20),
            horizontal: ScreenUtil().setWidth(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: ScreenUtil().setWidth(32), color: AppTheme.primary),
              SizedBox(height: ScreenUtil().setHeight(8)),
              Text(
                label,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
