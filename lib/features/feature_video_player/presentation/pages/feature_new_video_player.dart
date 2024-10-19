import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/config/text_theme.dart';
import 'package:movie_chi/core/extensions/duration_format.dart';
import 'package:movie_chi/core/utils/database_helper.dart';
import 'package:movie_chi/core/widgets/app_loading_widget.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/session_items_groupe.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/tv_video_player_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/new_video_player_views/bottom_bar_buttons.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/new_video_player_views/top_button_bar.dart';

import '../../../../locator.dart';

class FeatureNewVideoPlayer extends StatefulWidget {
  const FeatureNewVideoPlayer({
    Key? key,
    required this.isLocaled,
    this.isForIOS = false,
  }) : super(key: key);
  final bool isLocaled;
  final bool isForIOS;

  @override
  State<FeatureNewVideoPlayer> createState() => _FeatureNewVideoPlayerState();
}

class _FeatureNewVideoPlayerState extends State<FeatureNewVideoPlayer> {
  final pageVideoPlayerController =
      Get.put(NewPageVideoPlayerController(locator()));

  // final detailPageController = Get.find<DetailPageController>();

  @override
  void initState() {
    super.initState();

    pageVideoPlayerController.loadLastView();

    tvVideoPlayerController = Get.put(TvVideoPlayerController(
      videoController: pageVideoPlayerController.controller,
      playListUseCase: locator(),
      videoDetail: pageVideoPlayerController.baseVideo!,
    ));

    // pageVideoPlayerController.controller.player.open(playable)
  }

  DictionaryDataBaseHelper dbHelper = locator();

  // ignore: prefer_typing_uninitialized_variables
  late final TvVideoPlayerController tvVideoPlayerController;
  @override
  void dispose() {
    super.dispose();
    pageVideoPlayerController.controller.player.dispose();
    // pageVideoPlayerController.dispose();
  }

  Widget onStackPlayer() {
    return GetBuilder<TvVideoPlayerController>(builder: (controller) {
      if (controller.itemIndex == 10) return const SizedBox();
      return Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // color: Colors.black38,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.0),
                  ]),
              // borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Gap(10),
                tvVideoPlayerController.indexingWidget(
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_sharp),
                  ),
                  0.00,
                ),
                const Spacer(),
                MyText(
                  txt: pageVideoPlayerController.baseVideo?.title ?? "",
                  color: Colors.white,
                  size: 40,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
              ],
            ),
          ),
          const Spacer(),
          // seek changes
          Row(
            children: [
              const Spacer(),
              tvVideoPlayerController.indexingWidget(
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.replay_10),
                        Gap(10),
                        MyText(
                          txt: '۱۰ ثانیه به عقب',
                        )
                      ],
                    ),
                  ),
                  0.01),
              // const Gap(10),
              const Spacer(flex: 4),
              tvVideoPlayerController.indexingWidget(
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pageVideoPlayerController
                              .controller.player.state.playing
                          ? [
                              const Icon(Icons.pause),
                              const Gap(10),
                              const MyText(
                                txt: 'توقف',
                              )
                            ]
                          : [
                              const Icon(Icons.play_arrow),
                              const Gap(10),
                              const MyText(
                                txt: 'پخش',
                              )
                            ],
                    ),
                  ),
                  0.02),
              const Spacer(flex: 4),
              // const Gap(10),
              tvVideoPlayerController.indexingWidget(
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forward_10),
                        Gap(10),
                        MyText(
                          txt: '۱۰ ثانیه به جلو',
                        )
                      ],
                    ),
                  ),
                  0.03),
              const Spacer(),
            ],
          ),
          // const Spacer(),

          if (pageVideoPlayerController.baseVideo?.type != "video")
            // tvVideoPlayerController.serialStatus == PageStatus.loading

            // : tvVideoPlayerController.serialStatus == PageStatus.error
            // : Center(child: Text('Error')),
            Expanded(
                child: SessionItemGroupe(
              playListModel: SessionModel(
                  data: [Eposiod(episoids: pageVideoPlayerController.eposiod)]),
            )),

          // const Spacer(),
          Row(
            children: [
              const Gap(20),
              MyText(
                txt: pageVideoPlayerController.controller.player.state.position
                    .formatToHHMMSS(),
              ),
              const Spacer(),
              MyText(
                txt: pageVideoPlayerController.controller.player.state.duration
                    .formatToHHMMSS(),
              ),
              const Gap(20),
            ],
          ),
          // controller.indexingWidget(
          SliderTheme(
            data: const SliderThemeData(trackHeight: 20),
            child: Slider(
              activeColor: Colors.white,
              thumbColor: Colors.red,
              inactiveColor: Colors.black26,
              onChanged: (v) {},
              max: double.parse(pageVideoPlayerController
                  .controller.player.state.duration.inSeconds
                  .toString()),
              value: double.parse(
                pageVideoPlayerController
                    .controller.player.state.position.inSeconds
                    .toString(),
              ),
            ),
          ),
          // 0.4)
        ],
      );
    });
  }

  Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 3000));
  onTvKeyClick(RawKeyEvent event) async {
    if (tvVideoPlayerController.isUpdating) return;
    tvVideoPlayerController.isUpdating = true;

    tvVideoPlayerController.onShow();
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      tvVideoPlayerController.onRightClick();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      tvVideoPlayerController.onBottomClick();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      tvVideoPlayerController.onLeftlick();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      tvVideoPlayerController.onTopClick();
      // } else if (event.logicalKey == LogicalKeyboardKey.pres) {
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.select) {
      tvVideoPlayerController.onSelect();
    }

    await tvVideoPlayerController.onFinalChecker();

    await Future.delayed(const Duration(milliseconds: 200));
    tvVideoPlayerController.isUpdating = false;

    debouncer(() => tvVideoPlayerController.onHide());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<NewPageVideoPlayerController>(builder: (cont) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            // Use [Video] widget to display video output.

            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: onTvKeyClick,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MaterialVideoControlsTheme(
                    normal: MaterialVideoControlsThemeData(
                        seekBarMargin: const EdgeInsets.only(
                            bottom: 30, left: 20, right: 20),
                        bottomButtonBarMargin: const EdgeInsets.only(
                            bottom: 40, left: 20, right: 20),
                        brightnessGesture: true,
                        volumeGesture: true,
                        seekBarThumbSize: 20,
                        seekBarHeight: 10,
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
                      seekBarThumbSize: 20,
                      seekBarHeight: 10,

                      seekBarMargin: const EdgeInsets.only(
                          bottom: 30, left: 20, right: 20),
                      bottomButtonBarMargin: const EdgeInsets.only(
                          bottom: 40, left: 20, right: 20),

                      topButtonBar: TopButtonBar().topButtonBar(
                          pageVideoPlayerController.baseVideo?.title ?? "",
                          pageVideoPlayerController.addtionTitle),
                      // topButtonBar: TopButtonBar().topButtonBar,
                      bufferingIndicatorBuilder: (context) {
                        return const AppLoadingWidget();
                      },
                      bottomButtonBar:
                          BottomBarButtons().buttonBarVideoPlayer(context),
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
                  LayoutBuilder(builder: (context, constraint) {
                    if (constraint.maxWidth < 600) {
                      return const SizedBox();
                    }
                    return onStackPlayer();
                  })
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
