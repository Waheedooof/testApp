import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_maker/core/services/services.dart';

import 'home_controllers/exam_cont.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  MyServices myServices = Get.find();
  List<String> events = [];

  @override
  void onInit() {
    sharedAssign();
    start();
    super.onInit();
  }

  start() {
    myServices.sharedPreferences.setStringList(
        'list', events + ['start ${getNowTime(DateTime.now())}']);
    sharedAssign();
  }

  void sharedAssign() async {
    if (myServices.sharedPreferences.containsKey('list')) {
      List<String> list = myServices.sharedPreferences.getStringList('list')!;
      events = list;
      if (list.length > 200) {
        list.removeRange(1, 50);
        myServices.sharedPreferences.setStringList('list', list);
      }
    }
    update();
  }

  String getNowTime(DateTime date) {
    return '${date.year}-${date.month}-${date.day}   ${date.hour}:${date.minute}:${date.second}';
  }

  String getNowTime2(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void onDetached() {
    // print('====================onDetached=======================');
    // myServices.sharedPreferences.setStringList(
    //     'list', events + ['Detached ${getNowTime(DateTime.now())}']);
    // sharedAssign();
  }

  @override
  void onInactive() {
    // print('====================onInactive=======================');
    // myServices.sharedPreferences.setStringList(
    //     'list', events + ['Inactive ${getNowTime(DateTime.now())}']);
    // sharedAssign();
  }

  @override
  void onPaused() {
    print('====================onPaused=======================');

    myServices.sharedPreferences.setStringList(
        'list', events + ['Paused ${getNowTime(DateTime.now())}']);
    sharedAssign();
    ExamController examController = Get.find();
    examController.setCheat();
  }

  @override
  void onResumed() {
    print('====================onResumed=======================');
    myServices.sharedPreferences.setStringList(
        'list', events + ['Resumed ${getNowTime(DateTime.now())}']);
    sharedAssign();
  }

  void resetHistory() {
    myServices.sharedPreferences.remove('list');
    events.clear();
    sharedAssign();
  }
}
