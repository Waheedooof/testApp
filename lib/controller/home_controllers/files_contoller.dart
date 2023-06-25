import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import '../../core/class/statusrequest.dart';
import '../../core/function/checkinternet.dart';
import '../../core/services/services.dart';
import '../../data/datasource/remote/home/removeImages.dart';
import 'excel_file_cont.dart';

class FilesController extends GetxController {
  List<dynamic> files = [];

  List<int> deleteIndexFiles = [];
  StatusRequest? statusRequest = StatusRequest.none;
  MyServices myServices = Get.find();

  RemoveListImagesData listImagesData = RemoveListImagesData(Get.find());
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

  List<String> names = [];

  Future<List<String>> getFileImagesName(filePath) async {
    names.clear();
    var data = '';
    List<List<dynamic>> csvTable = [];

    File file = File(filePath);
    data = file.readAsStringSync();
    if (data.isEmpty) {
      data = 'No Questions has Added';
    } else {
      csvTable = const CsvToListConverter().convert(data);
      if (csvTable.toString().contains('https:')) {
        for (var element in csvTable) {
          String name = element
              .where((element) => element.toString().contains('https:'))
              .toList()
              .first;
          names.add(basename(name));
        }
      }
      print(names);
    }

    update();
    return [''];
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
      await getFileImagesName(files[index].path);
      if (await deleteImagesServer(names)) {
        await excelFileController.deleteFile(
          getPathFromFile(
            files[index],
          ),
        );

        getListFiles();
        excelFileController.reset();
        excelFileController.refreshList();
        Get.back();
      } else {}


    }
    // deleteIndexFiles.clear();
    // ExamController examController = Get.find();
    // examController.reset();
    // getListFiles();
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

  Future<bool> deleteImagesServer(List<String> basenames) async {
    if (names.isNotEmpty) {
      if (await checkInternet()) {
        statusRequest = StatusRequest.loading;
        update();

        try {
          var response = await listImagesData.removeListImagesData(
              listImagesNames: basenames);
          print('===========deleteImagesServer===${response}======');
          if (response.toString().contains('Image deleted successfully')) {
            statusRequest = StatusRequest.success;
            update();
            return true;
          } else {
            statusRequest = StatusRequest.failure;
          }
        } catch (e) {
          print('===========deleteImagesServer catch=========');
          statusRequest = StatusRequest.failure;
        }
      } else {
        statusRequest = StatusRequest.serverExp;
      }

      print(statusRequest);
      statusRequest = StatusRequest.success;
      update();
      return false;
    } else {
      return true;
    }
  }
}
