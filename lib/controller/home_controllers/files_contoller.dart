import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'exam_cont.dart';
import 'excel_file_cont.dart';

class FilesController extends GetxController {
  List<dynamic> files = [];

  List<int> deleteIndexFiles = [];

  TextEditingController searchController = TextEditingController();

  bool showFilesList = false;
  bool searchMode = false;

  @override
  void onInit() {
    getListFiles();

    super.onInit();
  }

  changeShowList() {
    showFilesList = !showFilesList;
    update();
  }

  // Make New Function
  void getListFiles() async {
    final directory = await getExternalStorageDirectory();

    print('============listOfFiles==============');
    print(directory!.path);
    files = io.Directory(directory.path).listSync();
    print(files.length);

    update();
  }

  String getPathFromFile(fil) {
    return fil.toString().split('\'')[1];
  }

  Future deleteFiles() async {
    ExcelFileController excelFileController = Get.find();

    for (int index in deleteIndexFiles) {
      await excelFileController.deleteFile(
        getPathFromFile(files[index]),
      );
    }
    deleteIndexFiles.clear();
    ExamController examController = Get.find();
    examController.reset();
    getListFiles();
    update();
  }

  selectedFiles(index) {
    if (deleteIndexFiles.contains(index)) {
      deleteIndexFiles.remove(index);
    } else {
      deleteIndexFiles.add(index);
    }
    // print(files[index]);
    for (int element in deleteIndexFiles) {
      print('============================');
      print(element);
      print(files.indexOf(files[element]));
    }

    update();
  }

  selectedFilesAll() {
    if (deleteIndexFiles.length != files.length) {
      for (var element in files) {
        if (!deleteIndexFiles.contains(files.indexOf(element))) {
          deleteIndexFiles.add(files.indexOf(element));
        }
      }
    } else {
      deleteIndexFiles.clear();
    }
    update();
  }

  void changeSearchMode() {
    searchMode = !searchMode;
    update();
  }

  void closeSearch() {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
    } else {
      searchMode = false;
    }
    update();
  }
}
