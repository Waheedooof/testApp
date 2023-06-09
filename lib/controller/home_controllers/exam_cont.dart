import 'dart:async';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:test_maker/controller/home_controllers/files_contoller.dart';

class ExamController extends GetxController {
  int trueSum = 0;
  int falseSum = 0;
  RxBool isNotExamMode = false.obs;
  List<Map<int, bool>> answers = [];
  bool answerIsTrue = false;

  late Timer timer;
  RxDouble minutes = 0.0.obs;
  RxBool isClick = false.obs;

  Map<int, int> choose1 = {-1: -1};
  Map<int, int> historyListAnswers = {};

  add(questionColumnIndex) {
    if (choose1.keys.first == questionColumnIndex) {
      for (Map map in answers) {
        if (map.keys.first == questionColumnIndex) return;
      }
      if (answerIsTrue) {
        trueSum++;
      } else {
        falseSum++;
      }
      answers.add({questionColumnIndex: answerIsTrue});
      historyListAnswers.addAll({questionColumnIndex: choose1.values.first});
      print('historyListAnswers');
      print(historyListAnswers);

      update();
    }
  }

  bool isSelectedHistory(int questionColumnIndex, int columnIndexRow) {
    bool value = false;
    if (historyListAnswers.isNotEmpty) {
      if (historyListAnswers.containsKey(questionColumnIndex)) {
        historyListAnswers[questionColumnIndex]
            .toString()
            .split('')
            .forEach((bit) {
          if (bit == columnIndexRow.toString()) {
            value = true;
          }
        });
      }
    }
    return value;
  }

  startExam() {
    if (minutes.value == 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        isClick.value = !isClick.value;
        minutes.value++;
      });
    } else {
      minutes.value = 0;
      timer.cancel();
    }
  }

  stopExam() {
    if (timer.isActive) {
      timer.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        isClick.value = !isClick.value;
        minutes.value++;
      });
    }
  }

  setCheat() {
    isNotExamMode.value = true;
  }

  bool? isCorrect(int index) {
    for (Map map in answers) {
      if (map.keys.first == index) {
        if (map.values.first) {
          return true;
        } else {
          return false;
        }
      }
    }
    return null;
  }

  bool isChoose(int indexInColumn, int indexInRow) {
    if (choose1.keys.first.isEqual(indexInColumn)) {
      if (choose1.values.first.toString().contains(indexInRow.toString())) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    answers = [];
    historyListAnswers = {};
    choose1 = {-1: -1};
    trueSum = 0;
    falseSum = 0;
    update();
    FilesController filesController = Get.find();
    ExcelFileController excelFileController = Get.find();
    filesController.getListFiles();
    excelFileController.refreshList();
  }

  void chooseAnswerIndex(int questionColumnIndex, int indexInRow) {
    if (choose1.containsKey(questionColumnIndex)) {
      if (choose1[questionColumnIndex]
          .toString()
          .contains(indexInRow.toString())) {
        int value = int.parse(
          choose1.values.first.toString().split('').length > 1
              ? choose1.values.first
                  .toString()
                  .replaceAll(indexInRow.toString(), '')
              : '0',
        );
        choose1.assign(questionColumnIndex, value);
      } else {
        choose1.assign(
          questionColumnIndex,
          int.parse(
            choose1.values.first.toString() + indexInRow.toString(),
          ),
        );
      }
    } else {
      choose1 = {};
      choose1.assign(questionColumnIndex, indexInRow);
    }

    answerIsTrue = isChoosesTure(questionColumnIndex);

    print(answerIsTrue);

    update();
  }

  bool isChoosesTure(questionColumnIndex) {
    bool value = false;
    ExcelFileController excelController = Get.find();
    if (excelController.csvTable[questionColumnIndex][6].toString().length ==
        choose1.values.first.toString().split('').length) {
      value = true;
      choose1.values.first.toString().split('').forEach(
        (char) {
          if (value) {
            if (excelController.csvTable[questionColumnIndex][6]
                .toString()
                .contains(char)) {
              value = true;
            } else {
              value = false;
            }
          }
        },
      );
    } else {
      value = false;
    }
    return value;
  }


}
