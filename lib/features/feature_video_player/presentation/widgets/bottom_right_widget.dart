import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/detail_page_controller.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/download_page_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';

import '../controller/setting_controller.dart';

// ignore: library_prefixes
import 'package:iconsax/iconsax.dart' as iconSax;

class BottomRightWidget extends StatelessWidget {
  const BottomRightWidget({
    super.key,
    required this.pageVideoPlayerController,
  });

  final NewPageVideoPlayerController pageVideoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // if (pageVideoPlayerController.baseVideo?.type == "session")
        // if(pageVideoPlayerController.eposiod
        // find next episoid of this session
        // pageVideoPlayerController.episoidIndex
        // find next value of current episoid
        //
        if (pageVideoPlayerController.episoidIndex > 0)
          IconButton(
            tooltip: "قسمت قبلی",
            icon: const Icon(
              iconSax.Iconsax.arrow_left_2,
            ),
            onPressed: () async {
              int prevideo = pageVideoPlayerController.episoidIndex - 1;
              final detaiPageController = Get.find<DetailPageController>();
              final downloadController = Get.find<DownloadPageController>();
              Video video = detaiPageController.episoidToVideo(
                  pageVideoPlayerController.eposiod[prevideo],
                  pageVideoPlayerController.baseVideo ?? Video());
              String qualityLink = await downloadController.checkQuality(video,
                  actionButton: "پخش");

              pageVideoPlayerController.videoArguman = video;
              pageVideoPlayerController.cutomLink = qualityLink;

              pageVideoPlayerController.episoidIndex = prevideo;
              pageVideoPlayerController.loadLastView();
            },
          ),
        // if (pageVideoPlayerController.baseVideo?.type == "session")
        if (pageVideoPlayerController.episoidIndex <
            pageVideoPlayerController.eposiod.length - 1)
          IconButton(
            tooltip: "قسمت بعدی",
            icon: const Icon(
              iconSax.Iconsax.arrow_right_3,
            ),
            onPressed: () async {
              int prevideo = pageVideoPlayerController.episoidIndex + 1;
              final detaiPageController = Get.find<DetailPageController>();
              final downloadController = Get.find<DownloadPageController>();
              Video video = detaiPageController.episoidToVideo(
                  pageVideoPlayerController.eposiod[prevideo],
                  pageVideoPlayerController.baseVideo ?? Video());
              String qualityLink = await downloadController.checkQuality(video,
                  actionButton: "پخش");

              pageVideoPlayerController.videoArguman = video;
              pageVideoPlayerController.cutomLink = qualityLink;

              pageVideoPlayerController.episoidIndex = prevideo;
              pageVideoPlayerController.loadLastView();
            },
          ),
        IconButton(
          icon: const Icon(
            EvaIcons.settings,
          ),
          onPressed: () {
            // change video quality
            SettingController settingController = SettingController();
            settingController.changeVideoQuality(context);
          },
        ),
        if (pageVideoPlayerController.viewController.enableSubtitle)
          IconButton(
            icon: const Icon(
              Icons.subtitles_rounded,
            ),
            onPressed: () {
              // change video quality
              pageVideoPlayerController.viewController.showSubtitle(
                  pageVideoPlayerController.baseVideo?.qualitiesId ?? 0,
                  context,
                  pageVideoPlayerController.controller);
            },
          ),
      ],
    );
  }
}
