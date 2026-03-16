import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../lang/lang.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.helpTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Steps', 'Track your daily steps. Set a goal and check your progress on the home screen.'),
            _section('Timer', 'Use the timer for count-up or count-down. Tap the timer card on the home screen to open it.'),
            _section('Water', 'Record your water intake. Add each drink to reach your daily goal.'),
            _section('Check-in', 'Tap to check in daily. Build a streak to stay motivated.'),
            _section('Statistics', 'View charts for steps and water in the Profile > Statistics.'),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(8)),
          Text(
            content,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              height: 1.5,
            ),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
