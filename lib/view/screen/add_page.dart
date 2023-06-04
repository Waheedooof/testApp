import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';

import '../widget/appbar.dart';

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);
  ExcelFileController excelFileController = Get.find();

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

  textFieldWidget(int index, context) {
    return CupertinoTextField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      enabled: true,
      maxLines: index == 0 ? 3 : 1,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Get.theme.primaryColor,
        ),
        color: Colors.grey.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      style: Get.textTheme.bodyText1,
      textAlign: TextAlign.center,
      padding: const EdgeInsets.all(8),
      onChanged: (value) {
        excelFileController.setRowValue(index, value);
      },
    );
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

  floatingActionButton() {
    return FloatingActionButton(
      heroTag: 'add_hero',
      onPressed: () {
        excelFileController.writeData();
      },
      child: const Icon(Icons.done),
    );
  }

  @override
  Widget build(BuildContext context) {
    excelFileController.questionAddRow = ['', '', '', '', '', '', ''];
    excelFileController.correctAnswer = 0;

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 100) {
          Get.back();
        }
      },
      child: Scaffold(
        body: AppCustomAppBar(
          title: const Text('type_q').tr(),
          actions: const [],
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          8,
                          (index) {
                            int lengthOfChooses = excelFileController
                                .questionAddRow
                                .getRange(1, 5)
                                .where((element) => element != '')
                                .length;

                            return index == 7
                                ? Container(
                                    color: Get.theme.scaffoldBackgroundColor,
                                    height: Get.height / 12,
                                  )
                                : (index == 0 ||
                                        index == 6 ||
                                        excelFileController
                                            .questionAddRow[index - 1]
                                            .isNotEmpty)
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            labelWidget(index),
                                            Expanded(
                                              child: index == 6
                                                  ? chooseAnswerIndexWidget(
                                                      lengthOfChooses,
                                                    )
                                                  : textFieldWidget(
                                                      index,
                                                      context,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container();
                          },
                        ),
                      ),
                    ),
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
