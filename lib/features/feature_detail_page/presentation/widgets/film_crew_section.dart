import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/detail_page_controller.dart';

import '../../../../core/widgets/mytext.dart';

class FilmCrewSection extends StatelessWidget {
  const FilmCrewSection({
    super.key,
    required this.pageController,
  });

  final DetailPageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const MyText(
                txt: "بازیگران",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
                size: 18,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  //  jump to 5 items previous
                  pageController.crewscrollController.animateTo(
                    pageController.crewscrollController.offset - 200,
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
                  // jump to  5 items next
                  pageController.crewscrollController.animateTo(
                    pageController.crewscrollController.offset + 200,
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
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              controller: pageController.crewscrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: pageController.videoDetail!.artistData!.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 70,
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        (pageController.videoDetail!.artistData?[index]
                                    .artistPic !=
                                null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: Constants.imageFiller(
                                    pageController.videoDetail!
                                        .artistData![index].artistPic!,
                                  ),
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  httpHeaders: const {
                                    'Referer': 'https://www.cinimo.ir/'
                                  },
                                  // handle error
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )
                            : Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey,
                                ),
                              )),
                        const SizedBox(height: 5),
                        if (pageController
                                .videoDetail!.artistData?[index].artistName !=
                            null)
                          MyText(
                            txt: pageController
                                .videoDetail!.artistData![index].artistName!,
                            textAlign: TextAlign.center,
                            maxLine: 2,
                            size: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
