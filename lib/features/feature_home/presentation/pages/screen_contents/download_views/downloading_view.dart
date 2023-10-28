import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/download_page_controller.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../feature_detail_page/data/model/video_model.dart';
import '../../../../../feature_detail_page/presentation/controllers/detail_page_controller.dart';

class DownloadingView extends StatelessWidget {
  DownloadingView({super.key});
  final pageController = Get.find<DetailPageController>();
  final downloadController = Get.find<DownloadPageController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyText(txt: "در حال دانلود", size: 16.sp, fontWeight: FontWeight.bold),
        SizedBox(
          width: double.infinity,
          height: 160,
          child: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Video video = (downloadController.video!);
              //  pageController.taskList[index];

              // print(task);
              return InkWell(
                onTap: () async {
                  // await Get.to(() => DetailPage(vid_tag: video.tag!),
                  //     arguments: video.tag!);
                  // Constants.openVideoDetail(
                  //     vidTag: video.tag!,
                  //     chainrouter: false,
                  //     type: video.type,
                  //     deepLink: false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.white,
                              width: 80,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: Constants.imageFiller(
                                        video.thumbnail1x!),
                                    fit: BoxFit.cover,
                                    color: Colors.black26,
                                    colorBlendMode: BlendMode.darken,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Iconsax.close_square,
                                            color: Colors.red),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      value: (pageController.prog ?? 0) / 100,
                                      semanticsLabel: "ddd",
                                      semanticsValue: "dddd",
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: MyText(
                                      txt:
                                          "${(double.parse(pageController.prog.toString())).toStringAsFixed(2)}%",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      maxLine: 2,
                                      overflow: TextOverflow.ellipsis,
                                      size: 10,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyText(
                          txt: video.title!,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                          size: 10,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        const Divider(height: 0.025, color: Colors.white10),
        const SizedBox(height: 10),
      ],
    );
  }
}
