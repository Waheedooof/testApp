import 'package:get/get.dart';
import 'package:test_maker/view/screen/addQues_page.dart';
import 'package:test_maker/view/screen/authPage.dart';
import 'package:test_maker/view/screen/chooseLangPage.dart';
import 'package:test_maker/view/screen/favorite_page.dart';
import 'package:test_maker/view/screen/filesPage.dart';
import 'package:test_maker/view/screen/history_page.dart';
import 'package:test_maker/view/screen/home.dart';
import 'package:test_maker/view/screen/addFile_page.dart';
import 'package:test_maker/view/screen/editQues_page.dart';

import 'core/constant/approutes.dart';
import 'core/middelware.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: AppRoute.homePage,
      page: () => HomePage(),
      middlewares: [MiddleWare()]),
  GetPage(
    name: AppRoute.writeFilePage,
    page: () => const WriteFilePage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: AppRoute.chooseLang,
    page: () => const ChooseLangPage(),
  ),
  GetPage(
    name: AppRoute.authPage,
    page: () => const AuthPage(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: AppRoute.favoritePage,
    page: () => FavoritePage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: AppRoute.questionData,
    arguments: List<dynamic>,
    page: () => QuestionDataPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: AppRoute.history,
    page: () => const HistoryPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: AppRoute.addQuesPage,
    page: () =>  AddPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: AppRoute.filesPage,
    page: () => FilesPage(),
    transition: Transition.rightToLeft,
  ),
];
