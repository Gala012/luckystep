import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/step_service.dart';
import 'steps_logic.dart';

class StepsView extends GetView<StepsLogic> {
  const StepsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StepsLogic>();
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      child: Obx(() {
        final steps = Get.isRegistered<StepService>() ? Get.find<StepService>().todaySteps.value : 0;
        return GetBuilder<StepsLogic>(
          builder: (_) {
            final distanceKm = (steps * 0.0007).toStringAsFixed(2);
            final kcal = (steps * 0.04).round();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainCard(context, logic, steps, theme),
                SizedBox(height: ScreenUtil().setHeight(16)),
                _buildConvertCard(context, distanceKm, kcal, theme),
                if (steps >= logic.stepGoal && logic.stepGoal > 0) ...[
                  SizedBox(height: ScreenUtil().setHeight(12)),
                  _buildGoalReachedBanner(theme),
                ],
                SizedBox(height: ScreenUtil().setHeight(24)),
                _buildRecentSection(logic, theme),
                SizedBox(height: ScreenUtil().setHeight(16)),
                _buildStatsEntry(theme),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildMainCard(BuildContext context, StepsLogic logic, int steps, ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Lang.stepsToday,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                TextButton(
                  onPressed: () => logic.showSetGoal(),
                  child: Text(
                    Lang.stepsSetGoal,
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(8)),
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
              '${Lang.stepsGoal}: ${logic.stepGoal}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
  }

  Widget _buildConvertCard(BuildContext context, String distanceKm, int kcal, ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.straighten, size: ScreenUtil().setSp(24), color: AppTheme.primary),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Lang.stepsDistance} $distanceKm ${Lang.stepsKm}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        Lang.stepsDistanceLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: ScreenUtil().setSp(12),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: ScreenUtil().setHeight(36),
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department, size: ScreenUtil().setSp(24), color: AppTheme.calorie),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Lang.stepsCal} $kcal ${Lang.stepsKcal}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        Lang.stepsCalLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: ScreenUtil().setSp(12),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalReachedBanner(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(12),
        horizontal: ScreenUtil().setWidth(16),
      ),
      decoration: BoxDecoration(
        color: AppTheme.cta.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
        border: Border.all(color: AppTheme.cta, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.celebration, color: AppTheme.cta, size: ScreenUtil().setSp(24)),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Text(
            Lang.stepsGoalReached,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppTheme.cta,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(StepsLogic logic, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.stepsRecent,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        logic.recentSteps.isEmpty
            ? Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
                ),
                child: Center(
                  child: Text(
                    Lang.stepsNoRecord,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : Card(
                child: Column(
                  children: logic.recentSteps.reversed.map((r) {
                    final parts = r.date.split('-');
                    final dateStr = parts.length >= 3 ? '${parts[1]}/${parts[2]}' : r.date;
                    return ListTile(
                      leading: Icon(Icons.directions_walk, color: AppTheme.primary, size: ScreenUtil().setSp(22)),
                      title: Text(
                        dateStr,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '${r.steps}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
      ],
    );
  }

  Widget _buildStatsEntry(ThemeData theme) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.bar_chart, color: AppTheme.primary),
        title: Text(
          Lang.stepsViewStats,
          style: TextStyle(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Get.toNamed('/meter_stats');
          await Get.find<StepsLogic>().load();
        },
      ),
    );
  }
}
