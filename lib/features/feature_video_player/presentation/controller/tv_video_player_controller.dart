import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:media_kit_video/media_kit_video.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart'
    // ignore: library_prefixes
    as videoModel;
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_play_list/domain/usecases/play_list_usecase.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/new_video_player_controller.dart';
// import 'package:movie_chi/';

class TvVideoPlayerController extends GetxController {
  final VideoController _videoController;

  TvVideoPlayerController(
      {required VideoController videoController,
      required PlayListUseCase playListUseCase,
      required this.videoDetail})
      : _videoController = videoController,

        // _videoDetail = videoDetail,
        super();

  final videoModel.Video videoDetail;
  changeWidgetStatus(String widgetID) async {
    // widgetStatus = true;
    update([widgetID]);

    await Future.delayed(const Duration(seconds: 1), () {});
    update([widgetID]);
  }

  @override
  void onReady() {
    //

    // loadPlayListData(videoDetail: videoDetail);
    // if
    super.onReady();
  }

  double itemIndex = 10;

  Widget indexingWidget(Widget widget, double index) {
    return GetBuilder<TvVideoPlayerController>(
      builder: (controller) {
        return Material(
          color: Colors.transparent,
          child: Container(
            padding: index == controller.itemIndex
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                : null,
            // width:  widget.toString().length * 10,
            decoration: BoxDecoration(
              // color: index == controller.itemIndex ? Colors.red : null,
              border: index == controller.itemIndex
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(child: widget),
          ),
        );
      },
    );
  }

  onRightClick() {
    itemIndex = itemIndex + 0.01;
  }

  onLeftlick() {
    itemIndex = itemIndex - 0.01;
  }

  onBottomClick() {
    itemIndex = itemIndex + 0.02;
  }

  onTopClick() {
    if (itemIndex > 1.0) {
      itemIndex = 0.01;
    } else {
      itemIndex = itemIndex - 0.01;
    }
  }

  // Reverse function to get the real item from a given index
  List<int> getEpisoidFromIndex(SessionModel sessionModel, int index) {
    int count = 0;
    for (var element in sessionModel.data!) {
      for (int i = 0; i < element.episoids!.length; i++) {
        if (count == index) {
          return [count, i];
        }
        count++;
      }
    }
    throw Exception("Index out of range");
  }

  listViewClicked() async {
    final newPageVideoPlayerController =
        Get.find<NewPageVideoPlayerController>();
    int index = int.parse(formatNumber(
        int.parse(itemIndex.toStringAsFixed(2).toString().split(".")[1])));
    itemIndex = 0.00;
    update();
    debugPrint(newPageVideoPlayerController.eposiod[index].title);

    // NewPageVideoPlayerController pageVideoPlayerController =
    //     Get.find<NewPageVideoPlayerController>();
    // // pageVideoPlayerController.controller.player.open
    // List episodIndex = getEpisoidFromIndex(playListModel!, index);

    // Eposiod eposiod = playListModel!.data![episodIndex[0]];
    // pageVideoPlayerController.player.open(
    //   Media(eposiod.episoids?[episodIndex[1]].quality1080 ?? ""),
    // );
    newPageVideoPlayerController.player.jump(index);
  } //todo: implement this function

  onSelect() {
    if (itemIndex >= 1) {
      listViewClicked();
    } else {
      switch (itemIndex.toString()) {
        case "0.0": //back button
          Get.back();
          break;

        case "0.01": //forward button
          back10Second();
          break;

        case "0.02": //play or pause button
          playOrPause();
          break;
        case "0.03": //backward button
          next10Second();
          break;
        default:
      }
    }
  }

  String formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  ScrollController scrollController = ScrollController();
  changeListViewIndex() {
    // get the index of the current item after . of itemIndex value
    int index = int.parse(formatNumber(
        int.parse(itemIndex.toStringAsFixed(2).toString().split(".")[1])));

    if (prevItemIndex < itemIndex) {
      scrollController.animateTo(
        index * 320.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      scrollController.animateTo(
        (index * 320.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  double prevItemIndex = 0.0;

  onFinalChecker() async {
    if (itemIndex > 0.03 && prevItemIndex < 1.0 && itemIndex < 1.0) {
      itemIndex = 1.0;
    } else if (itemIndex < 1.0 && prevItemIndex > 0.03) {
      itemIndex = 0.03;
    }
    if (itemIndex < 0.0) {
      itemIndex = 0.0;
    }
    if (itemIndex >= 1.0) {
      changeListViewIndex();
    }

    if (videoDetail.type == "video" && itemIndex > 0.03) {
      itemIndex = 0.03;
    }

    // convert double to as string as first 2 digit
    String itemIndexString = itemIndex.toStringAsFixed(2);
    itemIndex = double.parse(itemIndexString);

    update();

    prevItemIndex = itemIndex;
  }

  bool isUpdating = false;

  onShow() {
    if (itemIndex == 10) {
      itemIndex = 0.02;
      update();
    }
  }

  onHide() {
    itemIndex = 10;
    update();
  }

  // bool foraward10 = false;
  next10Second() async {
    _videoController.player.seek(
        _videoController.player.state.position + const Duration(seconds: 10));

    await changeWidgetStatus('forward');
  }

  // bool back10 = false;
  back10Second() async {
    _videoController.player.seek(
        _videoController.player.state.position - const Duration(seconds: 10));
  }

  playOrPause() {
    if (_videoController.player.state.playing) {
      _videoController.player.pause();
    } else {
      _videoController.player.play();
    }
  }
}
