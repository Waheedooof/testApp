import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'colors.dart';

class DarkThemeApp {
  snackBarThemeData() {
    return SnackBarThemeData(
      backgroundColor: AppColor.darkScaffold,
      contentTextStyle: TextStyle(
        color: AppColor.darkPrimary,
      ),
    );
  }

  appBarTheme() {
    return AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        color: AppColor.darkPrimary,
        fontSize: 18,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.darkScaffold,
        statusBarIconBrightness: Brightness.light,
      ),
      toolbarHeight: Get.height / 18,
      backgroundColor: AppColor.darkScaffold,
      foregroundColor: AppColor.darkPrimary,
      elevation: 0,
    );
  }
  floatingButton() {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColor.darkPrimary,
      foregroundColor: AppColor.darkScaffold,
    );
  }

  elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          AppColor.darkPrimary.withOpacity(0.7),
        ),
        foregroundColor: MaterialStatePropertyAll(AppColor.darkScaffold),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
