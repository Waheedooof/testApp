import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/core/services/services.dart';

import '../core/theme/themes.dart';

class ThemeController extends GetxController {
  MyServices myServices = Get.find();

  @override
  void onInit() {
    if (myServices.sharedPreferences.get('theme') == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
    update();
    super.onInit();
  }

  ThemeMode getThemeMode() {
    if (myServices.sharedPreferences.get('theme') == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  ThemeData getThemeData() {
    if (myServices.sharedPreferences.get('theme') == 'dark') {
      return ThemeApp().getDarkTheme();
    } else {
      return ThemeApp().getLightTheme();
    }
  }

  changeTheme(context) async {
    if (myServices.sharedPreferences.get('theme') == 'dark') {
      await myServices.sharedPreferences.setString('theme', 'light');
      // Get.changeTheme(ThemeData.light());
      ThemeSwitcher.of(context).changeTheme(
        theme: ThemeApp().getLightTheme(),
        isReversed: true,
      );
      // Get.changeThemeMode(ThemeMode.light);
    } else {
      await myServices.sharedPreferences.setString('theme', 'dark');
      ThemeSwitcher.of(context).changeTheme(
        theme: ThemeApp().getDarkTheme(),
        isReversed: false,
      );
      // Get.changeThemeMode(ThemeMode.dark);
    }
    update();
  }
}
