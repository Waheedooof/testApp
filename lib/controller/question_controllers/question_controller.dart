import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';

class QuestionController extends GetxController {
  List questionRow = Get.arguments;

  @override
  void onInit() {
    print(questionRow);


    super.onInit();
  }

  editLabel(String string, int index) {
    questionRow[index] = string;
    print(questionRow);
  }

  getQuestionIndex(){
    ExcelFileController excelFileController = Get.find();
    int rowIndex = excelFileController.csvTable.indexOf(questionRow)+1;
    return rowIndex.toString();
  }
  editQuestion() async {
    ExcelFileController excelFileController = Get.find();
    int rowIndex = excelFileController.csvTable.indexOf(questionRow);
    for (var value in questionRow) {
      excelFileController.editQuestionDataFile(
        editRowIndex: rowIndex,
        editColumnIndex: questionRow.indexOf(value),
        value: value.toString(),
      );
    }
    Get.back();
    await excelFileController.showEditAbleSnackBar();
  }



}
