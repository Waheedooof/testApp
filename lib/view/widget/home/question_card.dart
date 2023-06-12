import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/_http/_io/_file_decoder_io.dart';
import 'package:photo_view/photo_view.dart';
import 'package:test_maker/controller/home_controllers/exam_cont.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/question_controllers/question_controller.dart';
import 'package:test_maker/core/class/handelingview.dart';
import 'package:test_maker/core/constant/approutes.dart';
import 'package:test_maker/view/screen/imagePage.dart';
import 'package:test_maker/view/widget/appcachiamge.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/theme/app_dimentions.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({super.key, required this.questionColumnIndex});

  int questionColumnIndex;

  ExamController examController = Get.find();
  ExcelFileController excelController = Get.find();

  Color getSideSelectedColor(int indexInRow) {
    return examController.isSelectedHistory(questionColumnIndex, indexInRow)
        ? Get.theme.primaryColor
        : Get.theme.scaffoldBackgroundColor;
  }

  double getSideSelectedWidth(int indexInRow) {
    return examController.isSelectedHistory(questionColumnIndex, indexInRow)
        ? 2
        : 0;
  }

  getTextColor(int indexInRow) {
    return examController.isCorrect(questionColumnIndex) == null &&
            examController.isChoose(questionColumnIndex, indexInRow)
        ? Get.theme.scaffoldBackgroundColor
        : examController.isCorrect(questionColumnIndex) != null &&
                excelController.csvTable[questionColumnIndex][6]
                    .toString()
                    .contains(indexInRow.toString())
            ? Get.theme.highlightColor
            : Get.theme.highlightColor;
  }

  Color getAnswersColor(int indexInRow) {
    return examController.isCorrect(questionColumnIndex) == null &&
            examController.isChoose(questionColumnIndex, indexInRow)
        ? Get.theme.primaryColor.withOpacity(0.8)
        : examController.isCorrect(questionColumnIndex) != null &&
                excelController.csvTable[questionColumnIndex][6]
                    .toString()
                    .contains(indexInRow.toString())
            ? Colors.greenAccent.withOpacity(0.8)
            : Get.theme.scaffoldBackgroundColor;
  }

  Color getCorrectAnswersColor(int indexInRow) {
    return excelController.csvTable[questionColumnIndex][6]
            .toString()
            .contains(indexInRow.toString())
        ? Colors.greenAccent.withOpacity(0.8)
        : Get.theme.scaffoldBackgroundColor;
  }

  likeWidget() {
    return GestureDetector(
      onTap: () {
        excelController.editLikeDataFile(
          editRowIndex: questionColumnIndex,
        );
      },
      onLongPress: () {
        Get.toNamed(AppRoute.favoritePage);
      },
      child: excelController.csvTable[questionColumnIndex].contains('like')
          ? const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(Icons.favorite_border),
            ),
    );
  }

  Widget sureBtn() {
    return questionColumnIndex == examController.choose1.keys.first
        ? IconButton(
            onPressed: () {
              examController.add(questionColumnIndex);
            },
            icon: const Icon(
              Icons.done_outline_outlined,
            ),
          )
        : IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done_outline_outlined,
            ),
          );
  }

  infoWidget() {
    return IconButton(
      onPressed: () {
        infoSnackBar();
      },
      icon: const Icon(CupertinoIcons.info),
    );
  }

  Widget questionWidget() {
    return SizedBox(
      // width: Get.width - 20,
      child: Card(
        color: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDims.corners),
          ),
        ),
        child: questionLabel(),
      ),
    );
  }

  questionLabel() {
    return InkWell(
      onTap: () async {
        !excelController.isFileEditAble()
            ? null
            : await Get.toNamed(
                AppRoute.questionData,
                arguments: excelController.csvTable[questionColumnIndex],
              )?.whenComplete(() {
                examController.reset();
              });
      },
      child: Column(
        children: [
          Center(
            child: imageWidget(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10,
            ),
            child: Row(
              children: [
                questionIndex(),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    excelController.csvTable[questionColumnIndex][0].toString(),
                    textAlign: Get.locale?.languageCode == 'en'
                        ? TextAlign.left
                        : TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Get.theme.highlightColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget answersWidget() {
    return Column(
      children: List.generate(
        excelController.csvTable[questionColumnIndex].length,
        growable: false,
        (indexInRow) {
          List answers = [1, 2, 3, 4];

          if (!answers.contains(indexInRow) ||
              excelController.csvTable[questionColumnIndex][indexInRow]
                      .toString() ==
                  '') {
            return Container();
          } else {
            return InkWell(
              onTap: () {
                examController.chooseAnswerIndex(
                  questionColumnIndex,
                  indexInRow,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    answerIndex(indexInRow),
                    const SizedBox(
                      width: 5,
                    ),
                    answerLabel(indexInRow),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  answerLabel(indexInRow) {
    return Expanded(
      flex: 8,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: getSideSelectedWidth(indexInRow),
            color: getSideSelectedColor(indexInRow),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDims.corners),
          ),
        ),
        color: excelController.readMode
            ? getCorrectAnswersColor(indexInRow)
            : getAnswersColor(indexInRow),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Text(
            '${excelController.csvTable[questionColumnIndex][indexInRow]}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: getTextColor(indexInRow),
            ),
          ),
        ),
      ),
    );
  }

  answerIndex(indexInRow) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDims.corners),
        ),
      ),
      color: getAnswersColor(indexInRow),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Text(
          indexInRow.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: getTextColor(indexInRow),
          ),
        ),
      ),
    );
  }

  deleteSnackBar() {
    return Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 100),
        borderColor: Colors.grey,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        titleText: Text(
          'delete?',
          style: Get.textTheme.bodyText1,
        ).tr(),
        messageText: ElevatedButton(
          onPressed: () async {
            await excelController.deleteFromFile(
              deletedRowIndex: questionColumnIndex,
            );
            Get.back();
          },
          child: const Text('ok').tr(),
        ),
      ),
    );
  }

  imageWidget() {
    if (!excelController.containPath(questionColumnIndex)) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 11.0),
        child: InkWell(
          onTap: () {
            Get.to(
              () => ImageViewer(
                imagePath: excelController.getCsvTablePath(questionColumnIndex),
              ),
            );
          },
          child: Container(
            width: Get.width,
            height: Get.width / 2,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Get.theme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(AppDims.corners),
              ),
            ),
            child: GetBuilder<ExcelFileController>(builder: (controller) {
              return HandelingView(
                statusRequest: controller.statusRequest,
                widget: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDims.corners),
                  ),
                  child: PhotoView(
                    initialScale: PhotoViewComputedScale.contained,
                    customSize: Size(
                      Get.width,
                      Get.width / 2,
                    ),
                    backgroundDecoration: BoxDecoration(
                      color: Get.theme.highlightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppDims.corners),
                      ),
                    ),
                    imageProvider: CachedNetworkImageProvider(
                      excelController.getCsvTablePath(questionColumnIndex),
                    ),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                  ),
                ),
              );
            }),
          ),
          // child: SizedBox(
          //   width: Get.width / 5,
          //   height: Get.width / 5,
          //   child: AppCachImage(
          //       imageUrl: excelController.getCsvTablePath(questionColumnIndex)),
          // ),
        ),
      );
    }
  }

  Widget questionIndex() {
    return InkWell(
      onTap: () async {
        // await Get.toNamed(
        //   AppRoute.questionData,
        //   arguments: excelController.csvTable[questionColumnIndex],
        // );
        // examController.reset();
      },
      child: SizedBox(
        width: Get.width / 18,
        child: CircleAvatar(
          foregroundColor: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
          child: Center(
            child: Text(
              (questionColumnIndex + 1).toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  infoSnackBar() {
    String value = excelController.csvTable[questionColumnIndex][5].toString();
    return Get.showSnackbar(
      GetSnackBar(
        animationDuration: const Duration(milliseconds: 100),
        borderColor: Colors.grey,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        titleText: Text(
          'info',
          style: Get.textTheme.bodyText1,
        ).tr(),
        messageText: ElevatedButton(
          onPressed: () async {
            if (value == ''&&excelController.isFileEditAble()) {
              Get.toNamed(
                AppRoute.questionData,
                arguments: excelController.csvTable[questionColumnIndex],
              );
              Get.back();
            } else {
              Get.back();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              value == '' ? 'noInfo' : value,
              style: TextStyle(color: Get.theme.scaffoldBackgroundColor),
            ).tr(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // getPath();
    return InkWell(
      onLongPress: () {
        !excelController.isFileEditAble() ? null : deleteSnackBar();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                elevation: 5,
                shadowColor: Get.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDims.corners),
                  ),
                ),
                color: examController.isCorrect(questionColumnIndex) == true
                    ? Colors.green.withOpacity(0.8)
                    : examController.isCorrect(questionColumnIndex) == false
                        ? Colors.red.withOpacity(0.8)
                        : Get.theme.primaryColor.withOpacity(0.8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                  child: Column(
                    children: [
                      questionWidget(),
                      answersWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          infoWidget(),
                          sureBtn(),
                          likeWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
