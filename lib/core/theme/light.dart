import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'colors.dart';

class LightThemeApp {
  snackBarThemeData() {
    return SnackBarThemeData(
      backgroundColor: AppColor.lightScaffold,
      contentTextStyle: TextStyle(
        color: AppColor.lightPrimary,
      ),
    );
  }

  floatingButton() {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColor.lightPrimary,
      foregroundColor: AppColor.lightScaffold,
    );
  }

  appBarTheme() {
    return AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        color: AppColor.lightPrimary,
        fontSize: 18,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.lightScaffold,
        statusBarIconBrightness: Brightness.dark,
      ),
      toolbarHeight: Get.height / 18,
      backgroundColor: AppColor.lightScaffold,
      foregroundColor: AppColor.lightPrimary,
      elevation: 0,
    );
  }

  elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          AppColor.lightPrimary.withOpacity(0.7),
        ),
        foregroundColor: MaterialStatePropertyAll(AppColor.lightScaffold),
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
