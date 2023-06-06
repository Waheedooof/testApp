import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/auth_controller.dart';
import 'package:test_maker/core/class/handelingview.dart';
import 'package:test_maker/view/widget/apptextfield.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('auth').tr(),
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              type: tr('password'),
              iconData: Icons.password,
              inputType: TextInputType.visiblePassword,
              onChanged: (p0) {},
              validator: (p0) {
                return null;
              },
              auto: true,
              obscureText: authController.showText,
              onTap: () {
                authController.changeShowText();
              },
              textFieldController: authController.password,
            ),
            const SizedBox(
              height: 20,
            ),
            HandelingRequest(
              statusRequest: authController.statusRequest!,
              widget: ElevatedButton(
                onPressed: () async {
                  await authController.auth();
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text('ok').tr(),
                ),
              ),
            ),
          ],
        ));
      }),
    );
  }
}
