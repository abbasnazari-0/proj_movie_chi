import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';

import '../../../../core/widgets/mytext.dart';
import '../../../feature_detail_page/data/model/video_model.dart';

String getVideoUrl(Video video, {String? custom}) {
  if (custom != null) {
    return Constants.videoFiller(custom);
  }

  String url = "";
  if (video.quality1080 != null) {
    url = video.quality1080!;
  } else if (video.quality720 != null) {
    url = video.quality720!;
  } else if (video.quality480 != null) {
    url = video.quality480!;
  } else if (video.quality360 != null) {
    url = video.quality360!;
  } else if (video.quality240 != null) {
    url = video.quality240!;
  }
  return url;
}

String getVideoUrlFromEdpisod(EpisoidsData video, {String? custom}) {
  if (custom != null) {
    return Constants.videoFiller(custom);
  }

  String url = "";
  if (video.quality1080 != null) {
    url = video.quality1080!;
  } else if (video.quality720 != null) {
    url = video.quality720!;
  } else if (video.quality480 != null) {
    url = video.quality480!;
  } else if (video.quality360 != null) {
    url = video.quality360!;
  } else if (video.quality240 != null) {
    url = video.quality240!;
  }
  return url;
}

class SettingController {
  Widget qualityItem(String quality, context) {
    String videoQuality = "";
    // switch
    switch (quality) {
      case '240':
        videoQuality = pageVideoPlayerController.baseVideo!.quality240!;
        break;
      case '360':
        videoQuality = pageVideoPlayerController.baseVideo!.quality360!;
        break;
      case '480':
        videoQuality = pageVideoPlayerController.baseVideo!.quality480!;
        break;
      case '720':
        videoQuality = pageVideoPlayerController.baseVideo!.quality720!;
        break;
      case '1080':
        videoQuality = pageVideoPlayerController.baseVideo!.quality1080!;
        break;
      case '1440':
        videoQuality = pageVideoPlayerController.baseVideo!.quality1440!;
        break;
      case '2160':
        videoQuality = pageVideoPlayerController.baseVideo!.quality2160!;
        break;
      case '4320':
        videoQuality = pageVideoPlayerController.baseVideo!.quality4320!;
        break;
      default:
        getVideoUrl(pageVideoPlayerController.baseVideo!);
    }
    return InkWell(
      onTap: () {
        pageVideoPlayerController.videoUrl = videoQuality;
        pageVideoPlayerController.caption = pageVideoPlayerController.caption;
        pageVideoPlayerController.changeDataSource(
            true,
            pageVideoPlayerController
                .controller.player.state.position.inSeconds);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              height: 80,
              'assets/images/icon.png',
              cacheHeight: int.parse(quality) ~/ 6,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MyText(
                txt: quality,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final pageVideoPlayerController = Get.find<NewPageVideoPlayerController>();

  changeVideoQuality(context) {
    int currentTab = 0;
    // pause video
    pageVideoPlayerController.controller.player.pause();
    PageController pageController = PageController(initialPage: currentTab);

    showDialog(
      context: context,
      builder: (context) => Center(
        child: StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DefaultTabController(
                  initialIndex: currentTab,
                  length: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(10),
                      const TabBar(tabs: [
                        Tab(
                          text: 'کیفیت ویدیو',
                          icon: Icon(Icons.video_settings_rounded),
                        ),
                      ]),
                      const Gap(10),
                      const Divider(
                        color: Colors.white,
                        height: 0.5,
                        endIndent: 40,
                        indent: 40,
                        thickness: 0.1,
                      ),
                      const Gap(10),
                      Expanded(
                        child: PageView(
                          pageSnapping: false,
                          allowImplicitScrolling: true,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality240 !=
                                        null)
                                      qualityItem(240.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality360 !=
                                        null)
                                      qualityItem(360.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality480 !=
                                        null)
                                      qualityItem(480.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality720 !=
                                        null)
                                      qualityItem(720.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality1080 !=
                                        null)
                                      qualityItem(1080.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality1440 !=
                                        null)
                                      qualityItem(1440.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality2160 !=
                                        null)
                                      qualityItem(2160.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality4320 !=
                                        null)
                                      qualityItem(4320.toString(), context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
    // pageVideoPlayerController.controller.setDataSource(
    //   DataSource(
    //     type: DataSourceType.network,
    //     source: getVideoUrl(video.),
    //   ),
    //   autoplay: true,
    // );
  }
}
