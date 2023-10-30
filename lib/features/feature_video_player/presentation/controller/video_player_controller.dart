// ignore_for_file: unused_field, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_video_player/domain/usecases/video_player_usecase.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/video_player_view_controller.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/feature_video_player.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../../../core/utils/database_helper.dart';
import '../../../../locator.dart';
import '../../../feature_detail_page/data/model/video_model.dart';
import '../../../feature_home/presentation/controller/home_page_controller.dart';

class PageVideoPlayerController extends GetxController {
  bool isFullScreen = false;
  final homePageController = Get.find<HomePageController>();
  bool showControllerStatus = false;
  bool playMode = true;
  Video videoArguman = Get.arguments['data'];
  String? cutomLink = Get.arguments['custom_link'];

  MeeduPlayerController controller = MeeduPlayerController(
    errorText: "خطا در پخش ویدیو",
    enabledButtons: const EnabledButtons(
      muteAndSound: false,
      playBackSpeed: false,
    ),
    controlsStyle: ControlsStyle.primary,
    enabledOverlays: const EnabledOverlays(),
    screenManager: const ScreenManager(),
    customCallbacks: const CustomCallbacks(),
  );
  Future<void>? initializeVideoPlayerFuture;

  final VideoPlayerUseCase videoPlayerUseCase;

  int captionDelayTime = 0;
  Video? baseVideo;
  String? localPath;
  bool isPlayerLocked = false;
  int playSecound = 0;
  int lastSecound = 0;
  final List<EpisoidsData> eposiod = Get.arguments['episoids'];
  int episoidIndex = Get.arguments['edpisoid_index'];

  DictionaryDataBaseHelper dbHelper = locator();

  PageVideoPlayerController(this.videoPlayerUseCase);
  List<Map> viewedStatus = [];
  Map lastSentToServer = {"vid_time": "0", "timestamp": "0"};

  String? videoUrl;
  String? caption;
  changeDataSource(bool? autoPlay, int? seekTo) {
    controller.setDataSource(
        DataSource(
            type: DataSourceType.network,
            closedCaptionFile:
                caption != null ? loadCaptions(caption ?? "") : null,
            source: videoUrl ?? ""),
        seekTo: Duration(seconds: seekTo ?? 0),
        autoplay: autoPlay ?? true);
  }

  Future<ClosedCaptionFile> loadCaptions(String text) async {
    // you can get the fileContents as string from a remote str file using a http client like dio or http
    // or you can load from assets
    /*
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/captions.srt');
    */
    // in srt format
    return SubRipCaptionFile(text);
  }

  List<Map> removeDuplicates(List<Map> list) {
    List<Map> uniqueList = [];

    for (Map item in list) {
      String timestamp = item["vid_time"];
      int index = -1;
      for (int i = 0; i < uniqueList.length; i++) {
        if (uniqueList[i]["vid_time"] == timestamp) {
          index = i;
          break;
        }
      }
      if (index == -1) {
        uniqueList.add(item);
      } else {
        uniqueList[index] = item;
      }
    }

    return uniqueList;
  }

  changePlayerLockedStatus(bool status) {
    isPlayerLocked = status;
    update();
  }

  void changeShowControllerStatus(bool status) {
    showControllerStatus = status;
    update();
    if (showControllerStatus == true) {
      if (playMode == true) {
        Future.delayed(const Duration(seconds: 3), () {
          // showControllerStatus = false;
          // update();
        });
      } else {
        // showControllerStatus = true;
        // update();
      }
    }
  }

  chnagePlayMode() {
    playMode = !playMode;

    if (playMode == true) {
      // controller.play();
      // controller?.addListener(() {
      //   posisionController();
      // });
      changeShowControllerStatus(true);
    } else {
      controller.pause();
      // controller?.removeListener(() {});
      changeShowControllerStatus(false);
    }

    update();
  }

  posisionController() {
    update();
  }

  backwardAndForward(double value) async {
    Duration videoDuration = controller.position.value;
    Duration newDuration = videoDuration + Duration(seconds: value.toInt());
    controller.seekTo(newDuration);
    showControllerStatus = true;
    await controller.play();
    update();
  }

  seekTo(double value) async {
    Duration videoDuration = controller.duration.value;
    // ignore: unused_local_variable
    Duration newDuration = videoDuration * value;
    playMode = true;
    await controller.play();
    update();
  }

//  create function to convert duration to secound
  convertPositionToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  getVideoDuration() {
    return printDuration(controller.duration.value);
  }

