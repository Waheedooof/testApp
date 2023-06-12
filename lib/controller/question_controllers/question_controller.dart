import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';

import '../../core/class/statusrequest.dart';
import '../../core/function/checkinternet.dart';
import '../../core/function/handlingdata.dart';
import '../../core/services/services.dart';
import '../../data/datasource/remote/home/imageRemove.dart';
import '../../data/datasource/remote/home/imageUpload.dart';
import '../../links.dart';

class QuestionController extends GetxController {
  List questionRow = Get.arguments;

  List questionRowOld = Get.arguments;
  final UploadData uploadData = UploadData(Get.find());
  final RemoveData removeData = RemoveData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;

  @override
  void onInit() {
    print(questionRow);

    super.onInit();
  }

  editLabel(String string, int index) {
    questionRow[index] = string;
    print(questionRow);
  }

  getQuestionIndex() {
    ExcelFileController excelFileController = Get.find();
    int rowIndex = excelFileController.csvTable.indexOf(questionRow) + 1;
    return rowIndex.toString();
  }

  Future<bool> removerImageServer(urls) async {
    if (urls == '') {
      return true;
    } else {
      if (await checkInternet()) {
        statusRequest = StatusRequest.loading;
        update();
        var response = await removeData.removeImageData(
          fileName: basename(url),
        );
        print('===========removerImageSever==============');
        print(response);
        statusRequest = handlingData(response);
        if (statusRequest == StatusRequest.success) {
          return true;
        } else {
          statusRequest = StatusRequest.serverExp;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  bool isUploaded = true;
  MyServices myServices = Get.find();

  String getUrl(String response) {
    for (var element in response.split("\"")) {
      if (element.contains('https')) {
        return element;
      }
    }
    return '';
  }

  Future<String> uploadImage(File file) async {
    isUploaded = false;
    print(file.path);
    if (file.path.isNotEmpty) {
      if (await checkInternet()) {
        statusRequest = StatusRequest.loading;
        update();
        var response = await uploadData.uploadImageData(
          teacherCode:
              myServices.sharedPreferences.getString('teacherCode').toString(),
          file: file,
        );
        statusRequest = handlingData(response);
        if (statusRequest == StatusRequest.success) {
          if (response.toString().contains(AppLinks.serverLink)) {
            isUploaded = true;
            return await getUrl(response.toString());
          }
        } else {
          statusRequest = StatusRequest.serverExp;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    } else {
      isUploaded = true;
    }

    statusRequest = StatusRequest.success;
    update();
    return '';
  }

  editDataWithServer() async {
    statusRequest = StatusRequest.loading;
    update();
    if (await removerImageServer(url)) {
      isUploaded = true;
      if (questionRow.toString().contains('path:')) {
        questionRow.last = await uploadImage(
          File(
            questionRow
                .where((element) => element.toString().contains('path:'))
                .toList()
                .first
                .toString()
                .replaceAll('path:', ''),
          ),
        );
      }
      if (isUploaded) {
        await editQuestion();
      }
    }

    statusRequest = StatusRequest.success;
    update();
  }

  Future removeImageAtAll() async {
    url = questionRow
        .where((element) => element.toString().contains('https:'))
        .toList()
        .first;
    if (await removerImageServer(url)) {
      removePthHttpCell();
      editQuestion();
    }
    statusRequest = StatusRequest.success;
    update();

    Get.back();
  }

  editQuestion() async {
    ExcelFileController excelFileController = Get.find();
    int rowIndex = excelFileController.csvTable.indexOf(questionRowOld);
    for (var value in questionRow) {
      excelFileController.editQuestionDataFile(
        editRowIndex: rowIndex,
        editColumnIndex: questionRow.indexOf(value),
        value: value.toString(),
      );
    }
    await excelFileController.showEditAbleSnackBar();
  }

  bool isContainPath(element) {
    return element.toString().contains('path:');
  }

  bool isContainHttp(element) {
    return element.toString().contains('https:');
  }

  String url = '';

  Future<void> addImagePath() async {
    final picker = ImagePicker();
    var pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 5,
    );
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage!.path,
      // maxHeight: 512,
      // maxWidth: 1024,
      cropStyle: CropStyle.rectangle,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: tr('crop_image'),
          toolbarColor: Get.theme.primaryColor,
          toolbarWidgetColor: Get.theme.scaffoldBackgroundColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: tr('crop_image'),
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    pickedImage = XFile(croppedFile!.path);
    if (pickedImage != null) {
      print(questionRow);

      removePthHttpCell();
      questionRow.add('path:${pickedImage.path}');
      update();
      print(questionRow);
      print('url :$url');
    }
  }

  void removePthHttpCell() {
    if (questionRow.toString().contains('https:')) {
      url = questionRow
          .where((element) => element.toString().contains('https:'))
          .toList()
          .first;
      questionRow
          .removeWhere((element) => element.toString().contains('https:'));
    }
    if (questionRow.toString().contains('path:')) {
      questionRow
          .removeWhere((element) => element.toString().contains('path:'));
    }
  }
}
