import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/models/search_video_model.dart';
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
          height: width * 0.8,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                SearchVideo video = pageController.suggestionList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      // Navigate to detail page
                      // Get.back(result: video.tag);
                      pageController.changeDetailData(
                          video.tag!, video.thumbnail1x ?? "");

                      // await Get.toNamed(
                      //   "/detail",
                      //   arguments: video.tag!,
                      //   preventDuplicates: false,
                      // );
                    },
                    child: SizedBox(
                      height: width * 0.7,
                      width: width * 0.4,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  Constants.imageFiller(video.thumbnail1x!),
                              httpHeaders: const {
                                'Referer': 'https://www.cinimo.ir/'
                              },
                              height: width * 0.6,
                              width: width * 0.4,
                              fit: BoxFit.cover,
                              // color: Colors.black.withOpacity(0.2),
                              placeholder: (context, url) => Center(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.black12,
                                  child: Container(
                                    height: width * 0.6,
                                    width: width * 0.4,
                                    color: Colors.black26.withAlpha(20),
                                  ),
                                ),
                              ),

                              // handle error
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          MyText(
                            txt: video.title!.replaceAll("فیلم", ""),
                            maxLine: 2,
                            fontWeight: FontWeight.bold,
                            size: 14,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                );
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
