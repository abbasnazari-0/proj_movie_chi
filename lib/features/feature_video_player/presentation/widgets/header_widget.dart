import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/widgets/mytext.dart';
import '../controller/video_player_controller.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(
      {super.key,
      required this.pageVideoPlayerController,
      required this.responsive});

  final PageVideoPlayerController pageVideoPlayerController;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PageVideoPlayerController>(builder: (cont) {
      return SizedBox(
        height: responsive.ip(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                  useSafeArea: false,
                );
              },
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                // dispose();
                // Get.back();
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
                  "${pageVideoPlayerController.baseVideo?.title ?? ""}${pageVideoPlayerController.addtionTitle != null && pageVideoPlayerController.addtionTitle.toString().isNotEmpty ? " - " : ""}${pageVideoPlayerController.addtionTitle ?? ""}",
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              size: responsive.fontSize(),
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
          ],
        ),
      );
    });
  }
}
