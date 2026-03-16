import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../lang/lang.dart';
import '../../../utils/app_theme.dart';
import 'guide_logic.dart';

class GuideView extends GetView<GuideLogic> {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<GuideLogic>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            title: Text(Lang.appName),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(100),
                            height: ScreenUtil().setWidth(100),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(ScreenUtil().radius(24)),
                            ),
                            child: Icon(
                              Icons.directions_walk,
                              size: ScreenUtil().setWidth(56),
                              color: AppTheme.primary,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(32)),
                          Text(
                            Lang.guideTitle,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(12)),
                          Text(
                            Lang.guideSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(52),
                    child: ElevatedButton(
                      onPressed: () => logic.onTapStart(),
                      child: Text(Lang.guideStart),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(32)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
