import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:test_maker/core/class/handelingview.dart';
import '../widget/appbar.dart';
import 'package:math_keyboard/math_keyboard.dart';

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);
  ExcelFileController excelFileController = Get.find();

  textFieldWidget(int index) {
    return Container(
      decoration: BoxDecoration(
        color: excelFileController.mathMode
            ? Colors.black.withOpacity(0.6)
            : Colors.grey.withOpacity(0.3),
        border: Border.all(
          width: 1,
          color: Get.theme.primaryColor.withOpacity(0.4),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: excelFileController.mathMode
          ? MathField(
              opensKeyboard: true,
              autofocus: true,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                excelFileController.setRowValue(index, value);
              },
              controller: index == 0
                  ? excelFileController.textQuesControllerMath
                  : null,
            )
          : TextFormField(
              cursorColor: Get.theme.primaryColor.withOpacity(0.4),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(2),
                border: InputBorder.none,
              ),
              controller:
                  index == 0 ? excelFileController.textQuesController : null,
              autofocus: true,
              textInputAction: TextInputAction.next,
              // enabled: true,
              maxLines: index == 0 ? 3 : 1,
              style: Get.textTheme.bodyText1,
              textAlign: TextAlign.center,
              // padding: const EdgeInsets.all(8),
              onChanged: (value) {
                excelFileController.setRowValue(index, value);
              },
            ),
    );
    // return CupertinoTextField(
    //   controller: index == 0 ? excelFileController.textQuesController : null,
    //   autofocus: true,
    //   textInputAction: TextInputAction.next,
    //   // enabled: true,
    //   maxLines: index == 0 ? 3 : 1,
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       width: 0.5,
    //       color: Get.theme.primaryColor,
    //     ),
    //     color: Colors.grey.withOpacity(0.2),
    //     borderRadius: const BorderRadius.all(Radius.circular(8)),
    //   ),
    //   style: Get.textTheme.bodyText1,
    //   textAlign: TextAlign.center,
    //   padding: const EdgeInsets.all(8),
    //   onChanged: (value) {
    //     excelFileController.setRowValue(index, value);
    //   },
    // );
  }

  chooseAnswerIndexWidget(length) {
    return Row(
        children: List.generate(
      length,
      (index) {
        return Expanded(
          child: InkWell(
            onTap: () {
              excelFileController.setCorrect(index + 1);
            },
            child: Card(
              elevation: 0,
              color: excelFileController.correctAnswer
                      .toString()
                      .contains((index + 1).toString())
                  ? Get.theme.primaryColor.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (index + 1).toString(),
                    style: Get.textTheme.bodyText1,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));
  }

  copyPastButton(int index) {
    if (index == 0) {
      if (excelFileController.textQuesController.text.isEmpty) {
        return TextButton(
          onPressed: () {
            excelFileController.textQuesPaste();
          },
          child: Text(
            'paste',
            style: TextStyle(color: Get.theme.primaryColor),
          ).tr(),
        );
      } else {
        return TextButton(
          onPressed: () {
            excelFileController.textQuesCut();
          },
          child: Text(
            'cut',
            style: TextStyle(color: Get.theme.primaryColor),
          ).tr(),
        );
      }
    } else {
      return Container();
    }
  }

  labelWidget(int index) {
    return Container(
      width: Get.width / 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        border: excelFileController.correctAnswer
                .toString()
                .contains(index.toString())
            ? Border.all(color: Colors.green, width: 0.5)
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          index == 0
              ? tr('question')
              : index == 5
                  ? tr('info')
                  : index == 6
                      ? tr('index_answer')
                      : ('${tr('answer')} $index'),
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyText1,
        ),
      ),
    );
  }

  imageWidget() {
    if (excelFileController.questionAddRow.last != '' &&
        excelFileController.questionAddRow.length == 8) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: Get.width / 2,
        height: Get.width / 2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(
              File(
                excelFileController.questionAddRow[
                        excelFileController.questionAddRow.length - 1]
                    .replaceAll('path:', '')
                    .replaceAll(']', ''),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  floatingActionButton() {
    return FloatingActionButton(
      heroTag: 'add_hero',
      onPressed: () {
        excelFileController.writeQuesData();
      },
      child: GetBuilder<ExcelFileController>(builder: (controller) {
        return HandelingView(
          statusRequest: controller.statusRequest,
          widget: const Icon(Icons.done),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        // if (details.primaryVelocity! > 100) {
        //   Get.back();
        // }
      },
      child: Scaffold(
        body: AppCustomAppBar(
          title: const Text('type_q').tr(),
          actions: [
            IconButton(
              onPressed: () {
                excelFileController.addImagePath();
              },
              icon: Icon(
                Icons.image,
                color: Get.theme.primaryColor,
              ),
            ),
          ],
          body: Center(
            child: GetBuilder<ExcelFileController>(
              builder: (excelFileController) {
                return Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      left: 8.0,
                    ),
                    child: ListView(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          imageWidget(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  excelFileController.mathMode
                                      ? 'math'
                                      : 'normal',
                                  style:
                                      TextStyle(color: Get.theme.primaryColor),
                                ).tr(),
                                Switch(
                                  value: excelFileController.mathMode,
                                  activeColor: Get.theme.primaryColor,
                                  onChanged: (value) {
                                    excelFileController.changeMath();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(
                          8,
                          (index) {
                            int lengthOfChooses = excelFileController
                                .questionAddRow
                                .getRange(1, 5)
                                .where((element) => element != '')
                                .length;

                            if (index == 7) {
                              return Container(
                                color: Get.theme.scaffoldBackgroundColor,
                                height: Get.height / 12,
                              );
                            } else if (index == 0 ||
                                index == 6 ||
                                excelFileController
                                    .questionAddRow[index - 1].isNotEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        labelWidget(index),
                                        copyPastButton(index)
                                      ],
                                    ),
                                    Expanded(
                                      child: index == 6
                                          ? chooseAnswerIndexWidget(
                                              lengthOfChooses,
                                            )
                                          : textFieldWidget(
                                              index,
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 2,
                      )
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}
