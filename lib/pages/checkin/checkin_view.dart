import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'checkin_logic.dart';

class CheckinView extends GetView<CheckinLogic> {
  const CheckinView({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.checkinTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: GetBuilder<CheckinLogic>(
          builder: (logic) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayCard(theme, logic),
                SizedBox(height: ScreenUtil().setHeight(20)),
                _buildMotivation(theme, logic),
                SizedBox(height: ScreenUtil().setHeight(20)),
                _buildMonthStats(theme, logic),
                SizedBox(height: ScreenUtil().setHeight(20)),
                _buildCalendar(theme, logic),
                SizedBox(height: ScreenUtil().setHeight(20)),
                _buildRecentSection(theme, logic),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTodayCard(ThemeData theme, CheckinLogic logic) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Column(
          children: [
            Text(
              Lang.checkinToday,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            logic.checkedToday
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.cta,
                        size: ScreenUtil().setWidth(48),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(12)),
                      Text(
                        Lang.checkinDone,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(52),
                    child: ElevatedButton.icon(
                      onPressed: () => logic.doCheckin(),
                      icon: const Icon(Icons.check_circle),
                      label: Text(Lang.checkinDo),
                    ),
                  ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Text(
              '${Lang.checkinConsecutive}: ${logic.consecutiveDays} ${Lang.commonDays}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivation(ThemeData theme, CheckinLogic logic) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(AppTheme.radiusButton)),
      ),
      child: Text(
        logic.motivationText,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.primary,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMonthStats(ThemeData theme, CheckinLogic logic) {
    final rate = logic.thisMonthTotal > 0
        ? ((logic.thisMonthDays / logic.thisMonthTotal) * 100).toStringAsFixed(0)
        : '0';
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Lang.checkinThisMonth,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(4)),
                  Text(
                    '${logic.thisMonthDays} / ${logic.thisMonthTotal} ${Lang.commonDays}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: ScreenUtil().setHeight(40),
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Lang.checkinRate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(4)),
                  Text(
                    '$rate%',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.cta,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, CheckinLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.checkinCalendar,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Card(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: Lang.checkinWeekLabels
                      .map((l) => SizedBox(
                            width: ScreenUtil().setWidth(36),
                            child: Text(
                              l,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: ScreenUtil().setSp(12),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: ScreenUtil().setHeight(12)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    crossAxisSpacing: ScreenUtil().setWidth(4),
                    mainAxisSpacing: ScreenUtil().setHeight(4),
                  ),
                  itemCount: logic.calendarDays.length,
                  itemBuilder: (_, i) {
                    final c = logic.calendarDays[i];
                    if (c.day == 0) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.checked
                            ? AppTheme.cta.withValues(alpha: 0.2)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${c.day}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: ScreenUtil().setSp(12),
                          color: c.checked
                              ? AppTheme.cta
                              : theme.colorScheme.onSurface,
                          fontWeight: c.checked ? FontWeight.w600 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSection(ThemeData theme, CheckinLogic logic) {
    final now = DateTime.now();
    final dates = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.checkinRecent,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Card(
          child: Column(
            children: dates.map((dateStr) {
              final parts = dateStr.split('-');
              final label = parts.length >= 3
                  ? '${parts[1]}/${parts[2]}'
                  : dateStr;
              final checked = logic.recentCheckinDates.contains(dateStr);
              return ListTile(
                leading: Icon(
                  checked ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: ScreenUtil().setSp(22),
                  color: checked ? AppTheme.cta : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                title: Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: checked
                    ? Text(
                        Lang.checkinDone,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.cta,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
