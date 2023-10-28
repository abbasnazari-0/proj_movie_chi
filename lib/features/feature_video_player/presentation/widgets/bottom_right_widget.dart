import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../controller/setting_controller.dart';
import '../controller/video_player_controller.dart';
import '../controller/video_player_view_controller.dart';

class BottomRightWidget extends StatelessWidget {
  const BottomRightWidget({
    super.key,
    required this.viewController,
    required this.pageVideoPlayerController,
  });

  final VideoPlayerViewController viewController;
  final PageVideoPlayerController pageVideoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        if (viewController.enableSubtitle)
          IconButton(
            icon: const Icon(
              Icons.subtitles_rounded,
            ),
            onPressed: () {
              // change video quality
              viewController.showSubtitle(
                  pageVideoPlayerController.baseVideo?.qualitiesId ?? 0,
                  context,
                  pageVideoPlayerController.controller);
            },
          ),
      ],
    );
  }
}
