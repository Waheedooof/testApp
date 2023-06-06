import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/exam_cont.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:test_maker/core/constant/approutes.dart';
import 'package:test_maker/core/services/services.dart';

import '../core/class/statusrequest.dart';

class AuthController extends GetxController {
  bool showText = true;

  TextEditingController password = TextEditingController();

  late GlobalKey<FormState> formState = GlobalKey<FormState>();
  StatusRequest? statusRequest = StatusRequest.none;

  // final LoginData loginData = LoginData(Get.find());
  MyServices myServices = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  auth() async {
    statusRequest = StatusRequest.loading;
    update();
    Timer(const Duration(seconds: 2), () {
      statusRequest = StatusRequest.success;
      update();
      myServices.sharedPreferences.setString('auth', 'password');
      Get.offNamed(AppRoute.homePage);
    });
  }

  changeShowText() {
    showText = !showText;
    update();
  }

  Future<void> logout() async {
    await myServices.sharedPreferences.remove('auth');
    await myServices.sharedPreferences.remove('tablePath');
    ExamController().reset();
    Get.offNamed(AppRoute.authPage);
  }
}
