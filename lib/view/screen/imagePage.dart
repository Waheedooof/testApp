import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:test_maker/view/widget/appbar.dart';

class ImageViewer extends StatelessWidget {
  final String imagePath;

  const ImageViewer({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onHorizontalDragEnd: (DragEndDetails details) {
      //   if (details.primaryVelocity! > 100) {
      //     Get.back();
      //   }
      // },
      child: AppCustomAppBar(
        title: const Text('image_view').tr(),
        actions: [],
        body: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          imageProvider: CachedNetworkImageProvider(imagePath),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2.0,
        ),
      ),
    );
  }
}
