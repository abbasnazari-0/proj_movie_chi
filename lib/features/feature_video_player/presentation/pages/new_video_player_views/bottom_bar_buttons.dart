import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:media_kit_video/media_kit_video.dart' as mediaKit;
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/setting_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/track_chooser.dart';

class BottomBarButtons {
  List<Widget> buttonBarVideoPlayer(BuildContext context) {
    final pageVideoPlayerController = Get.find<NewPageVideoPlayerController>();

    return [
      const mediaKit.MaterialPositionIndicator(),

      const Spacer(),
      // if (pageVideoPlayerController.episoidIndex > 0)
      //   IconButton(
      //     tooltip: "قسمت قبلی",
      //     icon: const Icon(
      //       Iconsax.arrow_left_2,
      //     ),
      //     onPressed: () async {
      //       int prevideo = pageVideoPlayerController.episoidIndex - 1;
      //       final detaiPageController = Get.find<DetailPageController>();
      //       final downloadController = Get.find<DownloadPageController>();
      //       Video video = detaiPageController.episoidToVideo(
      //           pageVideoPlayerController.eposiod[prevideo],
      //           pageVideoPlayerController.baseVideo ?? Video());
      //       String qualityLink = await downloadController.checkQuality(video,
      //           actionButton: "پخش");

      //       pageVideoPlayerController.videoArguman = video;
      //       pageVideoPlayerController.cutomLink = qualityLink;

      //       pageVideoPlayerController.controller.player.previous();

      //       pageVideoPlayerController.episoidIndex = prevideo;
      //       pageVideoPlayerController.loadLastView();
      //     },
      //   ),
      // // if (pageVideoPlayerController.baseVideo?.type == "session")
      // if (pageVideoPlayerController.episoidIndex <
      //     pageVideoPlayerController.eposiod.length - 1)
      //   IconButton(
      //     tooltip: "قسمت بعدی",
      //     icon: const Icon(
      //       Iconsax.arrow_right_3,
      //     ),
      //     onPressed: () async {
      //       int prevideo = pageVideoPlayerController.episoidIndex + 1;
      //       final detaiPageController = Get.find<DetailPageController>();
      //       final downloadController = Get.find<DownloadPageController>();
      //       Video video = detaiPageController.episoidToVideo(
      //           pageVideoPlayerController.eposiod[prevideo],
      //           pageVideoPlayerController.baseVideo ?? Video());

      //       String qualityLink = await downloadController.checkQuality(video,
      //           actionButton: "پخش");

      //       pageVideoPlayerController.controller.player.next();

      //       pageVideoPlayerController.videoArguman = video;
      //       pageVideoPlayerController.cutomLink = qualityLink;

      //       pageVideoPlayerController.episoidIndex = prevideo;

      //       pageVideoPlayerController.update();
      //     },
      //   ),
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
            SubtitleTrackHelper().subtitleChooser(
              pageVideoPlayerController.controller,
              context,
              () {
                pageVideoPlayerController.viewController.showSubtitle(
                    pageVideoPlayerController.baseVideo?.qualitiesId ?? 0,
                    context,
                    pageVideoPlayerController.controller);
              },
            );
            // change video quality

            //     pageVideoPlayerController.baseVideo?.qualitiesId ?? 0,
            //     context,
            //     pageVideoPlayerController.controller);
          },
        ),

      IconButton(
        icon: const Icon(
          Icons.volume_up_rounded,
        ),
        onPressed: () {
          AudioTrackHelper.audioChooser(
              pageVideoPlayerController.controller, context);
        },
      ),

      // full screen button
      const mediaKit.MaterialFullscreenButton(),
    ];
  }
}
