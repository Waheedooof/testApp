import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/core/constant/approutes.dart';
import 'package:test_maker/core/services/services.dart';

class MiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;
  final MyServices _myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (_myServices.sharedPreferences.containsKey('lang')) {
      // return RouteSettings(name: AppRoute.homePage);
    } else {
      return RouteSettings(name: AppRoute.chooseLang);
    }
  }
}
