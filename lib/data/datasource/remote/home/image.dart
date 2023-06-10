import 'dart:io';

import '../../../../../core/class/crud.dart';
import '../../../../../links.dart';

class UploadData {
  Crud crud;

  UploadData(this.crud);

  uploadImageData({
    required File file,
    required String teacherCode,
  }) async {
    var response = await crud.postDataWithImage(
        AppLinks.imageUploadLink, {'teacher_code': teacherCode}, file);
    return response.fold((l) => l, (r) => r);
  }
}
