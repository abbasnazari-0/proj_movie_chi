import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_video_player/data/model/video_subtitle_model.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/video_player_controller.dart';

import '../../../feature_home/data/model/cinimo_config_model.dart';
import '../../../feature_home/presentation/widgets/home_drawer.dart';
import '../../domain/usecases/video_player_usecase.dart';

class VideoPlayerViewController extends GetxController {
  final VideoPlayerUseCase videoPlayerUseCase;
  bool showWaterMark = true;
  MeeduPlayerController? videoController;
  VideoPlayerViewController(this.videoPlayerUseCase);

  final pagePlayerController = Get.find<PageVideoPlayerController>();

  toggleWaterMark(bool show) {
    showWaterMark = show;
    update();
  }

  bool enableSubtitle = false;
  loadenableSubtitle() async {
    enableSubtitle = config.config?.enableSubtitle ?? false;

    update();
  }

  CinimoConfig config = configDataGetter();
  @override
  void onInit() {
    super.onInit();
    loadenableSubtitle();
  }

  String? qualityID;

  subtitleLoader(String qualitiesId) async {
    if (loadenableSubtitle() == false) return;

    DataState dataState = await videoPlayerUseCase.getSubtitle(qualitiesId);
    if (dataState is DataSuccess) {
      VideoSubtitle videoSubtitle = dataState.data;
      if (videoSubtitle.result == true) {
        subtitleClicked(0, videoSubtitle);
        // if (pagePlayerController.controller.fullscreen.value == false) {
        //   pagePlayerController.controller.toggleFullScreen(Get.context!);
        // }
      }
    }
  }

  bool isUTF8(String input) {
    try {
      utf8.decode(input.runes.toList());
      return true;
    } on FormatException {
      return false;
    }
  }

  subtitleClicked(int index, VideoSubtitle videoSubtitle) async {
    pagePlayerController.videoUrl = pagePlayerController.videoUrl;

    if (videoSubtitle.data?.isEmpty ?? true) return;

    if (isLink(videoSubtitle.data?[index].caption ?? "")) {
      if (videoSubtitle.data![index].caption.toString().endsWith("zip")) {
        // start download subtitle
        DataState dataState = await videoPlayerUseCase
            .getSubtitleZipFile(videoSubtitle.data![index].caption ?? "");

        if (dataState is DataSuccess) {
          File zipFile = dataState.data;

          // unzip file
          String savePath = generateRandomString(10);
          final destinationDir = Directory.systemTemp.createTempSync(savePath);

          try {
            await ZipFile.extractToDirectory(
                zipFile: zipFile, destinationDir: destinationDir);

            // get list files of unzip file
            List<FileSystemEntity> files = destinationDir.listSync();

            // get first file
            File file = File(files[0].path);

            // read file
            String subtitle = await file.readAsString();
            pagePlayerController.caption = subtitle;
          } catch (e) {
            Constants.showGeneralSnackBar("خطا", "خطر در دریافت زیرنویس");
            return;
          }
        } else {
          Constants.showGeneralSnackBar("خطا", "خطر در دریافت زیرنویس");
          return;
        }
        // unzip file
      } else {
        // start download subtitle
        DataState dataState = await videoPlayerUseCase
            .getVideoSubtitleFromLink(videoSubtitle.data![index].caption ?? "");

        String subtitle = dataState.data;

        // // check if not utf8
        // if (!isUTF8(subtitle)) {
        //   subtitle = utf8.decode(subtitle.runes.toList(), allowMalformed: true);
        // }
        pagePlayerController.caption = subtitle;
      }
    } else {
      pagePlayerController.caption = (videoSubtitle.data![index].caption ?? "");
    }

    pagePlayerController.changeDataSource(
        true, pagePlayerController.controller.position.value.inSeconds);

    pagePlayerController.controller.onClosedCaptionEnabled(false);
    pagePlayerController.controller.onClosedCaptionEnabled(true);
  }

  showSubtitle(
    qualityID,
    context,
    MeeduPlayerController videocontroller,
  ) async {
    if (qualityID == 0) {
      Constants.showGeneralSnackBar("خطا", "خطر در دریافت زیرنویس");
      return;
    }
    await videocontroller.pause();
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: FutureBuilder<DataState<VideoSubtitle>>(
              future: videoPlayerUseCase.getSubtitle(qualityID),
              builder: (context, _) {
                if (_.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.flickr(
                    leftDotColor: Theme.of(context).colorScheme.secondary,
                    rightDotColor:
                        Theme.of(context).colorScheme.background.withAlpha(100),
                    size: Get.size.width * 0.1,
                  );
                }

                if (_.hasError) {
                  return const Center(child: Text('Error'));
                }
                if (_.hasData) {
                  DataState dataState = _.data!;

                  if (dataState is DataFailed) {
                    return const Center(child: Text('Error'));
                  }
                  if (dataState is DataSuccess) {
                    VideoSubtitle videoSubtitle = dataState.data;

                    return Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            if ((videoSubtitle.amount ?? 0) == 0)
                              Column(
                                children: [
                                  Lottie.asset("assets/lotties/empty.json",
                                      height: 120.h),
                                  const MyText(
                                      txt: "زیر نویسی برای این فیلم یافت نشد")
                                ],
                              ),
                            if ((videoSubtitle.amount ?? 0) > 0)
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 0.2,
                                    );
                                  },
                                  itemCount: videoSubtitle.amount ?? 0,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        MyText(
                                            // textAlign: TextAlign.center,
                                            txt: videoSubtitle
                                                    .data![index].title
                                                    .toString() +
                                                videoSubtitle.data![index].year
                                                    .toString()),
                                        TextButton(
                                          onPressed: () async {
                                            subtitleClicked(
                                                index, videoSubtitle);

                                            Get.back();

                                            // change screen direction
                                            // if (pagePlayerController.controller
                                            //         .fullscreen.value ==
                                            //     false) {
                                            // pagePlayerController.controller
                                            //     .toggleFullScreen(
                                            //         Get.context!);
                                            // }
                                          },
                                          child: const MyText(
                                              txt: "انتخاب زیر نویس"),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            IconButton(
                                onPressed: () {
                                  Get.close(0);
                                },
                                icon: const Icon(Icons.close_rounded))
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const MyText(txt: "unk");
              }),
        );
      },
    );

    // if (data is DataSuccess) {}
    // if (data is DataFailed) {}
  }
}
