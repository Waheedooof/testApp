import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:test_maker/controller/question_controllers/question_controller.dart';
import 'package:test_maker/core/class/handelingview.dart';

import '../widget/appbar.dart';

class QuestionDataPage extends StatelessWidget {
  QuestionDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());
    appTextField(int index) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(
            width: 1,
            color: Get.theme.primaryColor.withOpacity(0.4),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: TextFormField(
          cursorColor: Get.theme.primaryColor.withOpacity(0.4),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(2),
            border: InputBorder.none,
          ),
          controller: TextEditingController(
            text: questionController.questionRow[index].toString(),
          ),
          autofocus: false,
          textInputAction: TextInputAction.next,
          // enabled: true,
          maxLines: index == 0 ? 3 : 1,
          style: Get.textTheme.bodyText1,
          textAlign: TextAlign.center,
          // padding: const EdgeInsets.all(8),
          onChanged: (value) {
            questionController.editLabel(
              value,
              index,
            );
          },
        ),
      );
      return CupertinoTextField(
        enableInteractiveSelection: true,
        enabled: true,
        maxLines: index == 0 ? 3 : 1,
        decoration: BoxDecoration(
          border: Border.all(
            color: Get.theme.primaryColor,
          ),
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        style: Get.textTheme.bodyText1!.copyWith(fontSize: 11),
        textAlign: TextAlign.center,
        padding: const EdgeInsets.all(10),
        controller: TextEditingController(
          text: questionController.questionRow[index].toString(),
        ),
        onChanged: (value) {
          print('$index $value');
          questionController.editLabel(
            value,
            index,
          );
        },
      );
    }

    imageWidget() {
      print(questionController.questionRow);
      if (questionController.isContainHttp(questionController.questionRow)) {
        return Container(
          width: Get.width / 3,
          height: Get.width / 3,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: PhotoView(
            customSize: Size(Get.width / 3, Get.width / 3),
            backgroundDecoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(0.3),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            imageProvider: CachedNetworkImageProvider(
              questionController.questionRow
                  .where((element) => questionController.isContainHttp(element))
                  .toList()
                  .first,
            ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
          ),
        );
      } else if (questionController
          .isContainPath(questionController.questionRow)) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: Get.width / 2,
          height: Get.width / 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(
                File(questionController.questionRow
                        .where((element) =>
                            questionController.isContainPath(element))
                        .toList()
                        .first
                        .replaceAll('path:', '')
                    // .replaceAll(']', ''),
                    ),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    }

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        // if (details.primaryVelocity! > 0) {
        //   Get.back();
        // }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await questionController.editDataWithServer();

            Get.back();
          },
          child: GetBuilder<QuestionController>(builder: (controller) {
            return HandelingView(
              statusRequest: controller.statusRequest,
              widget: const Icon(Icons.done),
            );
          }),
        ),
        body: AppCustomAppBar(
          title: Text('${tr('edit')} ${questionController.getQuestionIndex()}'),
          actions: [
            IconButton(
              onPressed: () {
                questionController.addImagePath();
              },
              icon: Icon(
                Icons.image,
                color: Get.theme.primaryColor,
              ),
            ),
          ],
          body: GetBuilder<QuestionController>(
            builder: (questionController) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            questionController.isContainHttp(
                                    questionController.questionRow)
                                ? IconButton(
                                    onPressed: () async {
                                      await questionController
                                          .removeImageAtAll();
                                    },
                                    icon: Icon(
                                      CupertinoIcons.delete,
                                      color: Get.theme.primaryColor,
                                    ),
                                  )
                                : Container(),
                            imageWidget(),
                          ],
                        ),
                        Column(
                          children: List.generate(
                            questionController.questionRow.length + 1,
                            (index) {
                              if (index == 7) {
                                return Container(
                                  color: Get.theme.scaffoldBackgroundColor,
                                  height: Get.height / 10,
                                );
                              } else if (index > 5) {
                                return Container();
                              } else {
                                return Column(
                                  children: [
                                    index == 0
                                        ? Divider(
                                            height: 30,
                                            color: Get.theme.highlightColor,
                                            thickness: 0.1,
                                          )
                                        : Container(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Get.width / 4,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              index == 0
                                                  ? tr('question')
                                                  : index == 5
                                                      ? tr('info')
                                                      : index == 6
                                                          ? tr('index_answer')
                                                          : ('${tr('answer')} $index'),
                                              textAlign: TextAlign.center,
                                              style: Get.textTheme.bodyText1!
                                                  .copyWith(fontSize: 11),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: appTextField(index),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                        color: Colors.white, height: 10),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
