import '../../../../../core/class/crud.dart';
import '../../../../../links.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  loginTeacher({
    required String teacherCode,
  }) async {
    var response = await crud.postData(
      AppLinks.loginLink,
      {
        'teacher_code': teacherCode,
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}
