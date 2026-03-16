import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'water_logic.dart';

class WaterView extends GetView<WaterLogic> {
  const WaterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.waterTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: GetBuilder<WaterLogic>(
          builder: (logic) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Lang.waterToday,
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
                              '${logic.todayAmount}',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: AppTheme.water,
                                fontSize: ScreenUtil().setSp(36),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ' / ${logic.waterGoal} ${Lang.waterMl}',
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
                                ? (logic.todayAmount / logic.waterGoal).clamp(0.0, 1.0)
                                : 0,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.water),
                            minHeight: ScreenUtil().setHeight(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(24)),
                Text(
                  Lang.waterAdd,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenUtil().setHeight(12)),
                Row(
                  children: [
                    _AddCup(theme: theme, ml: 100, onTap: () => logic.addWater(100)),
                    SizedBox(width: ScreenUtil().setWidth(12)),
                    _AddCup(theme: theme, ml: 200, onTap: () => logic.addWater(200)),
                    SizedBox(width: ScreenUtil().setWidth(12)),
                    _AddCup(theme: theme, ml: 250, onTap: () => logic.addWater(250)),
                    SizedBox(width: ScreenUtil().setWidth(12)),
                    _AddCup(theme: theme, ml: 500, onTap: () => logic.addWater(500)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AddCup extends StatelessWidget {
  final ThemeData theme;
  final int ml;
  final VoidCallback onTap;

  const _AddCup({required this.theme, required this.ml, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(16)),
            child: Column(
              children: [
                Icon(Icons.water_drop, size: ScreenUtil().setWidth(32), color: AppTheme.water),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  '$ml ml',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
