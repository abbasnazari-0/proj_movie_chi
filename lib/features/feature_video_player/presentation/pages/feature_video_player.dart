// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart' as iconsax;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/locator.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../../../core/ad/ad_controller.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/database_helper.dart';
import '../controller/video_player_controller.dart';
import '../controller/video_player_view_controller.dart';
import '../widgets/bottom_right_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/video_overly_widget.dart';

// // create function to check all videos url and return 720 quality video if not exist return 480 quality video and other

String getVideoUrl(Video video, {String? custom}) {
  if (custom != null) {
    return Constants.videoFiller(custom);
  }
  String url = "";
  if (video.quality1080 != null) {
    url = video.quality1080!;
  } else if (video.quality720 != null) {
    url = video.quality720!;
  } else if (video.quality480 != null) {
    url = video.quality480!;
  } else if (video.quality360 != null) {
    url = video.quality360!;
  } else if (video.quality240 != null) {
    url = video.quality240!;
  }
  return url;
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, this.isLocaled = false});

  final bool isLocaled;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final pageVideoPlayerController =
      Get.put(PageVideoPlayerController(locator()));
  final adController = Get.find<AdController>();
  final viewController = Get.put(VideoPlayerViewController(locator()));
  bool isFullScreen = false;

  showAd() async {
    await adController.adInitilzer?.loadInterstitial();
    await adController.adInitilzer?.showRewarded();
  }

  var playerCustomIcons = const CustomIcons(
    play: Icon(iconsax.Iconsax.play),
    pause: Icon(iconsax.Iconsax.pause),
    fastForward: Icon(iconsax.Iconsax.forward_10_seconds4),
    rewind: Icon(iconsax.Iconsax.backward_10_seconds4),

    // videoFit: Icon(Iconsax.expand),
    fullscreen: Icon(iconsax.Iconsax.d_rotate4),
    minimize: Icon(iconsax.Iconsax.d_rotate4),
    videoFit: Icon(iconsax.Iconsax.maximize_34),
    pip: Icon(iconsax.Iconsax.screenmirroring4),
    repeat: Icon(iconsax.Iconsax.repeat),
  );

  var lastSeen = 0;

  @override
  void initState() {
    super.initState();

    loadLastView();
  }

  DictionaryDataBaseHelper dbHelper = locator();

  List lastView = [];
  Map lastViewMap = {};
  loadLastView() async {
    pageVideoPlayerController.baseVideo = Get.arguments["data"];
    if (Get.arguments["path"] != null) {
      pageVideoPlayerController.localPath = Get.arguments["path"];
    }

    if (pageVideoPlayerController.baseVideo?.tag != null) {
      List l = await dbHelper.getQuery("tbl_history",
          where: "tag",
          whereValue: pageVideoPlayerController.baseVideo?.tag ?? "");
      if (l == null || l.isEmpty) {
        lastSeen = 0;
      } else {
        lastView = json.decode(l[0]['data']);
        if (lastView.isEmpty) {
          if (pageVideoPlayerController.baseVideo?.lastSessionTime != null) {
            lastSeen = int.parse(
                pageVideoPlayerController.baseVideo?.lastSessionTime ?? "0");
          } else {
            lastSeen = 0;
          }
        } else {
          lastViewMap = lastView[lastView.length - 1];
          lastSeen = (lastViewMap['vid_time']);
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoPlaying();
    });

    // hide status bar and navigation bar
    screenUtils();

    // showAd();

    viewController
        .subtitleLoader(pageVideoPlayerController.baseVideo?.qualitiesId ?? "");
  }

  screenUtils() async {
    try {
      // hide status bar and navigation bar
      await StatusBarControl.setHidden(!isFullScreen);
      await StatusBarControl.setTranslucent(!isFullScreen);
      await StatusBarControl.setFullscreen(!isFullScreen);
      isFullScreen = !isFullScreen;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  videoPlaying() async {
    pageVideoPlayerController.controller.loadingWidget = Center(
        child: LoadingAnimationWidget.flickr(
      size: 50,
      leftDotColor: Get.theme.colorScheme.secondary,
      rightDotColor: Get.theme.colorScheme.background.withOpacity(0.5),
    ));

    // pageVideoPlayerController.controller.setFullScreen(true, context);
    // pageVideoPlayerController.controller.fullScreenWidget = Container();
    // pageVideoPlayerController.controller.customControls = Container();
    // pageVideoPlayerController.reportPlaye(pageVideoPlayerController.baseVideo?.tag, );

    if (widget.isLocaled) {
      await pageVideoPlayerController.controller.setDataSource(
        DataSource(
            type: DataSourceType.file,

            // source: localPath,
            file: File(pageVideoPlayerController.localPath!
                .replaceAll("file:///", "/"))),
        autoplay: true,
      );
    } else {
      pageVideoPlayerController.videoUrl = Get.arguments['custom_link'] ??
          getVideoUrl(pageVideoPlayerController.baseVideo!);

      await pageVideoPlayerController.controller.setDataSource(
          DataSource(
              type: DataSourceType.network,
              source: pageVideoPlayerController.videoUrl),
          autoplay: true,
          seekTo: Duration(seconds: lastSeen));
      // ignore: use_build_context_synchronously
      pageVideoPlayerController.controller.toggleFullScreen(context);

      // pageVideoPlayerController.controller.erro = "خطا در پخش ویدیو";
      pageVideoPlayerController.controller.onShowControlsChanged
          .listen((event) {
        viewController.toggleWaterMark(!event);
      });
      // pageVideoPlayerController.controller.onClosedCaptionEnabled(true);

      pageVideoPlayerController.controller.play();

      // set custom caption
      pageVideoPlayerController.controller.customCaptionView =
          (context, controller, responsive, string) {
        return CustomCaption(responsive: responsive, string: string);
      };

      pageVideoPlayerController.controller.onPositionChanged.listen((event) {
        // if  start video and last seen is not 0
        if (event.inSeconds == 0 && lastSeen != 0) {
          pageVideoPlayerController.controller
              .seekTo(Duration(seconds: lastSeen));
        }

        if (pageVideoPlayerController.lastSecound == event.inSeconds) {
        } else {
          pageVideoPlayerController.lastSecound = event.inSeconds;
          pageVideoPlayerController.playSecound =
              pageVideoPlayerController.playSecound + 1;
          debugPrint("watched time is ${event.inSeconds}");
        }

        int currentTimeInSeconds = event.inSeconds;
        pageVideoPlayerController.viewedStatus
            .addIf(currentTimeInSeconds > 0 && currentTimeInSeconds % 10 == 0, {
          "vid_time": currentTimeInSeconds.toString(),
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        });
        pageVideoPlayerController.viewedStatus = pageVideoPlayerController
            .removeDuplicates(pageVideoPlayerController.viewedStatus);
        pageVideoPlayerController.reportEvery1Minute();
        //
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // screenUtils();
    // pageVideoPlayerController.controller.pause();
    pageVideoPlayerController.controller.dispose();

    //  pageVideoPlayerController.controller.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<PageVideoPlayerController>(builder: (controllerrr) {
        return Stack(
          fit: StackFit.expand,
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: MeeduVideoPlayer(
                controller: pageVideoPlayerController.controller,
                videoOverlay: (context, controller, responsive) {
                  // add watermark in bottom righ
                  return VideoOverlyWidget(responsive: responsive);
                },
                header: (context, controller, responsive) => HeaderWidget(
                    pageVideoPlayerController: pageVideoPlayerController,
                    responsive: responsive),
                customIcons: (responsive) {
                  return playerCustomIcons;
                },
                bottomRight: (context, controller, responsive) {
                  return BottomRightWidget(
                      viewController: viewController,
                      pageVideoPlayerController: pageVideoPlayerController);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class CustomCaption extends StatelessWidget {
  const CustomCaption({
    Key? key,
    required this.string,
    required this.responsive,
  }) : super(key: key);
  final String string;
  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          decoration: BoxDecoration(
            color: string.isNotEmpty
                ? GetStorageData.getData("subtitleBackgroundColor_") ??
                    Colors.black.withAlpha(180)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyText(
            txt: string,
            color: GetStorageData.getData("subtitleColor_") ?? Colors.white,
            size: responsive.ip(double.parse(
                GetStorageData.getData("subtitleTextSize") ?? "2")),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
