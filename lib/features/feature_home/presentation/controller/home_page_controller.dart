// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/pages/detail_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'package:movie_chi/core/resources/data_state.dart';
import 'package:movie_chi/core/screens/splash_screen.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_artists/data/models/artist_data_model.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_home/data/model/reel_comment_model.dart';
import 'package:movie_chi/features/feature_home/domain/usecases/home_catagory_usecase.dart';
import 'package:movie_chi/features/feature_zhanner/domain/usecases/zhnnaer_usecase.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../../../core/params/home_request_params.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../core/utils/lifecycle_controller.dart';
import '../../../../core/utils/showPrivacyPolicy.dart';
import '../../../../locator.dart';
import '../../../feature_plans/presentation/controllers/plan_controller.dart';
import '../../../feature_update/presentation/screens/feature_update.dart';
import '../../../feature_zhanner/data/model/zhanner_data_model.dart';
import '../../data/model/home_catagory_item_model.dart';
import '../../data/model/home_reels_model.dart';

class HomePageController extends GetxController {
  final HomeCatagoryUseCase homeCatagoryUseCase;
  final ZhannerUseCase zhannerUseCase;
  HomePageController(this.homeCatagoryUseCase, this.zhannerUseCase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int navigationIndex = 0;

  PageStatus homepageStatus = PageStatus.loading;
  HomeCatagory? homeCatagory;
  int tabSelected = 0;

  // reels
  int reelsCount = 0;
  PageStatus reelsPageStatus = PageStatus.empty;
  List<ReelsModel> reelsData = [];
  bool isPlaying = true;
  PageStatus reelCommentPageStatus = PageStatus.empty;
  List<ReelsCommentModel> reelCommentData = [];
  TextEditingController commentController = TextEditingController();
  ScrollController commentListScrollController = ScrollController();
  List<Zhanner> zhannerList = [];
  // update
  bool updateAvailable = false;
  bool mute = false;
  bool showMutewidget = false;
  int preloadPageAmount = 1;

  changePreloadPageView() {
    preloadPageAmount = 3;
    update();
  }

  // update badge

  bool updateBadge = GetStorageData.getData("updateBadge") ?? false;
  updatingBadge(val) {
    updateBadge = val;
    GetStorageData.writeData("updateBadge", val);

    update();
  }

  getZhannerData() async {
    update();
    DataState dataState = await zhannerUseCase.getZhanner();

    if (dataState is DataSuccess) {
      List<Zhanner> list = dataState.data;

      zhannerList = list;
    } else if (dataState is DataFailed) {}
    update();
  }

  getNotificationNewsNew() async {
    DictionaryDataBaseHelper dbHelper = locator();
    List newQuery = await dbHelper.getQuery("tbl_news_notif",
        where: "readed", whereValue: "0");
    if (newQuery.isNotEmpty) {
      updateBadge = true;
      update();
    } else {
      updateBadge = false;
      update();
    }
  }

  // Check Ip (ip is from not iran then show dialog that show "please turn on vpn")
  changeMutableState() {
    mute = !mute;
    // update();
  }

  bool showLikeinReels = false;

  showLikeReels() {
    if (showLikeinReels) {
      showLikeinReels = false;
      update();
    }
    showLikeinReels = true;
    update();

    Future.delayed(const Duration(milliseconds: 600), () {
      showLikeinReels = false;
      update();
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    debugPrint("onReady");

    getZhannerData();
    chanegStatusBarColor();
    hasDataInLocalStorage();
    checkUseStatus();

    getNotificationNewsNew();
    checkVideoStatus();
  }

  checkUseStatus() async {
    final controllerss = Get.find<PlanScreenController>();
    // GetStorageData.writeData("plan_viewed", true);
    controllerss.checkAndGo();
  }

  checkVideoStatus() async {
    String? videoOpen = await GetStorageData.getData("video_open");
    if (videoOpen != null) {
      Constants.openVideoDetail(vidTag: videoOpen, picture: "");
      GetStorageData.writeData("video_open", null);
    }
  }

  checkClicedOnNotification() async {
    bool hasNotif =
        await GetStorageData.readDataWithAwaiting("has_notif") ?? false;

    if (hasNotif) {
      Map notifData = await GetStorageData.readDataWithAwaiting("notif_data");

      if (notifData['type'] == "video") {
        await Future.delayed(const Duration(milliseconds: 500), () async {
          await Get.to(() => DetailPage(
              vid_tag: notifData['tag'], pic: "", deepLinking: true));
        });
      } else if (notifData['type'] == "support_message") {
        Constants.openSupportMessages();
      }
    }
  }

  void returnScreen() {
    update();
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint("onClose");
  }

  configGetter() async {
    // get config from network and save to shared prefrence
    // if (GetStorageData.getData("config") == null) {
    DataState dataState = await homeCatagoryUseCase.getAppConfig();

    if (dataState is DataSuccess) {
      // CinimoConfig cinimoConfig =
      //     CinimoConfig.fromJson(json.decode(dataState.data));

      GetStorageData.writeData("config", dataState.data);
      // print(cinimoConfig.toJson());
    } else {
      // debugPrint(dataState.error);
    }
    // }
  }

  Future vpnDialog() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(Get.context!).primaryColor,
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const MyText(txt: "فیلتر شکن خود را لطفا خاموش کنید", size: 22),
            const SizedBox(height: 30),
            Expanded(
              child: Lottie.asset("assets/lotties/91638-vpn-protection.json",
                  width: 200, height: 200),
            ),
            const SizedBox(height: 30),
            const MyText(
                txt:
                    "مووی چی!یی عزیز! \n برای استفاده از مووی چی! باید فیلتر شکن خود را خاموش کنید",
                size: 16,
                maxLine: 3,
                textAlign: TextAlign.center),
            const SizedBox(height: 30),

            // button to close dialog
            ElevatedButton(
              onPressed: () {
                // restart app
                Get.offAll(() => const Splash());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Theme.of(Get.context!).colorScheme.background,
                  ),
                ),
              ),
              child: const MyText(txt: "باشه", size: 16),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // isDismissible: false,
      // enableDrag: false,
    );
  }

