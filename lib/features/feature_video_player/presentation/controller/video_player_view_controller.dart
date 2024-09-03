import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_video_player/data/model/video_subtitle_model.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';
// import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';

import '../../../feature_home/data/model/cinimo_config_model.dart';
import '../../../feature_home/presentation/widgets/home_drawer.dart';
import '../../domain/usecases/video_player_usecase.dart';

class VideoPlayerViewController extends GetxController {
  final VideoPlayerUseCase videoPlayerUseCase;
  bool showWaterMark = true;
  VideoController? videoController;
  VideoPlayerViewController(this.videoPlayerUseCase);
  bool showSubtitleValue = true;

  bool videolastandfirstController = false;

  toggleVideoLastAndFirst(bool show) {
    videolastandfirstController = show;

    if (show) {
      Future.delayed(const Duration(seconds: 10), () {
        toggleVideoLastAndFirst(false);
      });
    }
    update();
  }

  nextVideo() {
    return false;
  }

  prevVideo() {
    // return;
  }

  toggleWaterMark(bool show) {
    showWaterMark = show;
    toggleVideoLastAndFirst(show);
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
    final pagePlayerController = Get.find<NewPageVideoPlayerController>();
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
            pagePlayerController.controller.player.setSubtitleTrack(
              SubtitleTrack.data(
                subtitle,
                language: "per",
                title: (videoSubtitle.data?[index].title),
              ),
            );
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
        // pagePlayerController.caption = subtitle;
        pagePlayerController.controller.player.setSubtitleTrack(
            SubtitleTrack.data(subtitle,
                language: "per", title: (videoSubtitle.data![index].title)));
      }
    } else {
      pagePlayerController.caption = (videoSubtitle.data![index].caption ?? "");
    }

    //     true, pagePlayerController.controller.position.value.inSeconds);

    // pagePlayerController.controller.onClosedCaptionEnabled(false);
    // pagePlayerController.controller.onClosedCaptionEnabled(true);
  }

  showSubtitle(
    qualityID,
    context,
    VideoController videocontroller,
  ) async {
    if (qualityID == 0) {
      Constants.showGeneralSnackBar("خطا", "خطر در دریافت زیرنویس");
      return;
    }
    await videocontroller.player.pause();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
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

                    return GetBuilder<VideoPlayerViewController>(
                        id: "subtitle",
                        builder: (controller) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Gap(10),
                                      IconButton(
                                          onPressed: () {
                                            Get.close(0);
                                          },
                                          icon: const Icon(Icons.close_rounded))
                                    ],
                                  ),
                                  if ((videoSubtitle.amount ?? 0) == 0)
                                    Column(
                                      children: [
                                        Lottie.asset(
                                            "assets/lotties/empty.json",
                                            height: 120),
                                        const MyText(
                                            txt:
                                                "زیر نویسی برای این فیلم یافت نشد")
                                      ],
                                    ),
                                  if ((videoSubtitle.amount ?? 0) > 0)
                                    const Gap(10),
                                  const MyText(
                                    txt: "انتخاب زیرنویس",
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(10),
                                  if ((videoSubtitle.amount ?? 0) > 0)
                                    const MyText(
                                      txt:
                                          "لطفا یکی از زیرنویس های زیر را انتخاب کنید",
                                      size: 16,
                                      fontWeight: FontWeight.w300,
                                      textAlign: TextAlign.center,
                                    ),
                                  const Gap(10),
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
                                          return TextButton(
                                            onPressed: () {
                                              subtitleClicked(
                                                  index, videoSubtitle);
                                              Get.close(0);
                                            },
                                            child: MyText(
                                              textAlign: TextAlign.center,
                                              txt: videoSubtitle
                                                  .data![index].title
                                                  .toString(),
                                              size: 15,
                                              color: Colors.amber,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  // SizedBox(
                                  //   width: 0.5.sw,
                                  //   child: SwitchListTile(
                                  //       value: showSubtitleValue,
                                  //       subtitle: MyText(
                                  //         txt:
                                  //             "با غیرفعال کردن دیگر زیرنویس نمایش داده نمیشود",
                                  //         color: Colors.white70,
                                  //         size: 14.sp,
                                  //       ),
                                  //       onChanged: (v) {
                                  //         if (v == false) {
                                  //           final pagePlayerController = Get.find<
                                  //               NewPageVideoPlayerController>();
                                  //           pagePlayerController
                                  //               .controller.player
                                  //               .setSubtitleTrack(
                                  //                   SubtitleTrack.no());
                                  //         }
                                  //       },
                                  //       thumbColor: MaterialStateProperty.all(
                                  //           Theme.of(context)
                                  //               .colorScheme
                                  //               .secondary),
                                  //       inactiveThumbColor: Theme.of(context)
                                  //           .colorScheme
                                  //           .secondary
                                  //           .withAlpha(100),
                                  //       title: MyText(
                                  //         txt: "فعال کردن زیرنویس",
                                  //         size: 18.sp,
                                  //         color: Colors.white,
                                  //       )),
                                  // )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }
                return const MyText(txt: "unk");
              }),
        );
      },
    );
  }
}
