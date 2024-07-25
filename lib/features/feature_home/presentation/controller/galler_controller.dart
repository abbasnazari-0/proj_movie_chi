import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';

class GalleryController extends GetxController {
  final HomeCatagoryItemModel itemGalleryData;
  int galleryIndex = 0;

  PageController pageController = PageController();

  GalleryController({required this.itemGalleryData});

  @override
  void onReady() {
    super.onReady();

    if (itemGalleryData.data?.isNotEmpty ?? false) {
      // change page view index every 5 seconds
      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (galleryIndex < 5) {
          galleryIndex++;
        } else {
          galleryIndex = 0;
        }

        if ((itemGalleryData.data!.length - 1) == galleryIndex) {
          // pageController.animateToPage(galleryIndex,
          //     duration: const Duration(milliseconds: 500),
          //     curve: Curves.easeIn);
          galleryIndex = 0;
        }
        // pageController.animateToPage(galleryIndex,
        //     duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      });
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    galleryIndex = index;
    update();
  }
}