  getVideoPositionValue() {
    return printDuration(controller.position.value);
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  chnageSliderPosision(double value) async {
    await controller.seekTo(Duration(seconds: value.toInt()));

    playMode = true;
    await controller.play();
    update();
  }

  double getSliderPosision() {
    return controller.position.value.inSeconds.toDouble();
  }

  double getDurationForSlider() {
    return controller.duration.value.inSeconds.toDouble();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Report Section For Analyze -------------------------------------------------

  reportPlaye(
      String videoTag, List<Map> viewStatus, List<String> vedioTag) async {
    await videoPlayerUseCase.playVideoReport(
        videoTag, "video", viewStatus, vedioTag);
  }

  reportEvery1Minute() async {
    if (viewedStatus.isNotEmpty &&
        int.parse(viewedStatus[viewedStatus.length - 1]['vid_time']) >=
            int.parse(lastSentToServer['vid_time']) + 30) {
      // print ready to sent every 30 secound" with green color
      reportPlaye(baseVideo!.tag!, viewedStatus, baseVideo!.tagData!);

      bool inserted = false;

      List lst_ = await dbHelper.getQuery("tbl_history",
          where: "tag", whereValue: "${baseVideo!.tag}");
      List lst = lst_.isEmpty ? [] : json.decode(lst_[0]['data']);
      for (Map m in lst) {
        if (m['tag'] == baseVideo!.tag) {
          m['vid_time'] = controller.position.value.inSeconds;
          m['vid_duration'] = controller.duration.value.inSeconds;
          m['timestamp'] = DateTime.now().millisecondsSinceEpoch;
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        lst.add({
          "vid_time": controller.position.value.inSeconds,
          "vid_duration": controller.duration.value.inSeconds,
          "tag": baseVideo!.tag,
          "vid_id": baseVideo!.id ?? "0",
          "image": baseVideo!.thumbnail1x!,
          "title": baseVideo!.title!,
        });
      }

      // remove duplicates
      dbHelper
          .query("DELETE FROM tbl_history WHERE `tag` = '${baseVideo!.tag}'");

      dbHelper.addQuery(
          "tag, data, video_detail",
          "'${baseVideo!.tag}', '${json.encode(lst).replaceAll("'", '"')}', '${json.encode(baseVideo?.toJson()).replaceAll("'", '"')}'",
          "tbl_history");

      homePageController.hasDataInLocalStorage();

      lastSentToServer['vid_time'] = viewedStatus[viewedStatus.length - 1]
          ['vid_time']; // update last sent to server
      lastSentToServer['timestamp'] = viewedStatus[viewedStatus.length - 1]
          ['timestamp']; // update last sent to server
    }
  }

  late Timer _timer;

  showCoinHalf() async {
    await showDialog(
        barrierColor: Colors.black45,
        context: Get.context!,
        builder: (context) {
          _timer = Timer(const Duration(seconds: 5), () {
            try {
              Navigator.of(context).pop();
            } catch (e) {
              debugPrint(e.toString());
            }
          });
          return Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(Get.context!).size.width * 0.1,
                vertical: MediaQuery.of(Get.context!).size.height * 0.1,
              ),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Theme.of(Get.context!).primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/lotties/4946-coin.json", height: 80),
                  const SizedBox(height: 10),
                  const MyText(
                      txt: "مووی چی! نیم بها",
                      size: 20,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  const MyText(
                      txt:
                          "ترافیک مصرفی شما در اپلیکیشن مووی چی! با نصف قیمت محاسبه می شود",
                      textAlign: TextAlign.center,
                      size: 15),

                  // button ok
                  const SizedBox(height: 10),
                  // const Spacer(),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(Get.context!).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      child: const Center(
                        child: MyText(
                          txt: "باشه",
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  // sleep(Duration(seconds: 5));
  // Get.back();

  //  when page is opened
  @override
  void onReady() {
    // show dialog with 5 secound about "Your traffic consumption is calculated at half price in Cinema app"
    if (localPath == null) checkLastSession();

    // reportPlaye("video", viewedStatus, baseVideo!.tagData!);
    // sleep(Duration(seconds: 5));
  }

  checkLastSession() async {
    if (baseVideo != null &&
        baseVideo?.lastSessionTime != null &&
        int.parse(baseVideo!.lastSessionTime!) > 0) {
      await controller.pause();
      await showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(Get.context!).size.width * 0.01,
                  vertical: MediaQuery.of(Get.context!).size.height * 0.3,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(Get.context!).primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Lottie.asset(
                        "assets/lotties/4946-coin.json",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const MyText(
                      txt: "اخرین پخش",
                      size: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MyText(
                      txt:
                          "شما این فیلم را تا ${formatTime(int.parse(baseVideo!.lastSessionTime!))} دیده اید",
                      textAlign: TextAlign.center,
                      size: 15,
                    ),

                    // button ok
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    const Spacer(
                      flex: 5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const MyText(
                      txt: "لطفا لحظاتی صبر کنید",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            // if (controller.dataStatus.loaded) {
                            // check video duration
                            // if (controller.duration.controller. >

                            Get.back();
                            chnageSliderPosision(
                                double.parse(baseVideo!.lastSessionTime!));
                          },
                          child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Theme.of(Get.context!).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            child: const Center(
                              child: MyText(
                                txt: "آخرین پخش",
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Duration duration = controller.duration.value;
                            if (duration.inSeconds > 0) {
                              Get.back();

                              chnageSliderPosision(0);

                              // controller.play();
                              reportPlaye(baseVideo!.tag!, viewedStatus,
                                  baseVideo!.tagData!);

                              dbHelper.query(
                                  "DELETE FROM tbl_history WHERE `tag` = '${baseVideo!.tag}'");
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Theme.of(Get.context!)
                                    .primaryColor
                                    .withAlpha(150),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            child: const Center(
                              child: MyText(
                                txt: "از اول",
                                size: 12,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      await controller.play();
    }

    // showCoinHalf();
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

  // function convert secound to readable duration
  String formatTime(int seconds) {
    int minutes = (seconds / 60).truncate();
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return "$formattedMinutes:$formattedSeconds";
  }

  final viewController =
      Get.put<VideoPlayerViewController>(VideoPlayerViewController(locator()));

  var lastSeen = 0;
  List lastView = [];
  Map lastViewMap = {};
  loadLastView() async {
    baseVideo = videoArguman;

    if (baseVideo?.tag != null) {
      List l = await dbHelper.getQuery("tbl_history",
          where: "tag", whereValue: baseVideo?.tag ?? "");
      if (l == null || l.isEmpty) {
        lastSeen = 0;
      } else {
        lastView = json.decode(l[0]['data']);
        if (lastView.isEmpty) {
          if (baseVideo?.lastSessionTime != null) {
            lastSeen = int.parse(baseVideo?.lastSessionTime ?? "0");
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
    viewController.subtitleLoader(baseVideo?.qualitiesId ?? "");

    update();
  }

  videoPlaying() async {
    controller.loadingWidget = Center(
        child: LoadingAnimationWidget.flickr(
      size: 50,
      leftDotColor: Get.theme.colorScheme.secondary,
      rightDotColor: Get.theme.colorScheme.background.withOpacity(0.5),
    ));

    // pageVideoPlayerController.controller.setFullScreen(true, context);
    // pageVideoPlayerController.controller.fullScreenWidget = Container();
    // pageVideoPlayerController.controller.customControls = Container();
    // pageVideoPlayerController.reportPlaye(pageVideoPlayerController.baseVideo?.tag, );

    videoUrl = cutomLink ?? getVideoUrl(baseVideo!);

    await controller.setDataSource(
        DataSource(type: DataSourceType.network, source: videoUrl),
        autoplay: true,
        seekTo: Duration(seconds: lastSeen));
    // ignore: use_build_context_synchronously
    // controller.toggleFullScreen(context);

    // pageVideoPlayerController.controller.erro = "خطا در پخش ویدیو";
    controller.onShowControlsChanged.listen((event) {
      viewController.toggleWaterMark(!event);
    });
    // pageVideoPlayerController.controller.onClosedCaptionEnabled(true);

    controller.play();

    // set custom caption
    controller.customCaptionView = (context, controller, responsive, string) {
      return CustomCaption(responsive: responsive, string: string);
    };

    controller.onPositionChanged.listen((event) {
      // if  start video and last seen is not 0
      if (event.inSeconds == 0 && lastSeen != 0) {
        controller.seekTo(Duration(seconds: lastSeen));
      }

      if (lastSecound == event.inSeconds) {
      } else {
        lastSecound = event.inSeconds;
        playSecound = playSecound + 1;
        debugPrint("watched time is ${event.inSeconds}");
      }

      int currentTimeInSeconds = event.inSeconds;
      viewedStatus
          .addIf(currentTimeInSeconds > 0 && currentTimeInSeconds % 10 == 0, {
        "vid_time": currentTimeInSeconds.toString(),
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
      viewedStatus = removeDuplicates(viewedStatus);
      reportEvery1Minute();
      //
    });
  }
}
