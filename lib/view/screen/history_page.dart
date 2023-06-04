import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/app_controller.dart';

import '../widget/appbar.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LifeCycleController>(
      builder: (controller) {
        int length = controller.events.length;
        List times = controller.events;
        return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 100) {
              Get.back();
            }
          },
          child: Scaffold(
            body: AppCustomAppBar(
              title: const Text('history').tr(),
              actions: [],
              body: Center(
                child: times.isEmpty
                    ? const Text('No History')
                    : ListView.builder(
                        itemExtent: Get.height / 12,
                        itemCount: length,
                        itemBuilder: (context, index) {
                          bool isToday = times[length - index - 1].contains(
                            controller.getNowTime2(DateTime.now()),
                          );
                          bool isStart = times[length - index - 1]
                              .toString()
                              .contains('start');
                          bool isResume = times[length - index - 1]
                              .toString()
                              .contains('sum');
                          bool isInactive = times[length - index - 1]
                              .toString()
                              .contains('active');
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            color: isToday
                                ? Get.theme.primaryColor.withOpacity(0.5)
                                : Get.theme.primaryColor.withOpacity(0.3),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Container()),
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: Text(
                                        ' ${index + 1} ',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isStart
                                              ? Colors.red
                                              : Get.theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  Text(
                                    times[length - index - 1],
                                    style: TextStyle(
                                      color: Get.theme.scaffoldBackgroundColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: isStart
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    child: Center(
                                      child: Text(
                                        isToday ? 'today' : '',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Get.theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
