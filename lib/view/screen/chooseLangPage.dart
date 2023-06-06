import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/core/constant/approutes.dart';

import '../../core/services/services.dart';

class ChooseLangPage extends StatelessWidget {
  const ChooseLangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('choose_lang').tr()),
      body: Center(
        child: Container(
          color: context.theme.primaryColor.withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/choose.png',
              ),
              const SizedBox(
                height: 33,
              ),
              const Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                ' اختر اللغة  ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                height: context.height / 5,
              ),
              Container(
                width: context.width / 1.2,
                decoration: BoxDecoration(
                    color: context.theme.primaryColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(22))),
                child: InkWell(
                  onTap: () {
                    context.locale = const Locale('en', 'US');
                    Get.updateLocale(context.locale);
                    myServices.sharedPreferences.setString('lang', 'lang');
                    Get.offNamed(AppRoute.homePage);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/en.png',
                      ),
                      SizedBox(
                        width: context.width / 8,
                      ),
                      Text(
                        'English',
                        style: TextStyle(
                          color: context.theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: context.theme.primaryColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(22))),
                width: context.width / 1.2,
                child: InkWell(
                  onTap: () {
                    context.locale = const Locale('ar', 'DZ');
                    Get.updateLocale(context.locale);
                    myServices.sharedPreferences.setString('lang', 'lang');
                    Get.offNamed(AppRoute.homePage);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ar.png',
                      ),
                      SizedBox(
                        width: context.width / 8,
                      ),
                      Text(
                        'عربي',
                        style: TextStyle(
                          color: context.theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
