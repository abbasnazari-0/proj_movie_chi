// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/player_utils/check_quality.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_home/data/model/cinimo_config_model.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_drawer.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../core/utils/get_storage_data.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../locator.dart';
import '../controllers/detail_page_controller.dart';

class PlaySectionDetailPage extends StatefulWidget {
  const PlaySectionDetailPage({
    super.key,
    required this.width,
    required this.pageController,
  });

  final double width;
  final DetailPageController pageController;

  @override
  State<PlaySectionDetailPage> createState() => _PlaySectionDetailPageState();
}

class _PlaySectionDetailPageState extends State<PlaySectionDetailPage> {
  DictionaryDataBaseHelper dbHelper = locator();

  List lastView = [];

  Map lastViewMap = {};
  CinimoConfig config = configDataGetter();

  loadLastView() async {
    List l = await dbHelper.getQuery("tbl_history",
        where: "tag", whereValue: widget.pageController.videoDetail?.tag ?? "");
    if (l == null || l.isEmpty) return;
    // print(l);
    lastView = json.decode(l[0]['data']);
    lastViewMap = lastView[lastView.length - 1];

    setState(() {});
    debugPrint(lastViewMap.toString());
  }

  @override
  void initState() {
    super.initState();
    loadLastView();
  }

  final pageController = Get.find<DetailPageController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          playerIcons(pageController.video ?? pageController.videoDetail),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50 / 4),
          color: Colors.blueGrey,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: pageController.videoDetail?.videoType?.type ==
                          VideoTypeEnum.free
                      ? Colors.redAccent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(50 / 4),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)])),
              height: pageController.videoDetail?.videoType?.type ==
                      VideoTypeEnum.free
                  ? 50
                  : 80,
              width: double.infinity,
              // margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded),
                    MyText(
                      txt: "پخش فیلم",
                      fontWeight: FontWeight.bold,
                    )
                  ]),
            ),
            if (pageController.videoDetail?.videoType?.type !=
                VideoTypeEnum.free)
              Positioned(
                left: 0,
                top: 0,
                child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(315 / 360),
                    child: Image.asset("assets/images/crown.png", height: 32)),
              ),
            if (pageController.videoDetail?.videoType?.type !=
                VideoTypeEnum.free)
              const Positioned(
                left: 32,
                top: 10,
                child: MyText(
                  txt: 'مخصوص اشتراک ویژه',
                ),
              )
          ],
        ),
      ),
    );
  }
}

checkUserStatus(Function onSuccess, Function onFail, Video videoDetail) async {
  bool isTablet = Get.width > Get.height;

  // final pageController = Get.find<DetailPageController>();
  CinimoConfig config = configDataGetter();

  // if ((GetStorageData.getData("logined") ?? false) == false) {

  // // check from persian country or not

  try {
    if ((GetStorageData.getData("user_logined") ?? false) == false) {
      Get.toNamed(LoginScreen.routeName);
      return;
    }
  } catch (e) {
    Get.toNamed(LoginScreen.routeName);
    return;
  }
  if (GetStorageData.getData("user_status") != "premium" &&
      videoDetail.videoType?.type == VideoTypeEnum.premium) {
    if (isTablet) {
      await Constants.showGeneralSnackBar("تهیه اشتراک با گوشی",
          "لطفا با گوشی به اکانت خود مراجعه کنید و اشتراک تهیه کنید؛ این امکان برای تبلت ها وجود ندارد");
    } else {
      await Constants.showGeneralSnackBar("تهیه اشتراک ارزان با تخفیف",
          "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
      Future.delayed(const Duration(milliseconds: 1000), () async {
        await Get.to(() => const PlanScreen());
      });
    }
    return;
  }

  if (videoDetail.videoType?.type == VideoTypeEnum.free ||
      (config.config?.freeUserPaidVideo ?? false) == true) {
    try {
      onSuccess();

      // }
    } catch (e) {
      debugPrint("");
    }
  } else {
    if (GetStorageData.getData("user_status") == "premium") {
      String timeOut = GetStorageData.getData("time_out_premium");
      DateTime expireTimeOut = (DateTime.parse(timeOut));
      DateTime now = (DateTime.now());

      if (expireTimeOut.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        await Constants.showGeneralSnackBar(
            "خطا", "اشتراک شما به پایان رسیده است");
        Future.delayed(const Duration(milliseconds: 1000), () async {
          await Get.to(() => const PlanScreen());
        });
        return;
      }

      try {
        // if ((GetStorageData.getData("logined") ?? false)) {
        onSuccess();
        // String? qualityLink =
        //     await CheckQuality.checkQuality(videoDetail!, actionButton: "پخش");

        // if (qualityLink == null) return;
        // Constants.openVideoPlayer(videoDetail,
        //     path: qualityLink, customLink: qualityLink);

        // // }
      } catch (e) {
        debugPrint("");
      }
    } else {
      await Constants.showGeneralSnackBar("تهیه اشتراک ارزان با تخفیف",
          "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
      Future.delayed(const Duration(milliseconds: 1000), () async {
        await Get.to(() => const PlanScreen());
      });
      return;
    }
  }
}

playerIcons(Video? videoDetail) async {
  checkUserStatus(() async {
    String? qualityLink =
        await CheckQuality.checkQuality(videoDetail!, actionButton: "پخش");
    if (qualityLink == null) return;

    Constants.openVideoPlayer(videoDetail,
        path: qualityLink, customLink: qualityLink);
  }, () {}, videoDetail!);
}

// ignore: must_be_immutable
class PlayIcon extends StatelessWidget {
  PlayIcon({super.key});

  final pageController = Get.find<DetailPageController>();

  checkUSers() async {
    bool canSeeVide = await pageController.isallowToPlay();

    if (canSeeVide) {
      //launch mxoadController = Get.find<DownloadPageController>();
      String qualityLink = await CheckQuality.checkQuality(
          pageController.videoDetail!,
          actionButton: "پخش");

      GetStorageData.writeData("logined", true);
      Constants.openVideoPlayer(
          pageController.video ?? pageController.videoDetail!,
          path: qualityLink,
          customLink: qualityLink);

      Get.close(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () =>
          playerIcons(pageController.video ?? pageController.videoDetail),
      icon: Icon(
        Iconsax.play_circle5,
        color: Get.theme.colorScheme.secondary,
        size: 50,
      ),
    );
  }

  showSubscribtion() {
    Get.defaultDialog(
        title: "اشتراک ویژه",
        content: Column(
          children: [
            MyText(
              txt: "برای دیدن این ویدیو باید اشتراک ویژه داشته باشید",
              color: Get.theme.textTheme.bodyLarge!.color,
              size: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      launchUrl(Uri.parse("https://cinimo.ir"),
                          mode: LaunchMode.externalApplication);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.colorScheme.secondary,
                    ),
                    child: const MyText(
                      txt: "سایت سینیمو",
                      size: 16,
                    )),
                ElevatedButton(
                    onPressed: () {
                      // open url in external browser
                      launchUrl(
                          Uri.parse(
                            "https://payment.cinimo.ir/user/login",
                          ),
                          mode: LaunchMode.externalApplication);
                    },
                    child: MyText(
                      txt: "خرید اشتراک",
                      color: Get.theme.colorScheme.secondary,
                      size: 16,
                    )),
              ],
            )
          ],
        ));
  }
}
