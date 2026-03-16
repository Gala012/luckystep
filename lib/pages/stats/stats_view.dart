import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'stats_logic.dart';

class StatsView extends GetView<StatsLogic> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.statsTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: GetBuilder<StatsLogic>(
          builder: (logic) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.statsOverview,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenUtil().setHeight(12)),
                Row(
                  children: [
                    Expanded(
                      child: _StatIconCard(
                        icon: Icons.directions_walk,
                        label: Lang.statsSteps,
                        value: '${logic.totalSteps}',
                        subLabel: '${logic.stepDays} ${Lang.commonDays}',
                        color: AppTheme.primary,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(12)),
                    Expanded(
                      child: _StatIconCard(
                        icon: Icons.water_drop,
                        label: Lang.statsWater,
                        value: '${logic.totalWater}',
                        subLabel: '${logic.waterDays} ${Lang.commonDays}',
                        color: AppTheme.water,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(24)),
                Row(
                  children: [
                    Icon(Icons.show_chart, size: ScreenUtil().setSp(22), color: AppTheme.primary),
                    SizedBox(width: ScreenUtil().setWidth(8)),
                    Text(
                      Lang.statsLineChart,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                SizedBox(
                  height: ScreenUtil().setHeight(200),
                  child: logic.stepSpots.isNotEmpty
                      ? _buildStepChart(context, logic)
                      : Center(
                          child: Text(
                            Lang.statsNoData,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
                SizedBox(height: ScreenUtil().setHeight(24)),
                Row(
                  children: [
                    Icon(Icons.bar_chart, size: ScreenUtil().setSp(22), color: AppTheme.water),
                    SizedBox(width: ScreenUtil().setWidth(8)),
                    Text(
                      Lang.statsBarChart,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                SizedBox(
                  height: ScreenUtil().setHeight(200),
                  child: logic.waterSpots.isNotEmpty
                      ? _buildWaterChart(context, logic)
                      : Center(
                          child: Text(
                            Lang.statsNoData,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepChart(BuildContext context, StatsLogic logic) {
    final theme = Theme.of(context);
    final spots = logic.stepSpots;
    final dateLabels = logic.dateLabels;
    final maxY = spots.isEmpty
        ? 100.0
        : (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2)
            .clamp(100.0, double.infinity);
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ScreenUtil().setWidth(36),
              interval: maxY / 4,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  value >= 100 ? '${(value / 1000).toStringAsFixed(1)}k' : '${value.toInt()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: ScreenUtil().setSp(10),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ScreenUtil().setHeight(28),
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i >= 0 && i < dateLabels.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      dateLabels[i],
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: ScreenUtil().setSp(10),
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primary,
            barWidth: 2,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }

  Widget _buildWaterChart(BuildContext context, StatsLogic logic) {
    final theme = Theme.of(context);
    final spots = logic.waterSpots;
    final dateLabels = logic.dateLabels;
    final maxY = spots.isEmpty
        ? 100.0
        : (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2)
            .clamp(100.0, double.infinity);
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ScreenUtil().setWidth(36),
              interval: maxY / 4,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: ScreenUtil().setSp(10),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ScreenUtil().setHeight(28),
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i >= 0 && i < dateLabels.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      dateLabels[i],
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: ScreenUtil().setSp(10),
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        barGroups: spots
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.y,
                    color: AppTheme.water,
                    width: ScreenUtil().setWidth(16),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ScreenUtil().radius(4)),
                    ),
                  ),
                ],
                showingTooltipIndicators: [],
              ),
            )
            .toList(),
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }
}

class _StatIconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subLabel;
  final Color color;

  const _StatIconCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: ScreenUtil().setWidth(36), color: color),
            SizedBox(height: ScreenUtil().setHeight(12)),
            Text(
              value,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(22),
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
