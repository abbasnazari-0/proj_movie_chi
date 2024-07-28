import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../feature_zhanner/presentation/pages/zhanner_detail.dart';
import '../controller/home_page_controller.dart';

class HomeZhannerView extends StatelessWidget {
  HomeZhannerView({
    super.key,
    required this.width,
  });

  final double width;

  final controller = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.zhannerList.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(
                  () => ZhannerDetail(zhanner: controller.zhannerList[index]));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: SizedBox(
                  width: width * 0.3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: Constants.imageFiller(
                            controller.zhannerList[index].pics ?? ""),
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.5),
                        colorBlendMode: BlendMode.darken,
                        errorWidget: (context, url, error) => Container(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Center(
                        child: MyText(
                          txt: controller.zhannerList[index].tag ?? "",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          maxLine: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
