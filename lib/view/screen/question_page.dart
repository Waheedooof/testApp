import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_maker/controller/home_controllers/excel_file_cont.dart';
import 'package:test_maker/controller/question_controllers/question_controller.dart';

import '../widget/appbar.dart';

class QuestionDataPage extends StatelessWidget {
  QuestionDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          Get.back();
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            questionController.editQuestion();
          },
          child: const Icon(Icons.done),
        ),
        body: AppCustomAppBar(
            title: const Text('edit').tr(),
            actions: [],
            body: GetBuilder<QuestionController>(
              builder: (questionController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          questionController.questionRow.length + 1,
                          (index) {
                            if (index == 7) {
                              return Container(
                                color: Get.theme.scaffoldBackgroundColor,
                                height: Get.height / 10,
                              );
                            } else if (index > 5) {
                              return Container();
                            } else {
                              return Column(
                                children: [
                                  index == 0
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Card(
                                            color: Get.theme.primaryColor,
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  '${tr('question')} ${questionController.getQuestionIndex()}',
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    color: Get.theme
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Get.width / 4,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            index == 0
                                                ? tr('question')
                                                : index == 5
                                                    ? tr('info')
                                                    : index == 6
                                                        ? tr('index_answer')
                                                        : ('${tr('answer')} $index'),
                                            textAlign: TextAlign.center,
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(fontSize: 11),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: CupertinoTextField(
                                          enableInteractiveSelection: true,
                                          enabled: true,
                                          maxLines: index == 0 ? 3 : 1,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Get.theme.primaryColor,
                                            ),
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          style: Get.textTheme.bodyText1!
                                              .copyWith(fontSize: 11),
                                          textAlign: TextAlign.center,
                                          padding: const EdgeInsets.all(10),
                                          controller: TextEditingController(
                                            text: questionController
                                                .questionRow[index]
                                                .toString(),
                                          ),
                                          onChanged: (value) {
                                            print('$index $value');
                                            questionController.editLabel(
                                              value,
                                              index,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                      color: Colors.white, height: 10),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),),
      ),
    );
  }
}
