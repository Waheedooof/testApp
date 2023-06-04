import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/exam_cont.dart';
import '../../controller/home_controllers/excel_file_cont.dart';
import '../widget/appbar.dart';
import '../widget/home/question_card.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({Key? key}) : super(key: key);

  ExcelFileController excelFileController = Get.find();

  body() {
    return GetBuilder<ExcelFileController>(
      builder: (controller) {
        List favorites = [];
        for (List list in excelFileController.csvTable) {
          if (list.length == 8) {
            favorites.add(list);
          }
        }

        return favorites.isNotEmpty
            ? ListView.separated(
                itemCount: excelFileController.csvTable.length,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  if (excelFileController.csvTable[index].length == 8) {
                    return GetBuilder<ExamController>(builder: (controller) {
                      return QuestionCard(
                        questionColumnIndex: index,
                      );
                    });
                  } else {
                    return Container();
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 0,
                  );
                },
              )
            : Center(
                child: Text(
                  'no_data',
                  style: Get.textTheme.bodyText1,
                ).tr(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 100) {
          // user swiped from left to right
          Get.back();
        }
      },
      child: Scaffold(
        body: AppCustomAppBar(
          title: const Text('favorite').tr(),
          actions: [],
          body: Center(
            child: body(),
          ),
        ),
      ),
    );
  }
}
