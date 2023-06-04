import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_maker/controller/home_controllers/exam_cont.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/home_page_cont.dart';
import 'package:test_maker/core/constant/approutes.dart';
import 'package:test_maker/view/widget/home/question_card.dart';
import '../widget/custom_card.dart';
import '../widget/drawer.dart';
import '../widget/home/title_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  ExcelFileController excelFileController = Get.find();

  // listq(HomeController homeController) {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       (context, index) {
  //         return SizedBox(
  //           height: Get.height / 1.1,
  //           child: PageView.builder(
  //             scrollDirection: Axis.vertical,
  //             itemCount: excelFileController.csvTable.length,
  //             itemBuilder: (context, index) => QuestionCard(
  //               questionColumnIndex: homeController.isReverseList.value
  //                   ? excelFileController.csvTable.length - 1 - index
  //                   : index,
  //             ),
  //           ),
  //         );
  //       },
  //       childCount: 1,
  //     ),
  //   );
  // }

  list(HomeController homeController) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: excelFileController.csvTable.length,
        (context, index) {
          if (excelFileController.searchQuestionController.text.isNotEmpty) {
            if (excelFileController.csvTable[index]
                .toString()
                .isCaseInsensitiveContainsAny(
                    excelFileController.searchQuestionController.text)) {
              return QuestionCard(
                questionColumnIndex: homeController.isReverseList.value
                    ? excelFileController.csvTable.length - 1 - index
                    : index,
              );
            } else {
              return Container();
            }
          } else {
            return QuestionCard(
              questionColumnIndex: homeController.isReverseList.value
                  ? excelFileController.csvTable.length - 1 - index
                  : index,
            );
          }
        },
      ),
    );
  }

  readFileWidget() {
    return ElevatedButton(
      onPressed: () async {
        excelFileController.pickFile('');
        // await excelFileController.open2();
        Get.back();
      },
      child: ListTile(
        trailing: const Icon(Icons.read_more),
        title: Text(
          'read',
          style: TextStyle(
            color: Get.theme.scaffoldBackgroundColor,
          ),
        ).tr(),
      ),
    );
  }

  writeQuestionWidget() {
    return ElevatedButton(
      onPressed: () async {
        excelFileController.toAddScreen();
      },
      child: ListTile(
        trailing: const Icon(Icons.add),
        title: Text(
          'type_q',
          style: TextStyle(
            color: Get.theme.scaffoldBackgroundColor,
          ),
        ).tr(),
      ),
    );
  }

  noDataWidget() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Get.height / 3,
            horizontal: Get.width / 5,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              writeQuestionWidget(),
              const SizedBox(height: 20),
              readFileWidget(),
              SizedBox(
                height: Get.height/4,
                child: Center(
                  child: Text(
                    'no_data',
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  title() {
    return Text(
      'Tester',
      style: TextStyle(
        fontFamily: 'Cairo-ExtraLight',
        color: Get.theme.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  Matrix4? transform(HomeController homeController) {
    return homeController.isWalk
        ? Matrix4.rotationX(homeController.rotationX)
            .multiplied(Matrix4.rotationY(homeController.rotationY))
            .multiplied(Matrix4.rotationZ(homeController.rotationZ))
        : null;
  }

  appBar(context) {
    return SliverAppBar(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      snap: false,
      floating: false,
      stretch: true,
      pinned: true,
      stretchTriggerOffset: 100,
      title: TitleWidget(),
      leading: IconButton(
        icon: Icon(
          Icons.menu, // Replace with your desired icon
          color: Get.theme.primaryColor, // Replace with desired icon color
        ),
        onPressed: () {
          excelFileController.displayDrawer(context);
        },
      ),
      expandedHeight: Get.height / 7,
      toolbarHeight: Get.height / 18,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Get.theme.scaffoldBackgroundColor,
        statusBarIconBrightness: Get.theme.brightness,
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        title: title(),
        centerTitle: true,
        titlePadding: EdgeInsets.only(top: Get.height / 10),
      ),
    );
  }

  showCloseSnackBar(context) {
    Get.isSnackbarOpen
        ? exit(0)
        : excelFileController.scaffoldKey.currentState!.isDrawerOpen
            ? excelFileController.endDrawer(context)
            : Get.showSnackbar(
                GetSnackBar(
                  messageText: Row(
                    children: [
                      Text(
                        tr('close'),
                        style: TextStyle(color: Get.theme.primaryColor),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: const Text('ok').tr(),
                      )
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
  }

  Widget builder(BuildContext context) {
    void onSwapMove(details) {
      if (details.primaryVelocity! > 0 && Get.locale?.languageCode == 'ar') {
        if (excelFileController.searchQuestionsMode) {
          excelFileController.changeSearchQuestions();
        } else {
          Get.toNamed(AppRoute.addPage);
        }
      } else if (details.primaryVelocity! < 0 &&
          Get.locale?.languageCode == 'en') {
        if (excelFileController.searchQuestionsMode) {
          excelFileController.changeSearchQuestions();
        } else {
          Get.toNamed(AppRoute.addPage);
        }
      } else if (details.primaryVelocity! < 0 &&
              Get.locale?.languageCode == 'ar' ||
          details.primaryVelocity! > 0 && Get.locale?.languageCode == 'en') {
        excelFileController.displayDrawer(context);
      }
    }

    return ThemeSwitchingArea(
      child: GetBuilder<ExcelFileController>(
        builder: (controller) {
          return GetBuilder<ExamController>(
            builder: (examControllerBuild) {
              return WillPopScope(
                onWillPop: () async {
                  if (excelFileController.searchQuestionsMode) {
                    excelFileController.changeSearchQuestions();
                    return false;
                  } else {
                    await showCloseSnackBar(context);
                    return false;
                  }
                },
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    onSwapMove(details);
                  },
                  child: Scaffold(
                    key: excelFileController.scaffoldKey,
                    drawer: const DrawerWidget(),
                    body: GetBuilder<HomeController>(
                      builder: (homeController) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          transform: transform(homeController),
                          child: RefreshIndicator(
                            edgeOffset: Get.height / 8,
                            onRefresh: () async {
                              examControllerBuild.reset();
                            },
                            child: CustomScrollView(
                              slivers: [
                                appBar(context),
                                excelFileController.csvTable.isNotEmpty
                                    ? list(homeController)
                                    : noDataWidget(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
