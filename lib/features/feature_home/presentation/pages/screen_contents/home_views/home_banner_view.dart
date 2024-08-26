import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/core/widgets/video_item_header.dart';

import '../../../../data/model/home_catagory_model.dart';

class HomeBannerView extends StatelessWidget {
  const HomeBannerView({
    super.key,
    required this.homeCatagoryItem,
  });

  final HomeCatagoryItemModel homeCatagoryItem;

  String getBannerThumbnail(HomeItemData homeMode) {
    if (homeMode.thumbnail2x != null && homeMode.thumbnail2x!.isNotEmpty) {
      return homeMode.thumbnail2x!;
    } else if (homeMode.thumbnail1x != null) {
      return homeMode.thumbnail1x!;
    } else if (homeMode.thumbnail3x != null) {
      return homeMode.thumbnail3x!;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // width: double.tryParse(homeCatagoryItem.viewWidth!)!.w,
          // height: double.tryParse(homeCatagoryItem.viewHeight!)!.h,
          width: double.infinity,
          // height: Get.size.width * 0.6,
          margin: const EdgeInsets.only(bottom: 5),
          color: const Color(0xFF161718),
          child: InkWell(
            onTap: () {
              Constants.openHomeItem(homeCatagoryItem, 0,
                  homeCatagoryItem.data?.first.thumbnail1x ?? "");
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyText(
                    txt: homeCatagoryItem.data?.first.title ?? "",
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    // size: 10,
                  ),
                ),
                CachedNetworkImage(
                  imageUrl: Constants.imageFiller(
                      getBannerThumbnail(homeCatagoryItem.data!.first)),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: Get.size.width * 0.5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          // top: (item.type != "video") ? 18.h : 10.h,
          // left: 0.w,
          right: 0,
          height: 25.h,
          bottom: 15.w,
          child: VideoItemHeader(
            imdb: homeCatagoryItem.data!.first.imdb.toString(),
            isDubbed: homeCatagoryItem.data?.first.dubble != null,
            hasSubtitle: homeCatagoryItem.data?.first.subtitle != null,
          ),
        )
      ],
    );
  }
}
