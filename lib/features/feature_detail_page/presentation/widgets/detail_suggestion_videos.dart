import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/search_screen_item.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import '../controllers/detail_page_controller.dart';

class SuggestionVideos extends StatelessWidget {
  const SuggestionVideos({
    super.key,
    required this.pageController,
    required this.width,
  });

  final DetailPageController pageController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (pageController.showSuggestionView &&
            pageController.suggestionList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                const MyText(
                  txt: "دیگر پیشنهادات",
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // jump to  5 items next
                    pageController.suggestionscrollController.animateTo(
                      pageController.suggestionscrollController.offset - 200,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Get.theme.primaryColor,
                    ),
                    child: const Center(
                      child: Icon(Iconsax.arrow_right_34),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    //  jump to 5 items previous
                    pageController.suggestionscrollController.animateTo(
                      pageController.suggestionscrollController.offset + 200,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Get.theme.primaryColor,
                    ),
                    child: const Center(
                      child: Icon(Iconsax.arrow_left_24),
                    ),
                  ),
                )
              ],
            ),
          ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 100,
                    child: SearchItem(
                      item: pageController.suggestionList[index],
                      onTap: () {
                        pageController.changeDetailData(
                            pageController.suggestionList[index].tag!,
                            pageController.suggestionList[index].thumbnail1x!);
                      },
                    ));
              },
              physics: const BouncingScrollPhysics(),
              itemCount: pageController.suggestionList.length,
              scrollDirection: Axis.horizontal,
              controller: pageController.suggestionscrollController,
            ),
          ),
        ),
      ],
    );
  }
}
