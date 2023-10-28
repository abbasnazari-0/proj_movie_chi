// set quality Widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

Widget qualityWidget(String quality) {
  // ignore: unnecessary_null_comparison
  if (quality != null) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: Get.theme.colorScheme.secondary.withAlpha(190),
        border: Border.all(color: Get.theme.colorScheme.secondary),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.secondary.withAlpha(50),
            blurRadius: 1,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 20.h,
      child: Center(
        child: MyText(
          txt: quality,
          fontWeight: FontWeight.bold,
          color: Colors.white54,
        ),
      ),
    );
  } else {
    return Container();
  }
}
