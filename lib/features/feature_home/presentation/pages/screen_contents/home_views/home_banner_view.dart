import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_chi/core/utils/constants.dart';

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
      width: double.tryParse(homeCatagoryItem.viewWidth!)!.w,
      height: double.tryParse(homeCatagoryItem.viewHeight!)!.h,
      margin: EdgeInsets.all(20.w),
      child: InkWell(
        onTap: () {
          Constants.openHomeItem(homeCatagoryItem, 0,
              homeCatagoryItem.data?.first.thumbnail1x ?? "");
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            color: Colors.orange,
            child: CachedNetworkImage(
              imageUrl: Constants.imageFiller(
                  homeCatagoryItem.data?.first.thumbnail1x ?? ""),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
