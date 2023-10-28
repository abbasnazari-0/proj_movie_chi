import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/video_player_controller.dart';

import '../../../feature_detail_page/data/model/video_model.dart';

class Controller extends StatelessWidget {
  Controller({
    super.key,
    required this.video,
  });
  final Video video;
  final pageVideoPlayerController = Get.find<PageVideoPlayerController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        pageVideoPlayerController.changeShowControllerStatus(false);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Align(
                        alignment: Alignment.center,
                        child: MyText(
                          txt: video.title ?? '',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.white.withAlpha(20),
                      ),
                      height: 40,
                      width: 40,
                      child: Center(
                        child: IconButton(
                          icon:
                              const Icon(Iconsax.forward_15_seconds4, size: 16),
                          onPressed: () {
                            pageVideoPlayerController.backwardAndForward(15);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.05),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.white.withAlpha(80),
                      ),
                      height: 50,
                      width: 50,
                      child: Center(
                        child: IconButton(
                          icon: pageVideoPlayerController.playMode
                              ? const Icon(Iconsax.pause, size: 16)
                              : const Icon(Iconsax.play, size: 16),
                          onPressed: () {
                            pageVideoPlayerController.chnagePlayMode();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.05),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.white.withAlpha(20),
                      ),
                      height: 40,
                      width: 40,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Iconsax.backward_15_seconds4,
                              size: 16),
                          onPressed: () {
                            pageVideoPlayerController.backwardAndForward(-15);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          txt:
                              "${pageVideoPlayerController.getVideoPositionValue()} / ${pageVideoPlayerController.getVideoDuration()}",
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Slider(
                    value: pageVideoPlayerController.getSliderPosision(),
                    onChanged: (value) {
                      pageVideoPlayerController.chnageSliderPosision(value);
                    },
                    min: 0,
                    max: pageVideoPlayerController.getDurationForSlider(),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveColor: Colors.white.withAlpha(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
