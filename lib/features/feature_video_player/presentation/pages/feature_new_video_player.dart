import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/config/text_theme.dart';
import 'package:movie_chi/core/utils/database_helper.dart';
import 'package:movie_chi/core/widgets/app_loading_widget.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/new_video_player_views/bottom_bar_buttons.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/new_video_player_views/top_button_bar.dart';

import '../../../../locator.dart';

class FeatureNewVideoPlayer extends StatefulWidget {
  const FeatureNewVideoPlayer({
    Key? key,
    required this.isLocaled,
  }) : super(key: key);
  final bool isLocaled;

  @override
  State<FeatureNewVideoPlayer> createState() => _FeatureNewVideoPlayerState();
}

class _FeatureNewVideoPlayerState extends State<FeatureNewVideoPlayer> {
  final pageVideoPlayerController =
      Get.put(NewPageVideoPlayerController(locator()));

  @override
  void initState() {
    super.initState();

    pageVideoPlayerController.loadLastView();
  }

  DictionaryDataBaseHelper dbHelper = locator();

  @override
  void dispose() {
    super.dispose();
    pageVideoPlayerController.controller.player.dispose();
    // pageVideoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<NewPageVideoPlayerController>(builder: (cont) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          // Use [Video] widget to display video output.

          child: MaterialVideoControlsTheme(
            normal: MaterialVideoControlsThemeData(
                brightnessGesture: true,
                volumeGesture: true,
                topButtonBar: TopButtonBar().topButtonBar(
                    pageVideoPlayerController.baseVideo?.title ?? "",
                    pageVideoPlayerController.addtionTitle),
                bufferingIndicatorBuilder: (context) {
                  return const AppLoadingWidget();
                },
                bottomButtonBar:
                    BottomBarButtons().buttonBarVideoPlayer(context)),
            fullscreen: MaterialVideoControlsThemeData(
              brightnessGesture: true,
              volumeGesture: true,
              seekBarMargin:
                  const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              bottomButtonBarMargin:
                  const EdgeInsets.only(bottom: 20, left: 20, right: 20),

              topButtonBar: TopButtonBar().topButtonBar(
                  pageVideoPlayerController.baseVideo?.title ?? "",
                  pageVideoPlayerController.addtionTitle),
              // topButtonBar: TopButtonBar().topButtonBar,
              bufferingIndicatorBuilder: (context) {
                return const AppLoadingWidget();
              },
              bottomButtonBar: BottomBarButtons().buttonBarVideoPlayer(context),
            ),
            child: Video(
              controller: pageVideoPlayerController.controller,
              wakelock: true,
              subtitleViewConfiguration: SubtitleViewConfiguration(
                textScaleFactor: 1.1,
                style: faTextTheme(context),
                textAlign: TextAlign.center,
                padding: const EdgeInsets.all(24.0),
              ),
              pauseUponEnteringBackgroundMode: false,
              resumeUponEnteringForegroundMode: true,
              controls: (state) {
                pageVideoPlayerController.videoState = state;

                return Stack(
                  children: [
                    AdaptiveVideoControls(state),
                    // cont.showWaterMark

                    Positioned(
                      bottom: 80,
                      right: 20,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Image.asset(
                                'assets/images/icon.png',
                                height: 20,
                              ),
                              const SizedBox(width: 10),
                              const MyText(
                                txt: 'مووی چی!؟',
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    // : Container();
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
