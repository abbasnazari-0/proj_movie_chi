import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import '../../../../data/model/home_catagory_model.dart';

class HomeBannerView extends StatelessWidget {
  const HomeBannerView({
    super.key,
    required this.homeCatagoryItem,
  });

  final HomeCatagoryItemModel homeCatagoryItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.tryParse(homeCatagoryItem.viewWidth!)!.w,
      // height: double.tryParse(homeCatagoryItem.viewHeight!)!.h,
      width: double.infinity,
      height: Get.size.width * 0.6,
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.transparent,
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
                color: Colors.white,
                // size: 10,
              ),
            ),
            CachedNetworkImage(
              imageUrl: Constants.imageFiller(
                  homeCatagoryItem.data?.first.thumbnail2x ??
                      homeCatagoryItem.data?.first.thumbnail1x ??
                      ""),
              width: double.infinity,
              fit: BoxFit.cover,
              height: Get.size.width * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
