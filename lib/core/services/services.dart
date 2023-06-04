import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_maker/core/theme/colors.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  Future<MyServices> init() async {
    // await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    sharedPreferences = await SharedPreferences.getInstance();
    print('==============init==============');
    return this;
  }
}

Future initServices() async {
  await Get.putAsync(() => MyServices().init());
}
