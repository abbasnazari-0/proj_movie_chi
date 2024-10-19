import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/config/text_theme.dart';

class PlayerIOSScreen extends StatefulWidget {
  const PlayerIOSScreen({super.key, required this.url});

  final String url;

  @override
  State<PlayerIOSScreen> createState() => _PlayerIOSScreenState();
}

class _PlayerIOSScreenState extends State<PlayerIOSScreen> {
  late VideoController videoController;
  late final player = Player();

  @override
  void initState() {
    super.initState();
    debugPrint(widget.url);
    videoController = VideoController(player,
        configuration: const VideoControllerConfiguration());
    player.open(Media(
      widget.url,
    ));
  }

  @override
  void dispose() {
    player.dispose();
    // videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialVideoControlsTheme(
        normal: const MaterialVideoControlsThemeData(
          seekBarMargin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          bottomButtonBarMargin:
              EdgeInsets.only(bottom: 40, left: 20, right: 20),
          brightnessGesture: true,
          volumeGesture: true,
          // topButtonBar: TopButtonBar().topButtonBar(
          //     pageVideoPlayerController.baseVideo?.title ?? "",
          //     pageVideoPlayerController.addtionTitle),
          // bufferingIndicatorBuilder: (context) {
          //   return const AppLoadingWidget();
          // },
          // bottomButtonBar: BottomBarButtons().buttonBarVideoPlayer(context)),
        ),
        fullscreen: const MaterialVideoControlsThemeData(
          brightnessGesture: true,
          volumeGesture: true,
          seekBarMargin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          bottomButtonBarMargin:
              EdgeInsets.only(bottom: 40, left: 20, right: 20),

          // topButtonBar: TopButtonBar().topButtonBar(
          //     pageVideoPlayerController.baseVideo?.title ?? "",
          //     pageVideoPlayerController.addtionTitle),
          // topButtonBar: TopButtonBar().topButtonBar,
          // bufferingIndicatorBuilder: (context) {
          //   return const AppLoadingWidget();
          // },
          // bottomButtonBar: BottomBarButtons().buttonBarVideoPlayer(context),
        ),
        child:
            // pageVideoPlayerController.videoState = state;
            Video(
          controller: videoController,
          wakelock: true,

          subtitleViewConfiguration: SubtitleViewConfiguration(
            textScaleFactor: 1.1,
            style: faTextTheme(context),
            textAlign: TextAlign.center,
            padding: const EdgeInsets.all(24.0),
          ),

          pauseUponEnteringBackgroundMode: false,
          resumeUponEnteringForegroundMode: true,
          // controls: (state) {
          // pageVideoPlayerController.videoState = state;
        ));
  }
}
