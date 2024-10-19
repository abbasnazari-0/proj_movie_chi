// igFeatureNewVideoPlayerore_for_file: unused_field, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/core/utils/episod_converter.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_video_player/domain/usecases/video_player_usecase.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/video_player_view_controller.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../../../core/utils/database_helper.dart';
import '../../../../locator.dart';
// ignore: library_prefixes
import '../../../feature_detail_page/data/model/video_model.dart' as videoModel;
import '../../../feature_home/presentation/controller/home_page_controller.dart';
import 'setting_controller.dart';

class NewPageVideoPlayerController extends GetxController {
  bool isFullScreen = false;
  final homePageController = Get.find<HomePageController>();
  bool showControllerStatus = false;
  bool playMode = true;
  videoModel.Video videoArguman = Get.arguments['data'];
  String? cutomLink = Get.arguments['custom_link'];
  String? addtionTitle = Get.arguments['addition_title'];
  VideoState? videoState;

  late final player = Player();

  // Create a [VideoController] to handle video output from [Player].
  late final controller =
      VideoController(player, configuration: VideoControllerConfiguration());

  // MeeduPlayerController controller = MeeduPlayerController(
  //   errorText: "خطا در پخش ویدیو",
  //   enabledButtons: const EnabledButtons(
  //     muteAndSound: false,
  //     playBackSpeed: false,
  //   ),
  //   controlsStyle: ControlsStyle.primary,
  //   enabledOverlays: const EnabledOverlays(),
  //   screenManager: const ScreenManager(),
  //   customCallbacks: const CustomCallbacks(),
  // );
  Future<void>? initializeVideoPlayerFuture;

  final VideoPlayerUseCase videoPlayerUseCase;

  int captionDelayTime = 0;
  videoModel.Video? baseVideo;
  String? localPath;
  bool isPlayerLocked = false;
  int playSecound = 0;
  int lastSecound = 0;
  final List<EpisoidsData> eposiod = Get.arguments['episoids'];
  int episoidIndex = Get.arguments['edpisoid_index'];

  DictionaryDataBaseHelper dbHelper = locator();

  NewPageVideoPlayerController(this.videoPlayerUseCase);
  List<Map> viewedStatus = [];
  Map lastSentToServer = {"vid_time": "0", "timestamp": "0"};

  String? videoUrl;
  String? caption;
  changeDataSource(bool? autoPlay, int? seekTo) async {
    // if (play.length == 1) {
    await player.open(Media(videoUrl ?? ""));
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
      controller.player.pause();

      // controller?.removeListener(() {});
      changeShowControllerStatus(false);
    }

