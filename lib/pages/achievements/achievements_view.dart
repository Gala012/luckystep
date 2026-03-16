import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'achievements_logic.dart';

class AchievementsView extends GetView<AchievementsLogic> {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.achievementsTitle),
      ),
      body: GetBuilder<AchievementsLogic>(
        builder: (logic) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (logic.items.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: ScreenUtil().setWidth(16),
                        mainAxisSpacing: ScreenUtil().setHeight(16),
                      ),
                      itemCount: logic.items.length,
                    itemBuilder: (_, i) {
                      final item = logic.items[i];
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: ScreenUtil().setWidth(48),
                                color: AppTheme.primary,
                              ),
                              SizedBox(height: ScreenUtil().setHeight(8)),
                              Text(
                                item.name,
                                style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (logic.items.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                    child: Text(
                      Lang.achievementsEmpty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Lang.achievementsHowToGet,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      _buildHowToItem(theme, Icons.directions_walk, Lang.achievementsSteps10k),
                      SizedBox(height: ScreenUtil().setHeight(8)),
                      _buildHowToItem(theme, Icons.check_circle, Lang.achievementsCheckin7),
                      SizedBox(height: ScreenUtil().setHeight(8)),
                      _buildHowToItem(theme, Icons.water_drop, Lang.achievementsWater2l),
                      SizedBox(height: ScreenUtil().setHeight(24)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHowToItem(ThemeData theme, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: ScreenUtil().setSp(20), color: AppTheme.primary),
        SizedBox(width: ScreenUtil().setWidth(8)),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
              fontSize: ScreenUtil().setSp(14),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
