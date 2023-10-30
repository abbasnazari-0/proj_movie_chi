// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/comment_model.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_detail_page/domain/usecases/video_detail_usecase.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/download_page_controller.dart';

import '../../../../core/ad/ad_controller.dart';
import '../../../../core/params/play_list_params.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../locator.dart';
import '../../../feature_home/presentation/controller/home_page_controller.dart';
import '../../../feature_play_list/data/model/session_playlist.dart';
import '../../../feature_play_list/domain/usecases/play_list_usecase.dart';
import '../../../feature_play_list/presentation/controller/play_list_controller.dart';
import '../../data/model/location_ip_model.dart';

class DetailPageController extends GetxController {
  final VideoDetailUseCase videoDetailUseCase;
  final PlayListUseCase playListuseCase;
  int sessionId = 0;
  String? vidTag;
  PageStatus detailPageStatus = PageStatus.loading;
  Video? videoDetail;
  ScrollController crewscrollController = ScrollController();
  List galleryList = [];
  DetailPageController(
      this.videoDetailUseCase, this.vidTag, this.playListuseCase);

  bool extendGallery = false;
  String galleryImageSelected = "";
  bool showCommentInput = true;
  List<CommentDataModel> commentList = [];
  ScrollController pageScrollController = ScrollController();
  TextEditingController userCommentController = TextEditingController();

  // suggestion View
  bool showSuggestionView = false;
  List<SearchVideo> suggestionList = [];
  ScrollController suggestionscrollController = ScrollController();
  final adController = Get.find<AdController>();
  // video bookmarked
  bool videoBookMarked = false;

  // video liked
  bool videoLiked = false;

  double? prog;
  bool isDownloading = false;
  double fileSize = 0.0;
  double downloadedSize = 0.0;
  String remaingTime = "";
  String taskID = '';
  CancelToken? taskIId = CancelToken();
  Video? video;

  String? placeholder;

  PageStatus serialStatus = PageStatus.loading;
  final playListController = Get.put(PlayListController(locator()));

  DictionaryDataBaseHelper dbHelper = locator();

  final homePageController = Get.find<HomePageController>();

  bool isVideoDownloaded = false;
  setVideoTag(vidTag) {
    this.vidTag = vidTag;
    onInit();
  }

  List homeVideoDownloaded = [];

  updateList() async {
    // videoDownloadedList = GetStorageData.getData("video_downloaded") ?? [];
    homeVideoDownloaded = await dbHelper.getQuery("tbl_downloaded");

    if (homeVideoDownloaded.isEmpty) return;
    await (removeUnfoundFile(homeVideoDownloaded));

    homeVideoDownloaded = await dbHelper.getQuery("tbl_downloaded");
    update();
  }

  // create function to check file exist
  Future<bool> checkFileExists(String filePath) async {
    File file = File(filePath);
    return await file.exists();
  }

  // remove unfound file from list
  removeUnfoundFile(List list) async {
    for (var item in list) {
      if (item['download_status'] == "true") {
        String? filePath = (item['download_path']);

        if (!await checkFileExists(filePath ?? '')) {
          await dbHelper.query(
              "DELETE FROM tbl_downloaded WHERE `tag` = '${item['tag']}' ");
        }
      }
    }
  }

