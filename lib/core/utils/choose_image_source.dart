import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class ImageSourceChooser {
  static Future<String?> chooseImageSource() {
    return Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              onTap: () async {
                Get.back(result: 'camera');
              },
              title: MyText(
                txt: 'دوربین'.tr,
                color: Colors.black54,
              ),
              leading: const Icon(
                Icons.camera_alt,
                color: Colors.black54,
              ),
            ),
            ListTile(
              onTap: () async {
                Get.back(result: 'gallery');
              },
              title: MyText(
                txt: 'گالری'.tr,
                color: Colors.black54,
              ),
              leading: const Icon(
                Icons.image,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
