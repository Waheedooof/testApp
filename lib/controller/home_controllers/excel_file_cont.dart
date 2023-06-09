import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async' show Future;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:test_maker/controller/home_controllers/exam_cont.dart';
import 'package:test_maker/controller/home_controllers/files_contoller.dart';
import 'package:test_maker/core/constant/file.dart';
import 'package:test_maker/core/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constant/approutes.dart';

class ExcelFileController extends GetxController {
  List<List<dynamic>> csvTable = [];
  String fileTitle = tr("choose");
  String data = '';
  final MyServices _myServices = Get.find();
  int correctAnswer = 0;
  List<String> questionAddRow = ['', '', '', '', '', '', ''];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool searchQuestionsMode = false;
  TextEditingController searchQuestionController = TextEditingController();
  TextEditingController textQuesController = TextEditingController();
  bool readMode = false;
  MyServices myServices = Get.find();

  changeReadMode() {
    readMode = !readMode;
  }

  displayDrawer(BuildContext context) {
    FilesController filesController = Get.find();
    if (filesController.showFilesList) {
      filesController.changeShowList();
    }
    scaffoldKey.currentState!.openDrawer();
  }

  endDrawer(BuildContext context) {
    scaffoldKey.currentState!.closeDrawer();
  }

  @override
  void onInit() {
    if (_myServices.sharedPreferences.containsKey('tablePath')) {
      getFileData(getSavedPath());
    }
    super.onInit();
  }

  Future createFile(fileName) async {
    String csvData = const ListToCsvConverter().convert([]);
    String directory = (await getExternalStorageDirectory())!.path;
    final path = "$directory/$fileName-${DateTime.now().year}.csv";
    File file = File(path);

    await file.writeAsString(csvData);
    Get.back();
    pickFile(path);
    FilesController filesController = Get.find();
    filesController.getListFiles();
  }

  Future writeToFile({required List<List<dynamic>> newData}) async {
    String filePath = '';
    if (getSavedPath() == '') {
      Get.toNamed(AppRoute.writeFilePage);
    } else {
      filePath = getSavedPath();
    }

    for (List rowList in csvTable) {
      newData.add(rowList);
    }
    String csvData = const ListToCsvConverter().convert(newData);

    final File file = File(filePath);
    file.writeAsStringSync(
      csvData,
      mode: FileMode.write,
    );
    getFileData(filePath);
  }

  getFileData(filePath) async {
    try {
      data = '';
      fileTitle = filePath;
      update();
      print('===0000000==000000000000==========');
      File file = File(filePath);
      data = file.readAsStringSync();
      csvTable = const CsvToListConverter().convert(data);
    } catch (e) {
      csvTable = [];
      data = 'File Not Found';
    }
    if (data.isEmpty) {
      data = 'No Questions has Added';
    }
    update();
  }

  refreshList() async {
    await getFileData(getSavedPath());
  }

  onShareFile(Directory directory) async {
    print(directory.path);
    await Share.shareFiles(
      subject: 'TestApp',
      [directory.path],
      text: '${tr('share_label')}\n$fileUrl',
    );
  }

  onShareFiles() async {
    FilesController fileController = Get.find();
    List<String> paths = [];
    for (int fileIndex in fileController.deleteIndexFiles) {
      paths.add(
        fileController.getPathFromFile(fileController.files[fileIndex]),
      );
      print(paths.last);
    }

    await Share.shareFiles(
      subject: 'TestApp',
      text: '${tr('share_label')}\n$fileUrl',
      paths,
    );
  }

  Future<int> deleteFile(String path) async {
    try {
      final file = File(path);
      await file.delete();

      return 1;
    } catch (e) {
      return 0;
    }
  }

