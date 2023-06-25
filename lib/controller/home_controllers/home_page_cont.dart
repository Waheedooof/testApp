import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sensors/sensors.dart';
import 'package:test_maker/controller/home_controllers/files_contoller.dart';

class HomeController extends GetxController {
  RxBool isReverseList = false.obs;
  late ScrollController scrollController = ScrollController();

  // final MyServices _myServices = Get.find();

  bool isWalk = false;
  double rotationX = 0;
  double rotationY = 0;
  double rotationZ = 0;

  @override
  void onInit() {
    scrollController.addListener(
      () {
        FilesController filesController = Get.find();
        if (filesController.showFilesList) {
          filesController.changeShowList();
        }
      },
    );

    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (isWalk) {
        rotationX = event.x * 0.04;
        rotationY = event.y * 0.04;
        rotationZ = event.z * 0.04;
        update();
      }
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
