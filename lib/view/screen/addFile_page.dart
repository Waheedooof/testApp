import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';

import '../widget/appbar.dart';

class WriteFilePage extends StatelessWidget {
  const WriteFilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExcelFileController excelFileController = Get.find();
    String name = 'test';

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 100) {
          Get.back();
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await excelFileController.createFile(name);
            // Get.back();
          },
          child: const Icon(Icons.done),
        ),
        body: AppCustomAppBar(
          title: const Text('type').tr(),
          actions: [],
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              child: TextFormField(
                initialValue: 'default_Name',
                style: Get.textTheme.bodyText1,
                selectionControls: CupertinoTextSelectionControls(),
                autofocus: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
