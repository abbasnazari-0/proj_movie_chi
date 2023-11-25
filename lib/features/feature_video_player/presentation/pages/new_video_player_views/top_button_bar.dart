import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';

class TopButtonBar {
  List<Widget> topButtonBar(String title, addtionTitle) {
    return [
      const SizedBox(width: 10),
      InkWell(
        child: const Icon(HeroIcons.lock_open),
        onTap: () {
          // change video quality
          // pageVideoPlayerController
          //     .changePlayerLockedStatus(true);
          Get.dialog(
            Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white.withOpacity(0.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Get.close(0);
                      },
                      icon: const Icon(
                        HeroIcons.lock_closed,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            barrierColor: Colors.transparent,
            barrierDismissible: false,
            useSafeArea: true,
          );
        },
      ),
      const SizedBox(width: 10),
      InkWell(
        onTap: () {
          // dispose();
          // Get.back();
          final pageVideoPlayerController =
              Get.find<NewPageVideoPlayerController>();

          pageVideoPlayerController.showCoinHalf();
        },
        child: const Icon(
          Icons.info_rounded,
          color: Colors.white,
          // ),
        ),
      ),
      const Spacer(),
      const SizedBox(width: 10),
      MyText(
        txt:
            "$title${addtionTitle != null && addtionTitle.toString().isNotEmpty ? " - " : ""}${addtionTitle ?? ""}",
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(width: 10),
      // IconButton(
      // onPressed: () {
      // dispose();
      //   Get.back();
      // },
      InkWell(
        onTap: () {
          // dispose();
          Get.back();
        },
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
          // ),
        ),
      ),
      const SizedBox(width: 10),
    ];
  }
}
