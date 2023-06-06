import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/auth_controller.dart';
import 'package:test_maker/controller/home_controllers/home_page_cont.dart';
import 'package:test_maker/controller/theme_controller.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import '../../controller/home_controllers/exam_cont.dart';
import '../../controller/home_controllers/excel_file_cont.dart';
import '../../controller/home_controllers/files_contoller.dart';
import '../../core/constant/approutes.dart';
import '../../core/theme/themes.dart';
import 'custom_card.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExcelFileController excelFileController = Get.find();
    FilesController filesController = Get.find();
    ExamController examController = Get.find();

    String getPathFromFile(fil) {
      return fil.toString().split('\'')[1];
    }

    String getFirstName(String last) {
      if (last.length >= 10) {
        return last.replaceRange(10, last.length, '...');
      } else {
        return last;
      }
    }

    actionButton({
      required Future<void> Function() click,
      required Text title,
      required Icon icon,
    }) {
      return InkWell(
        onTap: click,
        child: SizedBox(
          height: Get.height / 15,
          child: ListTile(
            title: title,
            leading: icon,
          ),
        ),
      );
    }

    actionButtons() {
      HomeController homeController = Get.find();
      return Expanded(
        flex: 5,
        child: SingleChildScrollView(
          controller: homeController.scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              actionButton(
                click: () async {
                  excelFileController.toAddScreen();
                },
                title: Text(tr('type_q'), style: context.textTheme.bodyText1)
                    .tr(),
                icon: Icon(CupertinoIcons.add_circled,
                    color: context.theme.highlightColor),
              ),
              actionButton(
                click: () async {
                  await excelFileController.onShareFile(
                    Directory(excelFileController.fileTitle),
                  );
                },
                title: Text('share', style: context.textTheme.bodyText1).tr(),
                icon: Icon(Icons.share, color: context.theme.highlightColor),
              ),
              actionButton(
                click: () async {
                  Get.back();
                  Get.toNamed(AppRoute.writeFilePage);
                },
                title: Text('write', style: context.textTheme.bodyText1).tr(),
                icon: Icon(Icons.edit, color: context.theme.highlightColor),
              ),
              Divider(
                color: context.theme.primaryColor,
                thickness: 0.15,
              ),
              actionButton(
                click: () async {
                  Navigator.pushNamed(context, AppRoute.favoritePage);
                },
                title:
                Text('favorite', style: context.textTheme.bodyText1).tr(),
                icon: Icon(CupertinoIcons.star,
                    color: context.theme.highlightColor),
              ),
              actionButton(
                click: () async {
                  if (context.locale == const Locale('ar', 'DZ')) {
                    context.locale = const Locale('en', 'US');
                  } else {
                    context.locale = const Locale('ar', 'DZ');
                  }
                  Get.updateLocale(context.locale);
                },
                title: Text('lang', style: context.textTheme.bodyText1).tr(),
                icon:
                Icon(Icons.language, color: context.theme.highlightColor),
              ),
              actionButton(
                click: () async {
                  await excelFileController.connectUs();
                },
                title: Text('connect_us', style: context.textTheme.bodyText1)
                    .tr(),
                icon: Icon(Icons.feedback_outlined,
                    color: context.theme.highlightColor),
              ),
              InkWell(
                onTap: () {
                  homeController.reverseList();
                },
                child: ListTile(
                  title: Text(
                    'changeList',
                    style: context.textTheme.bodyText1,
                  ).tr(),
                  leading: Icon(Icons.reorder,
                      color: context.theme.highlightColor),
                  trailing: Obx(
                        () => Switch(
                      value: homeController.isReverseList.value,
                      onChanged: (value) {
                        homeController.reverseList();
                      },
                    ),
                  ),
                ),
              ),
              actionButton(
                click: () async {
                  Navigator.pushNamed(context, AppRoute.history);
                },
                title:
                Text('history', style: context.textTheme.bodyText1).tr(),
                icon: Icon(
                  CupertinoIcons.square_list_fill,
                  color: context.theme.highlightColor,
                ),
              ),
              actionButton(
                click: () async {
                  Get.showSnackbar(
                    GetSnackBar(
                      duration: const Duration(seconds: 2),
                      title: tr('logout'),
                      messageText: ElevatedButton(
                        onPressed: () {
                          AuthController().logout();
                        },
                        child: const Text('ok').tr(),
                      ),
                    ),
                  );
                },
                title:
                Text('logout', style: context.textTheme.bodyText1).tr(),
                icon: Icon(
                  Icons.logout,
                  color: context.theme.highlightColor,
                ),
              ),
              GetBuilder<HomeController>(builder: (controller) {
                return actionButton(
                  click: () async {
                    homeController.setWalk();
                  },
                  title: Text(
                    '${tr('walk')}    ${homeController.isWalk ? (homeController.rotationZ * 1000).toStringAsFixed(2) : 'const'}',
                    style: context.textTheme.bodyText1,
                  ),
                  icon: Icon(
                    Icons.directions_walk,
                    color: homeController.isWalk
                        ? context.theme.primaryColor
                        : context.theme.highlightColor,
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }

    void deleteSnackBar(FilesController fileController, int index) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          duration: const Duration(seconds: 2),
          titleText: Text(
            'deleteFile?',
            style: TextStyle(
              color: context.theme.highlightColor,
            ),
          ).tr(),
          messageText: ElevatedButton(
            onPressed: () {
              excelFileController.deleteFile(
                getPathFromFile(
                  fileController.files[index],
                ),
              );
              examController.reset();
              fileController.getListFiles();
              Get.back();
            },
            child: const Text('ok').tr(),
          ),
        ),
      );
    }

    fileOptionsDialog() {
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: ThemeApp().getDialogTheme(),
          child: AlertDialog(
            titlePadding: const EdgeInsets.all(10),
            title: Text(
                tr(excelFileController.fileTitle.split('/').last.toString()),
                textAlign: TextAlign.center),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        excelFileController.pickFile('');
                        // await excelFileController.open2();
                        Get.back();
                      },
                      child: const Text('read').tr(),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(AppRoute.writeFilePage);
                      },
                      child: const Text('write').tr(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    showFilesWidget() {
      return Center(
        child: IconButton(
          onPressed: () {
            // excelFileController.toAddFileScreen();
            // fileOptionsDialog();
            filesController.changeShowList();
          },
          tooltip: tr('write'),
          icon: GetBuilder<FilesController>(builder: (filesCont) {
            return Icon(
              size: 38,
              color: context.theme.primaryColor,
              filesCont.showFilesList
                  ? Icons.keyboard_arrow_down_outlined
                  : Icons.keyboard_arrow_up_outlined,
            );
          }),
        ),
      );
    }

    filesList() {
      return GetBuilder<FilesController>(
        builder: (fileController) => AnimatedContainer(
          duration: const Duration(milliseconds: 333),
          height: fileController.showFilesList ? context.height / 3 : 0,
          child: fileController.files.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont_have',
                        style: TextStyle(
                            fontSize: 11, color: context.theme.highlightColor),
                      ).tr(),
                      // addFileWidget(),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: fileController.files.length,
                  itemBuilder: (context, i) {
                    int index = fileController.files.length - i - 1;
                    return InkWell(
                      onLongPress: () {
                        deleteSnackBar(fileController, index);
                      },
                      onTap: () {
                        excelFileController.pickFile(
                          getPathFromFile(fileController.files[index]),
                        );
                        examController.reset();
                        Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: getPathFromFile(fileController.files[index]) ==
                                  excelFileController.fileTitle
                              ? context.theme.primaryColor.withOpacity(0.8)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: Row(
                            children: [
                              Text(
                                (fileController.files.length - index)
                                    .toString(),
                                style: TextStyle(
                                  color: context.theme.highlightColor,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                getFirstName(getPathFromFile(
                                  fileController.files[index],
                                ).split('/').last),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: getPathFromFile(
                                              fileController.files[index]) ==
                                          excelFileController.fileTitle
                                      ? context.theme.scaffoldBackgroundColor
                                      : context.theme.highlightColor,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
    }

    titleWidget() {
      return Container(
        color: context.theme.primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Row(
            children: [
              Text(
                'recently',
                style: TextStyle(
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold,
                  color: context.theme.highlightColor,
                  fontSize: 21,
                ),
              ).tr(),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  excelFileController.toFilesScreen();

                  examController.reset();
                },
                child: const Text(
                  'openFilesList',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ).tr(),
              ),
              Expanded(child: Container()),
              showFilesWidget(),
            ],
          ),
        ),
      );
    }

    readFile() {
      return InkWell(
        onTap: () async {
          excelFileController.pickFile('');
          // await excelFileController.open2();
          Get.back();
        },
        child: CustomCard(
          widget: Text(
            'read',
            style: TextStyle(
              color: context.theme.scaffoldBackgroundColor,
            ),
          ).tr(),
        ),
      );
    }

    openFileWidget() {
      return InkWell(
        onTap: () {
          fileOptionsDialog();
        },
        child: CustomCard(
          widget: Text(
            getFirstName(excelFileController.fileTitle.split('/').last),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.theme.scaffoldBackgroundColor,
            ),
          ).tr(),
        ),
      );
    }

    // addQuestionWidget() {
    //   return Center(
    //     child: IconButton(
    //       onPressed: () {
    //         excelFileController.toAddScreen();
    //       },
    //       tooltip: tr('type_q'),
    //       icon: Hero(
    //         tag: 'add_hero',
    //         child: Icon(
    //           size: 48,
    //           color: context.theme.primaryColor,
    //           CupertinoIcons.add_circled,
    //         ),
    //       ),
    //     ),
    //   );
    // }
    themeIconChanger() {
      return GetBuilder<ThemeController>(
        builder: (themeController) => ThemeSwitcher(
          clipper: const ThemeSwitcherCircleClipper(),
          builder: (context) => IconButton(
            icon: AnimatedSwitcher(
              reverseDuration: const Duration(seconds: 1),
              duration: const Duration(seconds: 1),
              switchInCurve: Curves.easeOutSine,
              switchOutCurve: Curves.easeOutSine,
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1, end: 0.1).animate(anim)
                    : Tween<double>(begin: 0.1, end: 1).animate(anim),
                child: ScaleTransition(
                  scale: anim,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.theme.primaryColor,
                        width: 0.4,
                      ),
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: child,
                    ),
                  ),
                ),
              ),
              child: themeController.getThemeMode() == ThemeMode.dark
                  ? Icon(
                      key: const ValueKey('icon1'),
                      Icons.dark_mode,
                      color: context.theme.highlightColor,
                    )
                  : Icon(
                      key: const ValueKey('icon2'),
                      Icons.light_mode,
                      color: context.theme.highlightColor,
                    ),
            ),
            onPressed: () async {
              await themeController.changeTheme(context);
            },
          ),
        ),
      );
    }

    title() {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.height / 25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.theme.scaffoldBackgroundColor,
                context.theme.primaryColor.withOpacity(0.01),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // const Divider(height: 10, thickness: 1),
              GestureDetector(
                onTap: () {
                  excelFileController.endDrawer(context);
                },
                child: Text(
                  'Tester',
                  style: TextStyle(
                    fontFamily: 'Cairo-ExtraLight',
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              themeIconChanger(),
            ],
          ),
        ),
      );
    }

    return GetBuilder<ThemeController>(
      builder: (controller) => Drawer(
        shape: Border.all(color: context.theme.primaryColor, width: 0.1),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              const SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    flex: 8,
                    child: readFile(),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    flex: 8,
                    child: openFileWidget(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              actionButtons(),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.transparent,
              ),
              titleWidget(),
              filesList(),
            ],
          ),
        ),
      ),
    );
  }
}
