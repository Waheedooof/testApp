
import '../../../../../core/class/crud.dart';
import '../../../../../links.dart';

class RemoveData {
  Crud crud;

  RemoveData(this.crud);

  removeImageData({
    required String fileName,
  }) async {
    var response = await crud.postData(AppLinks.imageRemoveLink, {
      'fileName':fileName
    });
    return response.fold((l) => l, (r) => r);
  }
}
