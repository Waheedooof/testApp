import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/auth_controller.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:test_maker/core/class/handelingview.dart';
import 'package:test_maker/view/widget/apptextfield.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Get.theme.primaryColor,
            tooltip: tr('connect_us'),
            onPressed: () async {
              await ExcelFileController().connectUs();
              const CupertinoDialogAction(child: Text(''));
              Get.defaultDialog(
                title: tr('connect_us'),
                content: Column(
                  children: [
                    const Icon(Icons.phone_enabled),
                    const SizedBox(
                      height: 11,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('0992369841'),
                        SizedBox(
                          width: 11,
                        ),
                        Text('SYR'),
                      ],
                    ),
                  ],
                ),
              );
              // await excelFileController.connectUs();
            },
            icon: const Icon(CupertinoIcons.person),
          ),
        ],
        title: const Text('auth').tr(),
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        return Center(
            child: HandelingRequest(
          statusRequest: authController.statusRequest!,
          widget: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'hello',
                  style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.primaryColor),
                ).tr(),
                const SizedBox(
                  height: 33,
                ),
                AppTextField(
                  type: tr('password'),
                  iconData: Icons.password,
                  inputType: TextInputType.visiblePassword,
                  onChanged: (p0) {
                    authController.update();
                    return null;
                  },
                  validator: (p0) {
                    return null;
                  },
                  auto: false,
                  obscureText: authController.showText,
                  onTap: () {
                    authController.changeShowText();
                  },
                  textFieldController: authController.passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                authController.passwordTextController.text.isEmpty
                    ? IconButton(
                        onPressed: () async {
                          await authController.scan(context);
                        },
                        icon: Icon(
                          CupertinoIcons.barcode_viewfinder,
                          size: 100,
                          color: Get.theme.primaryColor,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          // await authController.login();
                          await authController.login();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: const Text('ok').tr(),
                        ),
                      )
              ],
            ),
          ),
        ));
      }),
    );
  }
}
