import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.aboutTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.directions_walk,
                size: ScreenUtil().setWidth(64),
                color: AppTheme.primary,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Center(
              child: Text(
                'Lucky Star Pedometer',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(24)),
            Text(
              'A fitness app to help you track steps, time your activities, record water intake, and build daily check-in habits. All data is stored locally on your device.',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                height: 1.6,
              ),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
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
}
