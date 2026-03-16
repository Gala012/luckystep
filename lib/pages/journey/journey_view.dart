import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'journey_logic.dart';

class JourneyView extends GetView<JourneyLogic> {
  const JourneyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      child: GetBuilder<JourneyLogic>(
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(theme),
              SizedBox(height: ScreenUtil().setHeight(24)),
              _buildStatsGrid(theme, logic),
              SizedBox(height: ScreenUtil().setHeight(24)),
              _buildAchievementCard(theme),
              SizedBox(height: ScreenUtil().setHeight(20)),
              _buildAchievementHints(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHero(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(24),
        horizontal: ScreenUtil().setWidth(20),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                ),
                child: Icon(
                  Icons.route,
                  size: ScreenUtil().setSp(28),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Lang.journeyTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(22),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(4)),
                    Text(
                      Lang.journeySubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: ScreenUtil().setSp(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme, JourneyLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.profileOverview,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                theme: theme,
                icon: Icons.directions_walk,
                label: Lang.journeyTotalSteps,
                value: _formatNumber(logic.totalSteps),
                color: AppTheme.primary,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(12)),
            Expanded(
              child: _StatBlock(
                theme: theme,
                icon: Icons.check_circle,
                label: '${Lang.journeyCheckinDays}${Lang.commonDays}',
                value: '${logic.consecutiveCheckin}',
                color: AppTheme.cta,
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Row(
          children: [
            Expanded(
              child: _StatBlock(
                theme: theme,
                icon: Icons.water_drop,
                label: '${Lang.journeyWaterDays}${Lang.commonDays}',
                value: '${logic.waterAchievedDays}',
                color: AppTheme.water,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(12)),
            Expanded(
              child: _StatBlock(
                theme: theme,
                icon: Icons.emoji_events,
                label: Lang.journeyAchievements,
                value: Lang.journeyUnlockMore,
                color: AppTheme.calorie,
                isAction: true,
                onTap: () => Get.toNamed('/meter_achievements'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final k = (n / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
      return '${k}k';
    }
    return '$n';
  }

  Widget _buildAchievementCard(ThemeData theme) {
    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
      elevation: theme.cardTheme.elevation ?? 2,
      child: InkWell(
        onTap: () => Get.toNamed('/meter_achievements'),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Row(
            children: [
              Container(
                width: ScreenUtil().setWidth(56),
                height: ScreenUtil().setWidth(56),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.calorie,
                      AppTheme.calorie.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: ScreenUtil().setSp(28),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Lang.journeyAchievements,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(4)),
                    Text(
                      Lang.achievementsHowToGet,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: ScreenUtil().setSp(14),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementHints(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: ScreenUtil().setSp(20),
                  color: AppTheme.calorie,
                ),
                SizedBox(width: ScreenUtil().setWidth(8)),
                Text(
                  Lang.achievementsHowToTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            _buildHintRow(theme, Icons.directions_walk, AppTheme.primary, Lang.achievementsSteps10k),
            SizedBox(height: ScreenUtil().setHeight(12)),
            _buildHintRow(theme, Icons.check_circle, AppTheme.cta, Lang.achievementsCheckin7),
            SizedBox(height: ScreenUtil().setHeight(12)),
            _buildHintRow(theme, Icons.water_drop, AppTheme.water, Lang.achievementsWater2l),
          ],
        ),
      ),
    );
  }

  Widget _buildHintRow(ThemeData theme, IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: ScreenUtil().setWidth(32),
          height: ScreenUtil().setWidth(32),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          ),
          child: Icon(icon, size: ScreenUtil().setSp(18), color: color),
        ),
        SizedBox(width: ScreenUtil().setWidth(12)),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
              fontSize: ScreenUtil().setSp(13),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isAction;
  final VoidCallback? onTap;

  const _StatBlock({
    required this.theme,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isAction = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setWidth(40),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
            ),
            child: Icon(icon, size: ScreenUtil().setSp(22), color: color),
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(18),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ScreenUtil().setHeight(4)),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: ScreenUtil().setSp(12),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (isAction && onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusCard)),
          child: child,
        ),
      );
    }
    return child;
  }
}