  showIpDialog() async {
    // first Check vpn mode is oned
    if (!kIsWeb) {
      if (await CheckVpnConnection.isVpnActive()) {
        await vpnDialog();
      }
    }
  }

  int homeAmount = 0;
  int homePage = 0;
  // get home catagory data
  getHomeCatagoryData(bool withmoreLoad) async {
    if (homeAmount == 0) homeAmount = 10;
    if (homeAmount > 0 && withmoreLoad) homePage++;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    homepageStatus = PageStatus.loading;

    DataState dataState = await homeCatagoryUseCase.getHomeCatagory(
        HomeRequestParams(
            userTag: GetStorageData.getData("user_tag"),
            version: packageInfo.buildNumber,
            amount: homeAmount.toString(),
            page: homePage.toString()));

    if (dataState is DataSuccess) {
      if (homeCatagory == null) {
        homeCatagory = dataState.data;
      } else {
        HomeCatagory newHomeCatagory = dataState.data;
        homeCatagory?.data?.data?.addAll(newHomeCatagory.data!.data!);
      }

      if (homeCatagory?.code == "200") {
        homepageStatus = PageStatus.success;
      } else {
        homepageStatus = PageStatus.error;
      }
    } else if (dataState is DataFailed) {
      homepageStatus = PageStatus.error;
    }
    update();

    if (GetStorageData.getData("privacy") == null ||
        GetStorageData.getData("privacy") == false) {
      // show privacy dialog
      Future.delayed(const Duration(milliseconds: 1000), () {
        showPrivacyDialog();
      });
    }

    await checkClicedOnNotification();

    getArtistSuggestions(null);
  }

  getVideoGalleryDataByID(
    index,
  ) async {
    tabSelected = index;

    // HomeCatagory homeCatagory = getHomeCatagory();
    // HomeCatagoryData homeCatagoryData = homeCatagory.data![tabSelected];
    // // if (getGalleryDataByTitle(homeCatagoryData.title ?? '').data!.isEmpty) {
    // DataState dataState = await getHomeCatagoryItemData(
    //     homeCatagoryData.values, homeCatagoryData.title);

    // if (dataState is DataSuccess) {
    //   galleryData.add(dataState.data);
    //   update();

    // getHomeReels();
    // } else {
    //   if (kDebugMode) {
    //     print(dataState.error);
    //   }
    // }
    // }

    update();
  }

