import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/locator.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/database_helper.dart';
import '../../../../../../core/widgets/mytext.dart';
import '../../../../../feature_detail_page/data/model/video_model.dart';
import '../../../../../feature_detail_page/presentation/controllers/download_page_controller.dart';

// ignore: must_be_immutable
class DownloadedView extends StatelessWidget {
  DownloadedView({
    Key? key,
    required this.videoDownloadedList,
  }) : super(key: key);
  final List videoDownloadedList;

  DictionaryDataBaseHelper dataBaseHelper = locator();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          MyText(txt: "دانلود شده ها", size: 16.sp, fontWeight: FontWeight.bold)
        ]),
        SizedBox(height: 10.h),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          itemCount: videoDownloadedList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Video video = Video.fromJson(
                json.decode(videoDownloadedList[index]['video']));
            // print();
            // print(videoDownloadedList[index]);
            // LogPrint(videoDownloadedList[index]);
            // print(video.tag);
            return InkWell(
              onTap: () {
                final downloadController = Get.find<DownloadPageController>();
                downloadController.playDownloadedVideo(video.tag!);
              },
              onLongPress: () {
                Get.defaultDialog(
                  title: "حذف فایل",
                  content:
                      const MyText(txt: "آیا از حذف این فایل مطمئن هستید؟"),
                  textConfirm: "بله",
                  textCancel: "خیر",
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.white,
                  onConfirm: () {
                    final downloadController =
                        Get.find<DownloadPageController>();

                    downloadController.deleteDownloadedVideo(video.tag!);
                    Get.back();
                  },
                  onCancel: () {
                    Get.back();
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  // margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 200.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: Constants.imageFiller(video.thumbnail1x!),
                        fit: BoxFit.cover,
                        color: Colors.black26,
                        height: 200.h,
                        colorBlendMode: BlendMode.darken,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Icon(Iconsax.play5,
                              size: 25,
                              color: Theme.of(context).colorScheme.secondary)),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: Colors.black26,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // stops: [0.0, 100.1],
                            colors: [
                              Colors.black26,
                              Colors.black45,
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyText(
                              txt: video.title!,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              maxLine: 2,
                              overflow: TextOverflow.ellipsis,
                              size: 14.sp,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