  reorderDownloadedList() async {
    // List videoDownloadedList = GetStorageData.getData("video_downloaded") ?? [];
    List videoDownloadedList = await dbHelper.getQuery("tbl_downloaded");

    await (removeUnfoundFile(videoDownloadedList));

    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    sessionId = 0;
    playListModel = null;

    reorderDownloadedList();
    if (vidTag != null) checkVideoDownloaded(vidTag);
    if (vidTag != null) {
// set video tasks

      if (taskIId == null) {
        prog = null;
        isDownloading = false;
        fileSize = 0.0;
        downloadedSize = 0.0;
        remaingTime = "";
        taskID = '';
        taskIId = null;
        video = videoDetail;
      }

      detailPageStatus = PageStatus.loading;
      update();

      DataState dataState = await videoDetailUseCase.getVideoDetail(
          vidTag!, GetStorageData.getData("user_tag"));

      if (dataState is DataSuccess) {
        videoDetail = dataState.data;

        if (videoDetail?.galleryId != null) {
          // get gallery
          getVideoGallery(videoDetail!.galleryId!);

          // get comments
          getVideoComments(vidTag!);

          // get suggestions
          getVideoSuggestions(
              videoDetail!.tagData!.toString(), videoDetail!.tag!);

          // get bookmark status
          (int.parse(videoDetail!.userBookmarked!) > 0)
              ? videoBookMarked = true
              : videoBookMarked = false;

          // get like status
          (int.parse(videoDetail!.userLiked!) > 0)
              ? videoLiked = true
              : videoLiked = false;

          loadPlayList();

          // check video downloaded
        }

        detailPageStatus = PageStatus.success;
        update();
      }
      if (dataState is DataFailed) {
        if (dataState.error.toString().contains('not found')) {
          detailPageStatus = PageStatus.empty;
        } else {
          debugPrint(dataState.error);
          detailPageStatus = PageStatus.error;
        }
        update();
      }
    }
    adController.adInitilzer?.loadBanner();
  }

  loadPlayList() async {
    if (videoDetail?.type != "video") {
      // PlayListModel playListData = await playListController.loadPlayListData();
      playListId = videoDetail!.commonTag!;
      type = videoDetail!.type!;
      keyWord = videoDetail!.commonTag!;
      loadPlayListData();
    }
  }

  loadPlayListData({bool withLoad = false}) async {
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

    DataState dataState = await playListuseCase.getSessionPlaylist(
        PlayListParams(
            version: packageInfo.version,
            playListId: playListId,
            playListType: type,
            keyWord: keyWord,
            videoIds: videoIDS.toString(),
            amount: amount));
    if (dataState is DataSuccess) {
      SessionModel playListModel2 = dataState.data;

      if (playListModel == null) {
        playListModel = playListModel2;
      } else {
        playListModel!.data!.addAll(playListModel2.data!);
      }

      serialStatus = PageStatus.success;
    } else if (dataState is DataFailed) {
      serialStatus = PageStatus.error;
    }

    update();
  }

  String type = "";
  String playListId = "";
  int amount = 20;
  String keyWord = "";

  PageStatus pageStatus = PageStatus.loading;
  SessionModel? playListModel;

  // convertModelToListIds(PlayListModel playListModel) {
  //   List videoIDS = [];
  //   for (var element in playListModel.data!) {
  //     videoIDS.add(element.id);
  //   }
  //   return videoIDS;
  // }

  chnageSessionData(int sessionid) {
    sessionId = sessionid;
    update(["session"]);
  }

  getVideoGallery(String galleryId) async {
    DataState dataState = await videoDetailUseCase.getVideoGallery(galleryId);
    if (dataState is DataSuccess) {
      galleryList = dataState.data;
      update();
    }
    if (dataState is DataFailed) {
      // return dataState.error;
    }
  }

  onGalleryTap(imgName) {
    galleryImageSelected = imgName;
    update();
  }

  changeListViewView(bool extendedView) {
    extendGallery = extendedView;
    update();
  }

//  get comment list
  getVideoComments(String videoTags) async {
    commentList = [];
    DataState dataState = await videoDetailUseCase.getVideoComments(videoTags);
    if (dataState is DataSuccess) {
      commentList = dataState.data;

      update();
    }
    if (dataState is DataFailed) {
      // return dataState.error;
    }
  }

  onCommentTap(visible) {
    showCommentInput = visible;
    update();
  }

  PageStatus commentStatus = PageStatus.empty;

