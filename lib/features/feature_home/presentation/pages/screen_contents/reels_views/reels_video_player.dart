import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:movie_chi/features/feature_home/data/model/home_reels_model.dart';

import '../../../controller/home_page_controller.dart';

class VideoReelsPlayer extends StatefulWidget {
  const VideoReelsPlayer(this.reelsModel, {super.key});

  final ReelsModel reelsModel;

  @override
  State<VideoReelsPlayer> createState() => _VideoReelsPlayerState();
}

class _VideoReelsPlayerState extends State<VideoReelsPlayer> {
  late VideoPlayerController controller;
  final homePageController = Get.find<HomePageController>();
  bool loadingWidget = true;

  void initController() async {
    // ignore: deprecated_member_use
    controller = VideoPlayerController.network(widget.reelsModel.video!)
      ..setLooping(true)
      ..setVolume(homePageController.mute ? 0 : 1);
    await controller.initialize();

    controller.addListener(() {
      if (controller.value.isInitialized) {
        setState(() {
          loadingWidget = false;
        });
      }
      homePageController.isPlaying = (controller.value.isPlaying);
    });
  }

  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<HomePageController>(builder: (pagecontroller) {
      // if (pagecontroller.isPlaying == false) {
      //   controller.pause();
      // }
      // if (pagecontroller.isPlaying == true) {
      //   controller.play();
      // }
      return VisibilityDetector(
        key: Key(widget.reelsModel.id.toString()),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0.0) {
            // controller.seekTo(Duration.zero);
            controller.pause();
          }
          if (visibility.visibleFraction == 1.0) {
            controller.play();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: SizedBox(
                height: controller.value.size.height,
                width: controller.value.size.width,
                child: VideoPlayer(
                  controller,
                ),
              ),
            ),
            if (loadingWidget)
              LoadingAnimationWidget.flickr(
                leftDotColor: Theme.of(context).colorScheme.secondary,
                rightDotColor:
                    Theme.of(context).colorScheme.background.withAlpha(100),
                size: size.width * 0.1,
              ),
            Positioned.fill(
              child: GestureDetector(
                onLongPressStart: (d) {
                  controller.pause();
                },
                onLongPressEnd: (d) {
                  controller.play();
                },
                onTap: () {
                  homePageController.changeMutableState();
                  controller.setVolume(homePageController.mute ? 0 : 1.0);
                  homePageController.showMutewidget = true;
                  setState(() {});
                  Timer(const Duration(seconds: 3), () {
                    homePageController.showMutewidget = false;
                    setState(() {});
                  });
                },
                child: Container(
                  color: Colors.red.withAlpha(10),
                ),
              ),
            ),
            Positioned(
              width: 60,
              height: 60,
              left: size.width * 0.5 - 30,
              bottom: size.height * 0.45 - 30,
              child: GestureDetector(
                onTap: () {
                  homePageController.changeMutableState();
                  controller.setVolume(homePageController.mute ? 0 : 1.0);
                  homePageController.showMutewidget = true;
                  setState(() {});
                  Timer(const Duration(seconds: 2), () {
                    homePageController.showMutewidget = false;
                    setState(() {});
                  });
                },
                child: homePageController.showMutewidget
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.black87,
                          ),
                          child: Icon(
                            homePageController.mute
                                ? EvaIcons.volume_mute
                                : EvaIcons.volume_up,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  // color: Colors.red,
                  width: double.infinity,
                  height: 10,
                  child: SliderTheme(
                    data: SliderThemeData(
                      overlayShape: SliderComponentShape.noThumb,
                      trackShape: CustomTrackShape(),
                      thumbShape: SliderComponentShape.noThumb,
                    ),
                    child: Slider(
                      value:
                          controller.value.position.inMilliseconds.toDouble(),
                      min: 0,
                      max: controller.value.duration.inMilliseconds.toDouble(),
                      onChanged: (d) {
                        controller.seekTo(Duration(milliseconds: d.toInt()));
                      },
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!);
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
