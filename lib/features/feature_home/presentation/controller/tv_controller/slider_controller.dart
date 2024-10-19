import 'dart:async';

import 'package:get/get.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/params/play_list_params.dart';
import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/loading_utils.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_detail_page/domain/usecases/video_detail_usecase.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/play_section_section.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_play_list/domain/usecases/play_list_usecase.dart';
import 'package:movie_chi/locator.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AndroidTVSliderController extends GetxController {
  int maxItem = 0;
  double val = 0.1;
  int pageIndex = 0;

  double itemIndex = 0.0;
  bool isUpdating = false;

  List<HomeItemData> listVieos;
  final PlayListUseCase _playListUseCase;

  AndroidTVSliderController(this.listVieos, this._playListUseCase);
  SearchVideo sliderVideo = SearchVideo();
  bool tryStopping = false;

  VideoDetailUseCase videoDetailUseCase = locator();

  @override
  void onInit() {
    super.onInit();

    changeVideo(listVieos[0], withStop: false);
  }

  changeVideo(HomeItemData item, {bool withStop = false}) {
    if (withStop == true) {
      tryStopping = true;
    }
    sliderVideo = SearchVideo.fromJson(
      item.toJson(),
    );
    update(['slider']);
  }

  changeVideoBySearchVideo(SearchVideo item, {bool withStop = false}) {
    if (withStop == true) {
      tryStopping = true;
    }
    sliderVideo = item;
    update(['slider']);
  }

  LoadingUtils loadingUtils = LoadingUtils(Get.context!);

  playVideo(SearchVideo homeItemData) async {
    loadingUtils.startLoading();

    Video? v = await getFullVideo(homeItemData.tag ?? "");
    if (v != null) {
      loadingUtils.stopLoading();
      if (homeItemData.type == "video") {
        playerIcons(v);
        // Constants.openVideoPlayer(v);
      } else {
        await checkUserStatus(() async {
          await loadPlayListData(videoDetail: homeItemData, withLoad: false);
          List<EpisoidsData> episoids = playListModel!.data!.fold([],
              (previousValue, element) => previousValue + element.episoids!);
          Constants.openVideoPlayer(
            v,
            episoidList: episoids,
            episoidIndex: 0,
          );
        }, () {}, v);
      }
    }
  }

  Future<Video?> getFullVideo(String vidTag) async {
    DataState dataState = await videoDetailUseCase.getVideoDetail(
        vidTag, GetStorageData.getData("user_tag"));

    if (dataState is DataSuccess) {
      Video video = dataState.data;
      return video;
    } else {
      return null;
    }
  }

  @override
  void onReady() {
    super.onReady();

    maxItem = listVieos.length;

    // changeVideo(listVieos[0]);

    // Set the initial value of the slider
    update(['slider']);

    // Listen to the slider value changes
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // print(tryStopping);
      if (tryStopping == true) {
        timer.cancel();
      }
      if (val >= 1) {
        pageIndex = pageIndex == (maxItem - 1) ? 0 : pageIndex + 1;
        update();
        val = 0.0;
      }
      val += 0.001;

      changeVideo(listVieos[pageIndex]);
      update(['slider']);
    });
  }

  PageStatus serialStatus = PageStatus.loading;
  SessionModel? playListModel;

  loadPlayListData(
      {required SearchVideo videoDetail, bool withLoad = false}) async {
    int amount = 0;
    List videoIDS = [];
    // if (playListModel != null && playListModel!.data!.isNotEmpty) {
    //   videoIDS = convertModelToListIds(playListModel ?? SessionModel());
    // }

    if (withLoad == false) {
      amount = 1000;
      serialStatus = PageStatus.loading;
      update();
    } else {
      amount += 10000;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    DataState dataState = await _playListUseCase.getSessionPlaylist(
        PlayListParams(
            version: packageInfo.version,
            playListId: videoDetail.commonTag ?? "",
            playListType: videoDetail.type ?? "",
            keyWord: videoDetail.commonTag ?? "",
            videoIds: videoIDS.toString(),
            amount: amount));
    if (dataState is DataSuccess) {
      SessionModel playListModel2 = dataState.data;

      // if (playListModel == null) {
      playListModel = playListModel2;
      // print(playListModel2.data!);
      // } else {
      // playListModel.data!.addAll(playListModel2.data!);
      // }

      serialStatus = PageStatus.success;
    } else if (dataState is DataFailed) {
      serialStatus = PageStatus.error;
    }

    // loadingUtils.stopLoading();
    update();
  }
}