  submitComment() async {
    if (userCommentController.text.isNotEmpty) {
      commentStatus = PageStatus.loading;
      update();
      DataState dataState = await videoDetailUseCase.addVideoComments(
          videoDetail!.tag!,
          GetStorageData.getData("user_tag"),
          userCommentController.text);

      if (dataState is DataSuccess) {
        userCommentController.clear();
        showCommentInput = false;
        getVideoComments(videoDetail!.tag!);

        commentStatus = PageStatus.success;
        update();
      }
      if (dataState is DataFailed) {
        // return dataState.error;
        commentStatus = PageStatus.success;
        update();
      }
    }
  }

  @override
  void onClose() {
    crewscrollController.dispose();
    super.onClose();
  }

  // get video suggestions
  getVideoSuggestions(String videoTags, String selectvideoTags) async {
    DataState dataState = await videoDetailUseCase.getVideoSuggestions(
        videoTags.toString().replaceAll("[", "").replaceAll("]", ""),
        selectvideoTags);

    if (dataState is DataSuccess) {
      suggestionList = dataState.data;
      showSuggestionView = true;
      update();
    }
    if (dataState is DataFailed) {
      // return dataState.error;
    }
  }

  // submit bookmark
  void submitBookmark() async {
    DataState dataState = await videoDetailUseCase.submitBookmark(
        videoDetail!.tag!,
        GetStorageData.getData("user_tag"),
        videoBookMarked ? "remove" : "add");
    if (dataState is DataSuccess) {
      if (dataState.data == "removed") {
        videoBookMarked = false;
        // GetStorageData.writeData(
        //     "bookmark_saved",
        //     Map<String, dynamic>.from(
        //         GetStorageData.getData("bookmark_saved") ?? {})
        //       ..remove(videoDetail!.tag!));

        await dbHelper.query(
            "DELETE FROM tbl_bookmark WHERE `tag` = '${videoDetail!.tag}' ");
      } else {
        videoBookMarked = true;
        // GetStorageData.writeData(
        //     "bookmark_saved",
        //     Map<String, dynamic>.from(
        //         GetStorageData.getData("bookmark_saved") ?? {})
        //       ..addAll({videoDetail!.tag!: videoDetail!.toJson()}));

        dbHelper.addQuery(
            "tag, video_detail",
            "'${videoDetail!.tag}','${jsonEncode(videoDetail!.toJson()).replaceAll("'", '"')}'",
            "tbl_bookmark");
      }
      // videoDetail!.isBookmarked = true;
      update();
      homePageController.hasDataInLocalStorage();
    }
    if (dataState is DataFailed) {
      // return dataState.error;
    }
  }

  // submit like
  submitLike() async {
    DataState dataState = await videoDetailUseCase.submitLike(videoDetail!.tag!,
        GetStorageData.getData("user_tag"), videoLiked ? "remove" : "add");
    if (dataState is DataSuccess) {
      if (dataState.data == "removed") {
        videoLiked = false;

        await dbHelper.query(
            "DELETE FROM tbl_favorite WHERE `tag` = '${videoDetail!.tag}' ");

        // GetStorageData.writeData(
        //     "favorite_saved",
        //     Map<String, dynamic>.from(
        //         GetStorageData.getData("favorite_saved") ?? {})
        //       ..remove(videoDetail!.tag!));
      } else {
        videoLiked = true;

        dbHelper.addQuery(
            "tag, video_detail",
            "'${videoDetail!.tag}','${jsonEncode(videoDetail!.toJson()).replaceAll("'", '"')}'",
            "tbl_favorite");
        // GetStorageData.writeData(
        //     "favorite_saved",
        //     Map<String, dynamic>.from(
        //         GetStorageData.getData("favorite_saved") ?? {})
        //       ..addAll({videoDetail!.tag!: videoDetail!.toJson()}));
      }

      // videoDetail!.isLiked = true;
      update();
      homePageController.hasDataInLocalStorage();
    }
    if (dataState is DataFailed) {
      // return dataState.error;
    }
  }

