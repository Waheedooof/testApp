import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/core/theme/themes.dart';
import 'package:test_maker/view/widget/custom_card.dart';
import '../../../controller/home_controllers/exam_cont.dart';
import '../../../controller/home_controllers/excel_file_cont.dart';
import '../../../core/constant/approutes.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({Key? key}) : super(key: key);

  ExcelFileController excelFileController = Get.find();
  ExamController examControllerBuild = Get.find();

  String getFirstName(String last) {
    if (last.length >= 12) {
      return last.replaceRange(12, last.length, '...');
    } else {
      return last;
    }
  }

  markWidget(context) {
    return InkWell(
      onTap: () {
        int sum = examControllerBuild.falseSum + examControllerBuild.trueSum;
        String avg = (examControllerBuild.trueSum / sum).isNaN
            ? '0'
            : (((examControllerBuild.trueSum / sum) * 100).toStringAsFixed(1));

        showDialog(
          context: context,
          builder: (context) => Theme(
            data: ThemeApp().getDialogTheme(),
            child: AlertDialog(
              titlePadding: const EdgeInsets.all(10),
              title: Text(tr('results'), textAlign: TextAlign.center),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tr('trueAnswers')}: ${examControllerBuild.trueSum}',
                    style: const TextStyle(color: Colors.green),
                  ).tr(),
                  Text(
                    '${tr('falseAnswers')}: ${examControllerBuild.falseSum}',
                    style: const TextStyle(color: Colors.red),
                  ).tr(),
                  Text(
                    '${tr('count')}   : $sum',
                    // style: const TextStyle(fontSize: 21),
                  ).tr(),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${tr('avg')}           : $avg %',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ).tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: CustomCard(
        widget: Text(
          '${tr('mark')} ${examControllerBuild.trueSum}',
          style: TextStyle(
            color: Get.theme.scaffoldBackgroundColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  examMode(context) {
    return Obx(
      () {
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Theme(
                data: ThemeApp().getDialogTheme(),
                child: AlertDialog(
                  titlePadding: const EdgeInsets.all(10),
                  title: Text(tr('exam_mode'), textAlign: TextAlign.center),
                  content: Container(
                    child: examControllerBuild.isNotExamMode.value
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                              const Text(
                                'you_exit',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ).tr(),
                              ElevatedButton(
                                onPressed: () {
                                  excelFileController.changeReadMode();
                                  examControllerBuild.setCheat();
                                  Get.back();
                                },
                                child: Text(excelFileController.readMode
                                    ? 'hide_answers'
                                    : 'show_answers')
                                    .tr(),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                              const Text(
                                'not_exit',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ).tr(),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  examControllerBuild.startExam();
                                  Get.back();
                                },
                                child: Text(
                                  examControllerBuild.minutes.value == 0
                                      ? tr('start')
                                      : tr('cancel'),
                                ),
                              ),
                              examControllerBuild.minutes.value == 0
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () {
                                        examControllerBuild.stopExam();
                                        Get.back();
                                      },
                                      child: Text(
                                        examControllerBuild.timer.isActive
                                            ? tr('stop')
                                            : tr('resume'),
                                      ),
                                    ),
                              ElevatedButton(
                                onPressed: () {
                                  excelFileController.changeReadMode();
                                  examControllerBuild.setCheat();
                                  Get.back();
                                },
                                child: Text(excelFileController.readMode
                                        ? 'hide_answers'
                                        : 'show_answers')
                                    .tr(),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
          child: CustomCard(
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 8,
                  backgroundColor: examControllerBuild.isNotExamMode.value
                      ? Colors.red
                      : examControllerBuild.isClick.value
                          ? Get.theme.primaryColor.withOpacity(0.5)
                          : Colors.lightGreenAccent.shade700,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${tr('min')} ${(examControllerBuild.minutes / 60).ceil()}',
                  style: TextStyle(
                    color: Get.theme.scaffoldBackgroundColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          excelFileController.searchQuestionsMode
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoTextField(
                      controller: excelFileController.searchQuestionController,
                      autofocus: true,
                      onChanged: (value) {
                        excelFileController.update();
                        print(
                            excelFileController.searchQuestionController.text);
                      },
                      textAlign: TextAlign.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Get.theme.primaryColor,
                        ),
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      style: Get.textTheme.bodyText1,
                    ),
                  ),
                )
              : Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: markWidget(context),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                        flex: 4,
                        child: examMode(context),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: excelFileController.searchQuestionsMode
                ? Get.width / 9
                : Get.width / 7,
            child: excelFileController.searchQuestionsMode
                ? IconButton(
                    onPressed: () {
                      excelFileController.changeSearchQuestions();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Get.theme.primaryColor,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      excelFileController.changeSearchQuestions();
                    },
                    icon: Icon(
                      CupertinoIcons.search,
                      color: Get.theme.primaryColor,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
