import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sensors/sensors.dart';
import 'package:test_maker/core/services/services.dart';

class HomeController extends GetxController {
  // ScrollController scrollController = ScrollController();
  RxBool isUpScroll = true.obs;
  RxBool isReverseList = false.obs;
  // final MyServices _myServices = Get.find();

  bool isWalk = false;
  double rotationX = 0;
  double rotationY = 0;
  double rotationZ = 0;

  @override
  void onInit() {
    // scrollController.addListener(() {
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     isUpScroll.value = true;
    //   } else {
    //     isUpScroll.value = false;
    //   }
    // });



    gyroscopeEvents.listen((GyroscopeEvent event) {
      rotationX = event.x * 0.03;
      rotationY = event.y * 0.03;
      rotationZ = event.z * 0.03;
      update();
    });
    super.onInit();
  }

  setWalk() {
    isWalk = !isWalk;
    update();
  }

  reverseList() {
    isReverseList.value = !isReverseList.value;
    update();
  }


}
