import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import '../../../../../feature_play_list/presentation/pages/feature_play_list.dart';
import '../../../../data/model/home_catagory_model.dart';
import '../../../controller/home_page_controller.dart';

class HomeGalleryVideos extends StatelessWidget {
  HomeGalleryVideos({
    super.key,
    required this.itemGalleryData,
  });

  final HomeCatagoryItemModel itemGalleryData;
  final homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Constants.hexToColor(itemGalleryData.viewColor!)
          .withAlpha(int.parse(itemGalleryData.colorAlpha ?? "255")),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => PlayListScreen(
                    homeCatagoryItemID: itemGalleryData.id.toString(),
                    type: "more",
                    title: itemGalleryData.title!,
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 20, left: 10),
              child: Row(
                children: [
                  MyText(
                    txt: itemGalleryData.title!,
                    color: Theme.of(context).primaryTextTheme.bodyMedium!.color,
                    fontWeight: FontWeight.bold,
                    size: 16.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  MyText(
                      txt: "بیشتر",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 13.sp),
                  const Icon(Iconsax.arrow_left_2),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CarouselSlider(
              items: itemGalleryData.data!.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.9 / 10),
                          child: GestureDetector(
                            onTap: () async {
                              // await Get.to(() => DetailPage(
                              //       vid_tag: i.tag!,
                              //     ));
                              await Constants.openVideoDetail(
                                  vidTag: i.tag!,
                                  type: i.type,
                                  commonTag: i.commonTag,
                                  picture: i.thumbnail1x!);
                              final homePageController =
                                  Get.find<HomePageController>();
                              homePageController.returnScreen();
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        Constants.imageFiller(i.thumbnail1x!),
                                    color: Colors.black26,
                                    colorBlendMode: BlendMode.darken,
                                    fit: BoxFit.cover,
                                    httpHeaders: const {
                                      'Referer': 'https://www.cinimo.ir/'
                                    },
                                    // handle error
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: MyText(
                                      txt: i.title ?? '',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      size: 18,
                                      textAlign: TextAlign.center,
                                      maxLine: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                );
              }).toList(),
              carouselController: CarouselController(),
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  // viewportFraction: 0.9,
                  // disableCenter: false,
                  onPageChanged: (index, reason) {
                    // controller.onPageChanged(index, reason);
                  },
                  height: width * 0.85,
                  aspectRatio: 0.5,
                  autoPlayAnimationDuration: const Duration(seconds: 2)
                  // initialPage: 2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
