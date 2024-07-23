import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GalleryController extends GetxController {
  int galleryIndex = 0;

  PageController pageController = PageController();

  @override
  void onReady() {
    super.onReady();

    // change page view index every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (galleryIndex < 5) {
        galleryIndex++;
      } else {
        galleryIndex = 0;
      }
      // pageController.animateToPage(galleryIndex,
      //     duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    });
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
