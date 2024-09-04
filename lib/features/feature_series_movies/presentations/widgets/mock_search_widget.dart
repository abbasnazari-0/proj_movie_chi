import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/bottom_app_bar_controller.dart';

class SearchWidgetShow extends StatelessWidget {
  SearchWidgetShow({
    super.key,
  });
  final bottomAppBarController = Get.find<BottomAppBarController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                bottomAppBarController.chnageItemSelected(4.obs);
                bottomAppBarController.pageController.jumpToPage(4);
              },
              child: Hero(
                tag: 'search-widget',
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Gap(10),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      Gap(10),
                      MyText(txt: 'جستجو'),
                      Gap(10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
