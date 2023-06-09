import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/exam_cont.dart';
import 'package:test_maker/core/constant/approutes.dart';
import 'package:test_maker/core/services/services.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

import '../core/class/statusrequest.dart';
import '../core/function/checkinternet.dart';
import '../data/datasource/remote/home/login.dart';

class AuthController extends GetxController {
  bool showText = true;

  TextEditingController passwordTextController = TextEditingController();

  late GlobalKey<FormState> formState = GlobalKey<FormState>();
  StatusRequest? statusRequest = StatusRequest.none;
  final LoginData loginData = LoginData(Get.find());

  // final LoginData loginData = LoginData(Get.find());
  MyServices myServices = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  login() async {
    passwordTextController.text=passwordTextController.text.removeAllWhitespace;
    if(passwordTextController.text.length>=6) {
      if (await checkInternet()) {
        statusRequest = StatusRequest.loading;
        update();

        try {
          var response = await loginData.loginTeacher(
            teacherCode: passwordTextController.text,
          );
          print('===========login===${response}======');
          if (response['status'] == 'success') {
            statusRequest = StatusRequest.success;
            await myServices.sharedPreferences
                .setString('password', DateTime.now().year.toString());
            await myServices.sharedPreferences
                .setString('teacherCode', passwordTextController.text);
            Get.offNamed(AppRoute.homePage);
          } else {
            statusRequest = StatusRequest.failure;
          }
        } catch (e) {
          print('===========login catch=========');
          statusRequest = StatusRequest.failure;
        }

        print(statusRequest);
      } else {
        statusRequest = StatusRequest.serverExp;
      }
    }else{
      statusRequest = StatusRequest.failure;

    }
    update();
  }

  changeShowText() {
    showText = !showText;
    update();
  }

  Future<void> logout() async {
    await myServices.sharedPreferences.remove('password');
    await myServices.sharedPreferences.remove('tablePath');
    ExamController().reset();
    Get.offNamed(AppRoute.authPage);
  }

  Future<void> scan(BuildContext context) async {
    try {
      QrBarCodeScannerDialog().getScannedQrBarCode(
          context: context,
          onCode: (code) async {
            print(code);
            passwordTextController.text = code!;
            await login();
          });
    } catch (e) {
      // Handle any scanning errors
    }
  }
}
