import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'timer_logic.dart';

class TimerView extends GetView<TimerLogic> {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(Lang.timerTitle),
        elevation: 0,
      ),
      body: GetBuilder<TimerLogic>(
        builder: (logic) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              child: Column(
                children: [
                  SizedBox(height: ScreenUtil().setHeight(32)),
                  _buildModeChips(context, logic),
                  SizedBox(height: ScreenUtil().setHeight(40)),
                  _buildTimeDisplay(context, logic),
                  SizedBox(height: ScreenUtil().setHeight(48)),
                  _buildControls(logic),
                  if (!logic.isRunning && logic.elapsedSec == 0) ...[
                    SizedBox(height: ScreenUtil().setHeight(32)),
                    _buildPresets(context, logic),
                  ],
                  SizedBox(height: ScreenUtil().setHeight(32)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeChips(BuildContext context, TimerLogic logic) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(4),
        vertical: ScreenUtil().setHeight(4),
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              label: Lang.timerCountUp,
              selected: !logic.isCountDown,
              onTap: () => logic.setCountUp(),
            ),
          ),
          Expanded(
            child: _ModeChip(
              label: Lang.timerCountDown,
              selected: logic.isCountDown,
              onTap: () => logic.setCountDown(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context, TimerLogic logic) {
    final theme = Theme.of(context);
    return Container(
      width: ScreenUtil().setWidth(280),
      height: ScreenUtil().setWidth(280),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (logic.targetSec > 0)
            SizedBox(
              width: ScreenUtil().setWidth(260),
              height: ScreenUtil().setWidth(260),
              child: CircularProgressIndicator(
                value: logic.isCountDown
                    ? 1 - (logic.elapsedSec / logic.targetSec).clamp(0.0, 1.0)
                    : (logic.elapsedSec / logic.targetSec).clamp(0.0, 1.0),
                strokeWidth: ScreenUtil().setWidth(6),
                backgroundColor: AppTheme.secondary.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                logic.displayTime,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(56),
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: AppTheme.primary,
                  letterSpacing: 2,
                ),
              ),
              if (logic.targetSec > 0)
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                  child: Text(
                    '${logic.isCountDown ? '' : '${Lang.timerGoal} '}${(logic.targetSec / 60).round()} ${Lang.timerMinutes}',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresets(BuildContext context, TimerLogic logic) {
    final theme = Theme.of(context);
    final presets = [1, 5, 10, 15];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Lang.timerPresets,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        Row(
          children: presets.map((m) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                child: _PresetButton(
                  minutes: m,
                  onTap: () => logic.setTargetMinutes(m),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: ScreenUtil().setHeight(12)),
        _buildCustomButton(context, logic),
        SizedBox(height: ScreenUtil().setHeight(24)),
      ],
    );
  }

  Widget _buildCustomButton(BuildContext context, TimerLogic logic) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => logic.showSetMinutes(),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(14)),
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            border: Border.all(color: AppTheme.primary, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tune_rounded, size: ScreenUtil().setSp(20), color: AppTheme.primary),
              SizedBox(width: ScreenUtil().setWidth(8)),
              Text(
                Lang.timerCustom,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(TimerLogic logic) {
    final canStart = !logic.isRunning;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (logic.isRunning)
          _ControlButton(
            icon: Icons.pause_rounded,
            label: Lang.timerPause,
            onTap: () => logic.pause(),
            primary: true,
          )
        else ...[
          if (canStart)
            _ControlButton(
              icon: Icons.play_arrow_rounded,
              label: logic.elapsedSec == 0 ? Lang.timerStartCount : Lang.timerStart,
              onTap: () => logic.start(),
              primary: true,
            ),
          if (logic.elapsedSec > 0) ...[
            if (canStart) SizedBox(width: ScreenUtil().setWidth(16)),
            _ControlButton(
              icon: Icons.refresh_rounded,
              label: Lang.timerReset,
              onTap: () => logic.reset(),
              primary: false,
            ),
          ],
        ],
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(12)),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final int minutes;
  final VoidCallback onTap;

  const _PresetButton({required this.minutes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(16)),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '$minutes',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                Lang.timerMinutes,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
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

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(28),
            vertical: ScreenUtil().setHeight(16),
          ),
          decoration: BoxDecoration(
            color: primary ? AppTheme.primary : (Theme.of(context).cardTheme.color ?? Colors.white),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
            boxShadow: primary
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: ScreenUtil().setSp(24),
                color: primary ? Colors.white : AppTheme.primary,
              ),
              SizedBox(width: ScreenUtil().setWidth(8)),
              Text(
                label,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w600,
                  color: primary ? Colors.white : AppTheme.primary,
                ),
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
