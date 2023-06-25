import '../../../../../core/class/crud.dart';
import '../../../../../links.dart';

class RemoveListImagesData {
  Crud crud;

  RemoveListImagesData(this.crud);

  removeListImagesData({
    required List<String> listImagesNames,
  }) async {
    var response =
        await crud.sendImageList(AppLinks.removeImagesList, listImagesNames);
    return response.fold((l) => l, (r) => r);
  }
}
