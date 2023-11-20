// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../core/utils/get_storage_data.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../locator.dart';
import '../controllers/detail_page_controller.dart';
import '../controllers/download_page_controller.dart';

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

  loadLastView() async {
    List l = await dbHelper.getQuery("tbl_history",
        where: "tag", whereValue: widget.pageController.videoDetail?.tag ?? "");
    if (l == null || l.isEmpty) return;
    // print(l);
    lastView = json.decode(l[0]['data']);
    lastViewMap = lastView[lastView.length - 1];

    setState(() {});
    LogPrint(lastViewMap);
  }

  @override
  void initState() {
    super.initState();
    loadLastView();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                CachedNetworkImage(
                    height: widget.width * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    color: Colors.black.withAlpha(100),
                    colorBlendMode: BlendMode.darken,
                    httpHeaders: const {'Referer': 'https://www.cinimo.ir/'},
                    // handle error
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: widget.pageController.galleryImageSelected != ""
                        ? Constants.imageFiller(
                            widget.pageController.galleryImageSelected)
                        : widget.pageController.videoDetail?.thumbnail2x !=
                                    null &&
                                widget.pageController.videoDetail!
                                        .thumbnail2x !=
                                    ""
                            ? Constants.imageFiller(
                                widget.pageController.videoDetail!.thumbnail2x!)
                            : Constants.imageFiller(widget
                                .pageController.videoDetail!.thumbnail1x!)),
                LinearProgressIndicator(
                    value: lastViewMap.isNotEmpty
                        ? (lastViewMap['vid_time'] /
                            lastViewMap['vid_duration'])
                        : 0.0,

                    // value: 0.5,
                    color: Colors.red),
              ],
            ),
          ),
          Positioned.fill(child: PlayIcon()),
        ],
      ),
    );
  }
}

class PlayIcon extends StatelessWidget {
  PlayIcon({super.key});

  final pageController = Get.find<DetailPageController>();
  checkUSers() async {
    bool canSeeVide = await pageController.isallowToPlay();

    if (canSeeVide) {
      //launch mx
      final downloadController = Get.find<DownloadPageController>();
      String qualityLink = await downloadController
          .checkQuality(pageController.videoDetail!, actionButton: "پخش");

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
      onPressed: () async {
        // check from persian country or not
        final downloadController = Get.find<DownloadPageController>();
        // check from persian country or not

        // try {
        // if (GetStorageData.getData("logined")) {
        // Get.to(() => const VideoPlayerScreen(), arguments: {
        //   "data": pageController.videoDetail,
        // });

        if ((GetStorageData.getData("logined") ?? false) == false) {
          if ((GetStorageData.getData("user_logined") ?? false) == false) {
            Get.to(() => LoginScreen());
            return;
          } else {
            if (GetStorageData.getData("user_status") == "premium") {
              String timeOut = GetStorageData.getData("time_out_premium");
              DateTime expireTimeOut = (DateTime.parse(timeOut));
              DateTime now = (DateTime.now());

              if (expireTimeOut.millisecondsSinceEpoch <
                  now.millisecondsSinceEpoch) {
                await Constants.showGeneralSnackBar(
                    "خطا", "اشتراک شما به پایان رسیده است");
                Future.delayed(const Duration(milliseconds: 1000), () async {
                  await Get.to(() => const PlanScreen());
                });
                return;
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
        try {
          // if ((GetStorageData.getData("logined") ?? false)) {
          String? qualityLink = await downloadController
              .checkQuality(pageController.videoDetail!, actionButton: "پخش");
          if (qualityLink == null) return;
          Constants.openVideoPlayer(
              pageController.video ?? pageController.videoDetail!,
              path: qualityLink,
              customLink: qualityLink);
          // } else {
          //   // launchUrl(Uri.parse(
          //   //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
          //   checkUSers();
          //   showSubscribtion();
          // }
        } catch (e) {
          // await Constants.showGeneralSnackBar(
          //     "تماس با پشتیبانی", "خطایی رخ دادخ $e");
          // if (!(GetStorageData.getData("logined") ?? false)) {
          //   // launchUrl(Uri.parse(
          //   //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
          //   checkUSers();
          //   showSubscribtion();
          //   // launch search in google
          // }
        }

        // loading screen

        // Get.to(() => const VideoPlayerScreen(),
        //     arguments: {"data": pageController.videoDetail});
      },
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
