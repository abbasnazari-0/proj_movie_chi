import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/mytext.dart';

chooseQuality(List videosQualities,
    {String? actionButton, bool? justQuality}) async {
  var qualitySelected;
  await Get.dialog(
    GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Get.size.width > Get.size.height
                ? Get.size.width * 0.1 //tablet
                : Get.size.width * 0.1,
            vertical: Get.size.width > Get.size.height
                ? Get.size.height * 0.2 //  tablet
                : Get.size.height * 0.3,
          ),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const MyText(
                txt: 'کیفیت ویدیو',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var item in videosQualities)
                        if (item["vid"] != null)
                          InkWell(
                            autofocus: true,
                            onTap: () {
                              if ((justQuality ?? false) == true) {
                                qualitySelected = item["quality"]!;
                                Get.back();
                                return;
                              }
                              // pageVideoPlayerController.controller
                              //     .setDataSource(
                              //   DataSource(
                              //     type: DataSourceType.network,
                              //     source: videoUrl + item["vid"]!,
                              //   ),
                              //   autoplay: true,
                              // );
                              qualitySelected = item["vid"]!;
                              // update();
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Image.asset(
                                    height: 80,
                                    'assets/images/icon.png',
                                    cacheHeight:
                                        int.parse(item["quality"]!) ~/ 6,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.onSecondary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: MyText(
                                      txt: item["quality"]!,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Get.theme.colorScheme.secondary,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: MyText(
                                      txt: actionButton ?? "دانلود",
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return qualitySelected;
}
