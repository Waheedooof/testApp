import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar appCustomAppBar2({
  required List<Widget> actions,
  required Widget title,
}) {
  return AppBar(

    title: title,
    actions: actions,
    toolbarHeight: Get.height / 17,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Get.theme.primaryColor,
      ),
      onPressed: () {
        Get.back();
      },
    ),
  );
}

class AppCustomAppBar extends StatelessWidget {
  const AppCustomAppBar({
    Key? key,
    required this.title,
    required this.actions,
    required this.body,
  }) : super(key: key);
  final List<Widget> actions;
  final Widget title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appCustomAppBar2(actions: actions, title: title),
        body: body,
      ),
    );
  }
}