  void pickFile(String path) async {
    if (path == '') {
      //every run will assigned
      FilePickerResult? result = (await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['csv'],
        // initialDirectory: '/data/user/0//',
      ))!;
    await  _myServices.sharedPreferences
          .setString('tablePath', result.files.first.path!);
     await getFileData(result.files.first.path!);
      print('=========directory================');
      print(result.files.first.path!);
      result = null;
    } else {
      _myServices.sharedPreferences.setString('tablePath', path);
      getFileData(path);
    }
    ExcelFileController().update();
  }

  String getSavedPath() {
    String path = _myServices.sharedPreferences.getString('tablePath') ?? '';
    return path;
  }

  Future deleteFromFile({
    required int deletedRowIndex,
  }) async {
    String filePath = '';
    filePath = getSavedPath();
    csvTable.remove(csvTable[deletedRowIndex]);
    String csvData = const ListToCsvConverter().convert(csvTable);
    final path = filePath;
    final File file = File(path);
    file.writeAsStringSync(
      csvData,
      mode: FileMode.write,
    );
    getFileData(filePath);
    print('${filePath}edit');
  }

  Future editLikeDataFile({
    required int editRowIndex,
  }) async {
    String filePath = getSavedPath();
    print(csvTable[editRowIndex]);

    if (!csvTable[editRowIndex].contains('like')) {
      csvTable[editRowIndex].add('like');
    } else {
      csvTable[editRowIndex].remove('like');
    }

    print('===========');
    print(csvTable[editRowIndex]);
    String csvData = const ListToCsvConverter().convert(csvTable);
    final path = filePath;
    final File file = File(path);
    file.writeAsStringSync(
      csvData,
      mode: FileMode.write,
    );
    getFileData(filePath);
    print('${filePath}edit');
  }

  Future editQuestionDataFile({
    required int editRowIndex,
    required int editColumnIndex,
    required String value,
    // required List<dynamic> newData,
  }) async {
    String filePath = getSavedPath();
    csvTable[editRowIndex][editColumnIndex] = value;
    String csvData = const ListToCsvConverter().convert(csvTable);
    final path = filePath;
    final File file = File(path);
    file.writeAsStringSync(
      csvData,
      mode: FileMode.write,
    );
    await getFileData(filePath);
    print('${filePath}edit');
  }

  void toAddScreen() {
    Get.toNamed(AppRoute.addQuesPage);
  }

  void toAddFileScreen() {
    Get.toNamed(AppRoute.writeFilePage);
  }

  void writeQuesData() async {
    if (_myServices.sharedPreferences.containsKey('tablePath')) {
      if (questionAddRow.first.isEmpty ||
          questionAddRow[2].isEmpty ||
          questionAddRow[1].isEmpty ||
          questionAddRow[6].isEmpty) {
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              tr('empty'),
              style: TextStyle(
                color: Get.theme.scaffoldBackgroundColor,
              ),
            ),
            backgroundColor: Get.theme.primaryColor,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        await writeToFile(newData: [questionAddRow]);
        questionAddRow = ['', '', '', '', '', '', ''];
        ExamController examController = Get.find();
        examController.reset();
        questionAddRow = ['', '', '', '', '', '', ''];
        correctAnswer = 0;
        textQuesController.text = '';
        update();
        Get.back();
        await showEditAbleSnackBar();

        await Get.toNamed(AppRoute.addQuesPage);
      }
    } else {
      Get.toNamed(AppRoute.writeFilePage)?.whenComplete(() {
        Get.toNamed(AppRoute.addQuesPage);
      });
    }
  }

  void setCorrect(int value) {
    if (correctAnswer.toString().contains(value.toString())) {
      correctAnswer.toString().split('').forEach((char) {
        if (char == value.toString()) {
          if (correctAnswer.toString().split('').length > 1) {
            correctAnswer = int.parse(
                correctAnswer.toString().replaceAll(char, '').toString());
          } else {
            correctAnswer = 0;
          }
        }
      });
    } else {
      correctAnswer = int.parse(correctAnswer.toString() + value.toString());
    }
    questionAddRow[6] = correctAnswer.toString();

    update();
    print(questionAddRow[6]);
    print(correctAnswer);
  }

  void setCorrectOneAnswer(int value) {
    correctAnswer = value;
    questionAddRow[6] = correctAnswer.toString();
    update();
  }

  showEditAbleSnackBar() {
    ExcelFileController excelFileController = Get.find();
    return Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 4),
        messageText: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              excelFileController.isFileEditAble() ? 'EditAble' : 'NotEditAble',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: excelFileController.isFileEditAble()
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ).tr(),
          ),
        ),
      ),
    );
  }

  isFileEditAble() {
    FilesController filesController = Get.find();
    try {
      for (File file in filesController.files) {
        if (file.path == fileTitle) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  void toFilesScreen() {
    FilesController filesController = Get.find();
    filesController.searchMode = false;
    filesController.searchController.clear();
    filesController.update();
    Get.toNamed(AppRoute.filesPage);
  }

  void changeSearchQuestions() {
    if (searchQuestionController.text.isNotEmpty) {
      searchQuestionController.clear();
    } else {
      searchQuestionsMode = !searchQuestionsMode;
    }
  }

  void setRowValue(int index, String value) {
    questionAddRow[index] = (value);
    print(questionAddRow);
    print(index);
    update();
  }

  connectUs() async {
    String url = 'https://t.me/$username';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: textQuesController.text));
  }

  void textQuesCut() {
    // copyToClipboard();
    textQuesController.text = '';
    setRowValue(0, textQuesController.text);
    update();
  }

  void textQuesPaste() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      textQuesController.text = data.text ?? '';
    }
    setRowValue(0, textQuesController.text);
    update();
  }
}