  // create function to search title in gallery data by title
  HomeCatagagoryItemModel getGalleryDataByTitle(String title) {
    // for (var element in galleryData) {
    //   if (element.title == title) {
    //     return element;
    //   }
    // }
    return HomeCatagagoryItemModel();
  }

  // create function that return element of homecatagory if title is equal to tbl_
  HomeCatagory getHomeCatagory() {
    // for (var element in homeCatagory) {
    // if (element.title!.startsWith("tbl_")) {
    //   return element;
    // }
    // }
    return HomeCatagory();
  }

  @override
  void onInit() {
    super.onInit();

    showIpDialog();

    SystemChannels.lifecycle.setMessageHandler((msg) {
      debugPrint('SystemChannels> $msg');
      if (msg == AppLifecycleState.resumed.toString()) update();
      return Future.value('');
    });

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(resumeCallBack: () async => update()),
    );

    // getHomeReels();

    configGetter();

    getHomeCatagoryData(false);

    checkUpdateAvailable();
  }

  getHomeReels() async {
    if (reelsData.isEmpty) {
      reelsPageStatus = PageStatus.loading;
    }

    reelsCount = reelsCount + 20;
    DataState dataState = await homeCatagoryUseCase.getReelsData(
        GetStorageData.getData("user_tag"), reelsCount);
    if (dataState is DataSuccess) {
      reelsData = dataState.data;
      reelsPageStatus = PageStatus.success;
      reelCommentPageStatus = PageStatus.empty;
    } else {
      debugPrint(dataState.error);
      reelsPageStatus = PageStatus.error;
    }
    update(["reelsPage"]);
  }

  changeBottomNavIndex(int index) {
    navigationIndex = index;

    switch (index) {
      case 4:
        getHomeReels();
        break;
      default:
    }
    update();
  }

  changePlayingStatus(status) {
    isPlaying = status;
    //
    update();
  }

  likeVideo(List<ReelsModel> reelsModelList, int index) async {
    showLikeReels();
    print("like status ${reelsModelList[index].userLiked}");
    ReelsModel reelsModel = reelsModelList[index];
    DataState dataState = await homeCatagoryUseCase.likeOrDeslikeReelPost(
        GetStorageData.getData("user_tag"),
        reelsModel.tag!,
        reelsModel.userLiked == '0' ? 'add' : 'remove');
    if (dataState is DataSuccess) {
      // check liked or desliked

      if (dataState.data.toString().contains("added ")) {
        reelsModelList[index].userLiked = '1';
        reelsModelList[index].reelsLike =
            (int.parse(reelsModelList[index].reelsLike!) + 1).toString();
      } else {
        reelsModelList[index].userLiked = '0';
        reelsModelList[index].reelsLike =
            (int.parse(reelsModelList[index].reelsLike!) - 1).toString();
      }
      update();
    } else {
      print(dataState.error);
    }
  }

  justLike(List<ReelsModel> reelsModelList, int index) async {
    showLikeReels();
    ReelsModel reelsModel = reelsModelList[index];
    DataState dataState = await homeCatagoryUseCase.likeOrDeslikeReelPost(
        GetStorageData.getData("user_tag"), reelsModel.tag!, 'add');
    if (dataState is DataSuccess) {
      // check liked or desliked
      if (reelsModel.userLiked == '1') {
        return;
      }
      if (dataState.data.toString().contains("added ")) {
        reelsModelList[index].userLiked = '1';
        reelsModelList[index].reelsLike =
            (int.parse(reelsModelList[index].reelsLike!) + 1).toString();
      } else {
        reelsModelList[index].userLiked = '0';
        reelsModelList[index].reelsLike =
            (int.parse(reelsModelList[index].reelsLike!) - 1).toString();
      }
      update();
    } else {
      debugPrint(dataState.error);
    }
  }

  loadReelsComment(ReelsModel reelsModel) async {
    reelCommentPageStatus = PageStatus.loading;
    update(["reelsComment"]);

    DataState dataState =
        await homeCatagoryUseCase.getReelComment(reelsModel.tag!);
    // print(reelsModel.tag!);

    if (dataState is DataSuccess) {
      reelCommentData = dataState.data;

      if (reelCommentData.isNotEmpty) {
        reelCommentPageStatus = PageStatus.success;
      } else {
        reelCommentPageStatus = PageStatus.empty;
      }
    } else {
      debugPrint(dataState.error);
      reelCommentPageStatus = PageStatus.error;
    }
    update(["reelsComment"]);

    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        commentListScrollController
            .jumpTo(commentListScrollController.position.maxScrollExtent);
      });
      // jump to last comment with animation
      commentListScrollController.animateTo(
          commentListScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  sendReelsComment(String comment, String vidTag) async {
    if (comment.isNotEmpty) {
      DataState dataState = await homeCatagoryUseCase.submitReelComment(
          GetStorageData.getData("user_tag"), vidTag, comment);
      if (dataState is DataSuccess) {
        if (dataState.data.toString().contains("added")) {
          commentController.clear();
          loadReelsComment(ReelsModel(tag: vidTag));
        }
      } else {
        debugPrint(dataState.error);
      }
    }
  }

  checkUpdateAvailable() async {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        DataState dataState = await homeCatagoryUseCase.getUpdateAvailable();

        if (dataState is DataSuccess) {
          Map data = json.decode(dataState.data);

          if (data["data"].toString().contains("no update available!")) {
            updateAvailable = false;
          } else if (data["data"].toString().contains("update available!")) {
            updateAvailable = true;
          } else {
            updateAvailable = true;
          }
          if (updateAvailable) {
            Get.offAll(() => UpdateScreen(
                  url: data["link"],
                ));
          }
        } else {
          debugPrint(dataState.error);
        }
      }
    }
  }

  int artistItemCount = 0;
  int artistPage = -1;
  List<ArtistItemData> artistData = [];
  getArtistSuggestions(RefreshController? refrehController) async {
    artistPage++;

    if (refrehController != null) refrehController.requestLoading();
    DataState dataState = await homeCatagoryUseCase.getArtistSuggestionData(
        20, artistPage, null, null);
    if (dataState is DataSuccess) {
      artistData.addAll(dataState.data);
      update();
      if (refrehController != null) refrehController.loadComplete();
    } else {
      debugPrint(dataState.error);
      if (refrehController != null) refrehController.loadFailed();
    }
  }

  bool hasDataInlocaStorage = false;
  DictionaryDataBaseHelper dataBaseHelper = locator();
  hasDataInLocalStorage() async {
    List favorite = await dataBaseHelper.getQuery("tbl_favorite");
    List download = await dataBaseHelper.getQuery("tbl_downloaded");
    List history = await dataBaseHelper.getQuery("tbl_history");
    List bbokmark = await dataBaseHelper.getQuery("tbl_bookmark");

    if (favorite.isNotEmpty) {
      hasDataInlocaStorage = true;
    } else if (download.isNotEmpty) {
      hasDataInlocaStorage = true;
    } else if (history.isNotEmpty) {
      hasDataInlocaStorage = true;
    } else if (bbokmark.isNotEmpty) {
      hasDataInlocaStorage = true;
    } else {
      hasDataInlocaStorage = false;
    }

    update();

    headerloader();
  }

  List favoriteList = [];
  List downloadList = [];
  List historyList = [];
  List bookmarkList = [];

  headerloader() async {
    favoriteList = await dataBaseHelper.getQuery("tbl_favorite");

    downloadList = await dataBaseHelper.getQuery("tbl_downloaded",
        where: "download_status", whereValue: 'true');

    historyList = await dataBaseHelper.getQuery("tbl_history");

    bookmarkList = await dataBaseHelper.getQuery("tbl_bookmark");

    update();
  }

  void chanegStatusBarColor() async {
    if (kIsWeb) {
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        await StatusBarControl.setFullscreen(false);
        StatusBarControl.setColor(Get.theme.colorScheme.background,
            animated: true);
      }
    }
  }
}
