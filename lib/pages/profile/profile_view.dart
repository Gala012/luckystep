import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'profile_logic.dart';

class ProfileView extends GetView<ProfileLogic> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      children: [
        GetBuilder<ProfileLogic>(
          builder: (logic) {
            return Card(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(16)),
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Lang.profileOverview,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16)),
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            icon: Icons.directions_walk,
                            label: Lang.journeyTotalSteps,
                            value: '${logic.totalSteps}',
                            theme: theme,
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(12)),
                        Expanded(
                          child: _StatItem(
                            icon: Icons.check_circle,
                            label: '${Lang.journeyCheckinDays}${Lang.commonDays}',
                            value: '${logic.consecutiveCheckin}',
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(12)),
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            icon: Icons.water_drop,
                            label: '${Lang.journeyWaterDays}${Lang.commonDays}',
                            value: '${logic.waterAchievedDays}',
                            theme: theme,
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(12)),
                        Expanded(
                          child: _StatItem(
                            icon: Icons.timer,
                            label: Lang.profileTimerCount,
                            value: '${logic.timerCount}',
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(12)),
                    _StatItemWithRefresh(
                      icon: Icons.update,
                      label: Lang.profileStepLastUpdate,
                      value: logic.stepLastUpdate,
                      theme: theme,
                      refreshing: logic.refreshingSteps,
                      onRefresh: () => logic.refreshSteps(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        _buildItem(context, Icons.bar_chart, Lang.profileStats, () => Get.toNamed('/meter_stats')),
        _buildItem(context, Icons.settings, Lang.profileSettings, () => Get.toNamed('/meter_settings')),
        _buildItem(context, Icons.emoji_events, Lang.profileAchievements, () => Get.toNamed('/meter_achievements')),
        _buildItem(context, Icons.help_outline, Lang.profileHelp, () => Get.toNamed('/meter_help')),
        _buildItem(context, Icons.info_outline, Lang.profileAbout, () => Get.toNamed('/meter_about')),
      ],
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(12),
        horizontal: ScreenUtil().setWidth(12),
      ),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: ScreenUtil().setSp(20), color: AppTheme.primary),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: ScreenUtil().setSp(12),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatItemWithRefresh extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final bool refreshing;
  final VoidCallback onRefresh;

  const _StatItemWithRefresh({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.refreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(12),
        horizontal: ScreenUtil().setWidth(12),
      ),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: ScreenUtil().setSp(20), color: AppTheme.primary),
                SizedBox(height: ScreenUtil().setHeight(6)),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(20),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: ScreenUtil().setSp(12),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          IconButton(
            onPressed: refreshing ? null : onRefresh,
            icon: refreshing
                ? SizedBox(
                    width: ScreenUtil().setWidth(24),
                    height: ScreenUtil().setWidth(24),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primary,
                    ),
                  )
                : Icon(Icons.refresh, color: AppTheme.primary, size: ScreenUtil().setSp(22)),
            tooltip: Lang.profileRefreshSteps,
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
              minimumSize: Size(ScreenUtil().setWidth(40), ScreenUtil().setHeight(40)),
            ),
          ),
        ],
      ),
    );
  }
}