    update();
  }

  backwardAndForward(double value) async {
    Duration videoDuration = controller.player.state.position;
    Duration newDuration = videoDuration + Duration(seconds: value.toInt());
    controller.player.seek(newDuration);
    showControllerStatus = true;
    await controller.player.play();
    update();
  }

  seekTo(double value) async {
    Duration videoDuration = controller.player.state.duration;
    // ignore: unused_local_variable
    Duration newDuration = videoDuration * value;
    playMode = true;
    await controller.player.play();
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
    return printDuration(controller.player.state.duration);
  }

  getVideoPositionValue() {
    return printDuration(controller.player.state.position);
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  chnageSliderPosision(double value) async {
    await controller.player.seek(Duration(seconds: value.toInt()));

    playMode = true;
    await controller.player.play();
    update();
  }

  double getSliderPosision() {
    return controller.player.state.position.inSeconds.toDouble();
  }

  double getDurationForSlider() {
    return controller.player.state.duration.inSeconds.toDouble();
  }

  @override
  void dispose() {
    controller.player.dispose();
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
          m['vid_time'] = controller.player.state.position.inSeconds;
          m['vid_duration'] = controller.player.state.duration.inSeconds;
          m['timestamp'] = DateTime.now().millisecondsSinceEpoch;
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        lst.add({
          "vid_time": controller.player.state.position.inSeconds,
          "vid_duration": controller.player.state.duration.inSeconds,
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

  showCoinHalf() async {
    await showDialog(
        barrierColor: Colors.black45,
        context: Get.context!,
        builder: (context) {
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
    // if (localPath == null) checkLastSession();

    // reportPlaye("video", viewedStatus, baseVideo!.tagData!);
    // sleep(Duration(seconds: 5));

    playeListConfigure();
  }

  playeListConfigure() {
    // if (play.length == 1) {

    if (eposiod.isNotEmpty) {
      player.open(
        Playlist(eposiod.map((e) => Media(getVideoUrlFromEdpisod(e))).toList(),
            index: episoidIndex),
      );
    } else {
      videoUrl = cutomLink ?? getVideoUrl(baseVideo!);
      player.open(Media(videoUrl ?? ""));
    }

    // } else {
    //   for (var i = 0; i < widget.play.length; i++) {
    //     Media media = Media(widget.play[i]);
    //     player.open(media);
    //   }
    // }
  }

  checkLastSession() async {
    if (baseVideo != null &&
        baseVideo?.lastSessionTime != null &&
        int.parse(baseVideo!.lastSessionTime!) > 0) {
      await controller.player.pause();
      await Get.dialog(
        Material(
            color: Colors.transparent,
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: MediaQuery.of(Get.context!).size.width * 0.1,
              //   vertical: MediaQuery.of(Get.context!).size.height * 0.3,
              // ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(Get.context!).primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/lotties/4946-coin.json", height: 40),
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
                  // const Spacer(
                  //   flex: 5,
                  // ),
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
                          Duration duration = controller.player.state.duration;
                          if (duration.inSeconds > 0) {
                            Get.back();

                            chnageSliderPosision(0);

                            // controller.play();
                            reportPlaye(baseVideo!.tag!, viewedStatus,
                                baseVideo!.tagData!);

                            dbHelper.query(
                                "DELETE FROM tbl_history WHERE `tag` = '${baseVideo!.tag}'");
                          } else {
                            showdLastSeen = true;
                            Get.back();
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
            )),
        barrierColor: Colors.transparent,
      );
    } else {
      await controller.player.play();
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
    controller.player.stream.playlist.listen((event) {
      // chnage episod
      if (episoidIndex != controller.player.state.playlist.index) {
        // videoState?.update();
        videoModel.Video video = episoidToVideo(
            eposiod[controller.player.state.playlist.index],
            baseVideo ?? videoModel.Video());
        baseVideo = video;
        episoidIndex = controller.player.state.playlist.index;
        update();

        videoState?.refreshView();
      }
    });

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

    videoPlaying();

    // hide status bar and navigation bar
    // screenUtils();

    // showAd();
    // viewController.subtitleLoader(baseVideo?.qualitiesId ?? "");

    update();
  }

  bool showdLastSeen = false;
  videoPlaying() async {
    videoUrl = cutomLink ?? getVideoUrl(baseVideo!);

    // controller.onShowControlsChanged.listen((event) {
    //   viewController.toggleWaterMark(!event);
    // });
    // controller.player.stream.
    // pageVideoPlayerController.controller.onClosedCaptionEnabled(true);

    controller.player.play();

    // set custom caption

    controller.player.stream.position.listen((event) {
      // if  start video and last seen is not 0
      if (event.inSeconds > 0 && lastSeen != 0 && showdLastSeen == false) {
        showdLastSeen = true;
        controller.player.seek(Duration(seconds: lastSeen));
      }

      if (lastSecound == event.inSeconds) {
      } else {
        lastSecound = event.inSeconds;
        playSecound = playSecound + 1;
        // debugPrint("watched time is ${event.inSeconds}");
      }

      int currentTimeInSeconds = event.inSeconds;
      viewedStatus
          .addIf(currentTimeInSeconds > 0 && currentTimeInSeconds % 10 == 0, {
        "vid_time": currentTimeInSeconds.toString(),
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
      viewedStatus = removeDuplicates(viewedStatus);
      reportEvery1Minute();
    });
  }
}