  isallowToPlay() async {
    DataState data = await videoDetailUseCase.getLocationFromIp();

    if (data is DataSuccess) {
      LocationModel locationModel = data.data;
      if (locationModel.country == null) return false;

      if (locationModel.country?.toLowerCase() == "ir") {
        return true;
      } else {
        return false;
      }
    }
    if (data is DataFailed) {
      debugPrint(data.error);
    }
  }

  checkUSers() async {
    bool canSeeVide = await isallowToPlay();

    if (canSeeVide) {
      //launch mx

      GetStorageData.writeData("logined", true);
    } else {
      GetStorageData.writeData("logined", false);
    }
  }

  changeDetailData(String tag, String placeholder) {
    vidTag = tag;
    this.placeholder = placeholder;
    onInit();
  }

  changeProgressBarValue(
      double progress, double fileSize, double downloadedSize) {
    prog = progress;
    this.fileSize = fileSize;
    this.downloadedSize = downloadedSize;
    // remaingTime = formatDuration(Duration(
    //     seconds: (fileSize - downloadedSize) ~/ (downloadedSize / 100)));
    isDownloading = true;

    update();
  }

  updateStatus() {
    update();
  }

  cancellTaskDownlod() async {
    final downloadController = Get.find<DownloadPageController>();
    downloadController.cancelDownload();

    // FileDownloader().destroy();

    // Map taskElement =
    //     taskList.where((element) => element["tag"] == vidTag).first;
    // String taskID = this.taskID;
    // if (taskIId != null) {
    //   // FileDownloader().pause(taskIId!);
    // }

    // (await FileDownloader().cancelTaskWithId(taskID));

    // FileDownloader().destroy();

    isDownloading = false;

    // isDownloading = false;

    // progressbarValue = null;

    fileSize = 0.0;
    downloadedSize = 0.0;
    prog = null;
    remaingTime = "0:00";

    // remove element from video downloaded list
    // List videoDownloadedList = GetStorageData.getData("video_downloaded") ?? [];

    // videoDownloadedList.removeWhere((element) => element["tag"] == vidTag);

    // GetStorageData.writeData("video_downloaded", videoDownloadedList);

    reorderDownloadedList();
    // update();
  }

  checkVideoDownloaded(tag) async {
    List videoDownloadedList = await dbHelper.getDoubleQuery("tbl_downloaded",
        where: "tag",
        whereValue: tag,
        where2: "download_status",
        whereValue2: "true");

    if (videoDownloadedList.isNotEmpty) {
      isVideoDownloaded = true;
    } else {
      isVideoDownloaded = false;
    }
    update();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:"
        "$twoDigitMinutes:"
        "$twoDigitSeconds";
  }

  Video episoidToVideo(EpisoidsData episoid, Video vieo) {
    Video video = Video(
      title: episoid.title,
      tag: episoid.qualityId,
      desc: vieo.desc,
      thumbnail1x: vieo.thumbnail1x,
      thumbnail2x: vieo.thumbnail2x,
      qualitiesId: episoid.qualityId,
      galleryId: vieo.galleryId,
      quality1080: episoid.quality1080,
      quality1440: episoid.quality1440,
      quality2160: episoid.quality2160,
      quality240: episoid.quality240,
      quality360: episoid.quality360,
      quality4320: episoid.quality4320,
      quality480: episoid.quality480,
      quality720: episoid.quality720,
      view: vieo.view,
      userLiked: vieo.userLiked,
      userBookmarked: vieo.userBookmarked,
      tagData: vieo.tagData,
      artistData: vieo.artistData,
      lastSessionTime: vieo.lastSessionTime,
      type: vieo.type,
      commonTag: vieo.commonTag,
      subtitle: vieo.subtitle,
      dubble: vieo.dubble,
    );
    return video;
  }
}
