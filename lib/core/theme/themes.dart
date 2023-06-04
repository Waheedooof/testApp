import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/theme_controller.dart';
import 'colors.dart';
import 'dark.dart';
import 'light.dart';

class ThemeApp {
  getLightTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColor.lightPrimary,
      scaffoldBackgroundColor: AppColor.lightScaffold,
      highlightColor: AppColor.lightText,
      useMaterial3: true,
      fontFamily: 'Cairo',
      drawerTheme: const DrawerThemeData(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: AppColor.lightText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      snackBarTheme: LightThemeApp().snackBarThemeData(),
      elevatedButtonTheme: LightThemeApp().elevatedButtonThemeData(),
      appBarTheme: LightThemeApp().appBarTheme(),
      floatingActionButtonTheme: LightThemeApp().floatingButton(),
    );
  }

  getDarkTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColor.darkPrimary,
      scaffoldBackgroundColor: AppColor.darkScaffold,
      highlightColor: AppColor.darkText,
      useMaterial3: true,
      fontFamily: 'Cairo',
      drawerTheme: const DrawerThemeData(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: AppColor.darkText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      snackBarTheme: DarkThemeApp().snackBarThemeData(),
      elevatedButtonTheme: DarkThemeApp().elevatedButtonThemeData(),
      appBarTheme: DarkThemeApp().appBarTheme(),
      floatingActionButtonTheme: DarkThemeApp().floatingButton(),
    );
  }

  getDialogTheme() {
    ThemeController themeController = Get.find();
    return ThemeData(
      brightness: themeController.getThemeMode() == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
      primaryColor: AppColor.lightPrimary,
      scaffoldBackgroundColor: AppColor.lightScaffold,
      highlightColor: AppColor.lightText,
      useMaterial3: true,
      fontFamily: 'Cairo',
      drawerTheme: const DrawerThemeData(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: AppColor.lightText, fontSize: 14),
      ),
      snackBarTheme: LightThemeApp().snackBarThemeData(),
      elevatedButtonTheme: LightThemeApp().elevatedButtonThemeData(),
      appBarTheme: LightThemeApp().appBarTheme(),
    );
  }
}
