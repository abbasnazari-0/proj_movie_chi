import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/tv_controller/slider_controller.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_profile/presentations/pages/feature_profile.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/search_page_controller.dart';
import 'package:movie_chi/features/feature_search/presentation/pages/search_tv_page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AndroidTvSearchController extends GetxController {
  List<String> englishKeys = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];

  // حروف زبان فارسی
  List<String> persianKeys = [
    'ا',
    'ب',
    'پ',
    'ت',
    'ث',
    'ج',
    'چ',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'ژ',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ک',
    'گ',
    'ل',
    'م',
    'ن',
    'و',
    'ه',
    'ی',
    '۱',
    '۲',
    '۳',
    '۴',
    '۵',
    '۶',
    '۷',
    '۸',
    '۹',
    '۰'
  ];

  double itemIndex = 0.0;
  double prevIndex = 0.0;
  bool showKeyboard = false;
  bool isEnglish = true;

  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 1000));
  startSearch() {
    debouncer.call(() {
      SearchPageController pageController = Get.find<SearchPageController>();
      pageController.controller.text = searchController.text;
      pageController.onstartLoadSearch(true);
    });
  }

  Widget indexingWidget(Widget widget, double index) {
    return GetBuilder<AndroidTvSearchController>(
      builder: (controller) {
        return Material(
          color: Colors.transparent,
          child: Container(
            padding: index == controller.itemIndex
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                : null,
            // width:  widget.toString().length * 10,
            decoration: BoxDecoration(
              // color: index == controller.itemIndex ? Colors.red : null,
              border: index == controller.itemIndex
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Center(child: widget),
          ),
        );
      },
    );
  }

  TextEditingController searchController = TextEditingController();

  onClicked() async {
    // searchController.text = "ssasas";
    if (itemIndex > 10.03) {
      if (isEnglish) {
        int index = ((itemIndex - 0.04) * 100).toInt() - 1000;
        if (index >= 0 && index < englishKeys.length) {
          searchController.text =
              "${searchController.text}${englishKeys[index]}";
          startSearch();
        }
      } else {
        int index = ((itemIndex - 0.04) * 100).toInt() - 1000;
        if (index >= 0 && index < persianKeys.length) {
          searchController.text =
              "${searchController.text}${persianKeys[index]}";
          startSearch();
        }
      }
    } else if (itemIndex < 10.00 && itemIndex >= 0.02) {
      int index = ((itemIndex - 0.02) * 100).toInt();

      final pageController = Get.find<SearchPageController>();

      SearchVideo searchVideo = pageController.searchData.data![index];

      Get.back();
      Get.find<AndroidTVSliderController>()
          .changeVideoBySearchVideo(searchVideo, withStop: true);
    } else {
      // debugPrint("index::::" + itemIndex.toString());
      switch (itemIndex.toString()) {
        case "0.0":
          Get.back();
          break;
        case "0.01":
          showKeyboard = true;
          itemIndex = 10.00;
          update();
          break;
        case "0.05":
          if ((GetStorageData.getData("user_logined") ?? false) == false) {
            await Get.toNamed(LoginScreen.routeName);
          } else {
            Get.to(() => const ProfileScreen());
          }

          break;
        case "10.0":
          // showKeyboard = false;
          isEnglish = !isEnglish;
          update();
          break;
        case "10.01": //space
          searchController.text = "${searchController.text} ";
          startSearch();
          break;
        case "10.02":
          searchController.text = searchController.text
              .substring(0, searchController.text.length - 1);
          startSearch();
          break;
        case "10.03": //close keyboard
          showKeyboard = false;
          update();

          itemIndex = 0.00;
          update();
          break;

        // case >

        default:
      }
    }
  }

  keyboardController(RawKeyEvent value) async {
    if (isUpdating) return;
    isUpdating = true;
    if (itemIndex < 10.00) {
      itemIndex = 0.01;
      update();
    }

    if (value.logicalKey == LogicalKeyboardKey.arrowRight) {
      itemIndex = itemIndex + 0.01;
      // controller.update();

      // return;
    } else if (value.logicalKey == LogicalKeyboardKey.arrowLeft) {
      itemIndex = itemIndex - 0.01;
      // controller.update();
    } else if (value.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (itemIndex >= 10.00) {
        itemIndex = itemIndex + 0.06;
      } else if (itemIndex <= 10.01) {
        itemIndex = itemIndex + 0.01;
      }
    } else if (value.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (itemIndex >= 10.00) {
        itemIndex = itemIndex - 0.06;
      } else if (itemIndex <= 10.01) {
        itemIndex = itemIndex - 0.01;
      }

      if (itemIndex <= 10.07) {
        itemIndex = 10.01;
      }
    } else if (value.logicalKey == LogicalKeyboardKey.enter) {
      onClicked();
    }

    itemIndex = double.parse(itemIndex.toStringAsFixed(2));

    if (itemIndex > 10.92) {
      itemIndex = 10.92;
    }
    debugPrint(itemIndex.toString());
    update();

    await Future.delayed(const Duration(milliseconds: 200));
    isUpdating = false;
    prevIndex = itemIndex;
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  ScrollController searchScrollController = ScrollController();

  bool isUpdating = false;
  openSearchBox() {
    Get.dialog(const SearchTVPage());
  }
}
