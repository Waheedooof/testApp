import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/theme_controller.dart';
import 'package:test_maker/initialbinding.dart';
import 'package:test_maker/routes.dart';
import 'controller/app_controller.dart';
import 'core/services/services.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  Get.put(LifeCycleController());
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'DZ'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
      // child: DevicePreview(
      //   builder: (context) => MyApp(),
      //   enabled: true,
      // ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());

    return GetBuilder<ThemeController>(
      builder: (controller) => ThemeProvider(
        duration: const Duration(milliseconds: 500),
        initTheme: themeController.getThemeData(),
        builder: (p0, myTheme) => GetMaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'TestApplication',
          initialBinding: InitialBinding(),
          getPages: routes,
          themeMode: themeController.getThemeMode(),
          darkTheme: myTheme,
          theme: myTheme,
        ),
      ),
    );
  }
}
