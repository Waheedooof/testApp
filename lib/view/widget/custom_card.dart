import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.widget}) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 24,
      decoration: BoxDecoration(
        color: context.theme.primaryColor.withOpacity(0.8),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Center(child: widget),
    );
  }
}
