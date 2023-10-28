import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/cinimo_config_model.dart';
import '../widgets/home_drawer.dart';

class BottomAppBarController extends GetxController {
  var pageController = PageController(initialPage: 0);
  CinimoConfig? cinimoconfig;

  var itemSected = 0.obs;
  chnageItemSelected(RxInt newITemSelected) {
    itemSected = newITemSelected;
    update();
  }

  chnagePageViewSelected(RxInt newITemSelected) {
    pageController.jumpToPage(newITemSelected.toInt());
    update();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    checkBannerAd();
  }

  checkBannerAd() {
    CinimoConfig config = configDataGetter();

    cinimoconfig = config;
    update();
  }
}
