// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/player_utils/check_quality.dart';
import 'package:movie_chi/core/utils/player_utils/download_video_function.dart';
import 'package:movie_chi/core/utils/utils.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/detail_page_controller.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';

import '../../../../core/utils/database_helper.dart';
import '../../../../core/utils/get_storage_data.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../locator.dart';
import '../../data/model/video_model.dart';

class SessionItem extends StatefulWidget {
  const SessionItem({
    Key? key,
    required this.video,
    required this.index,
  }) : super(key: key);
  final Video video;
  final int index;

  @override
  State<SessionItem> createState() => _SessionItemState();
}

class _SessionItemState extends State<SessionItem> {
  @override
  void initState() {
    super.initState();
    loadLastView();
  }

  DictionaryDataBaseHelper dbHelper = locator();

  List lastView = [];
  Map lastViewMap = {};
  loadLastView() async {
    List l = await dbHelper.getQuery("tbl_history",
        where: "tag", whereValue: widget.video.tag);
    if (l == null || l.isEmpty) return;

    lastView = json.decode(l[0]['data']);
    lastViewMap = lastView[lastView.length - 1];

    setState(() {});
    debugPrint(lastViewMap.toString());
  }

  final pageController = Get.find<DetailPageController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        // Constants.openVideoPlayer(
        //   widget.video,
        //   path: qualityLink,
        //   customLink: qualityLink,
        //   episoidList: pageController
        //           .playListModel?.data?[pageController.sessionId].episoids ??
        //       [],
        //   episoidIndex: widget.index,
        //   additionTitle: pageController.videoDetail?.type != "video"
        //       ? pageController.videoDetail?.title ?? ""
        //       : "",
        // );
        // LogPrint(widget.video.toJson());
        // print(widget.video.toJson());
        try {
          if ((GetStorageData.getData("logined") ?? false)) {
            String qualityLink = await CheckQuality.checkQuality(widget.video,
                actionButton: "پخش");
            if (qualityLink == "") return;
            Constants.openVideoPlayer(
              widget.video,
              path: qualityLink,
              customLink: qualityLink,
              episoidList: pageController.playListModel
                      ?.data?[pageController.sessionId].episoids ??
                  [],
              episoidIndex: widget.index,
              additionTitle: pageController.videoDetail?.type != "video"
                  ? pageController.videoDetail?.title ?? ""
                  : "",
            );
          } else {
            // launchUrl(Uri.parse(
            //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
            // checkUSers();
            if (!(GetStorageData.getData("logined") ?? false)) {
              // launchUrl(Uri.parse(
              //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
              Utils().checkUSers();
              if ((GetStorageData.getData("logined") ?? false) == false) {
                if ((GetStorageData.getData("user_logined") ?? false) ==
                    false) {
                  Get.toNamed(LoginScreen.routeName);
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
                      Future.delayed(const Duration(milliseconds: 1000),
                          () async {
                        await Get.to(() => const PlanScreen());
                      });
                      return;
                    }
                  } else {
                    await Constants.showGeneralSnackBar(
                        "تهیه اشتراک ارزان با تخفیف",
                        "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
                    Future.delayed(const Duration(milliseconds: 1000),
                        () async {
                      await Get.to(() => const PlanScreen());
                    });
                    return;
                  }
                }
              }
              // launch search in google
            }
          }
        } catch (e) {
          if (!(GetStorageData.getData("logined") ?? false)) {
            // launchUrl(Uri.parse(
            //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
            Utils().checkUSers();
            if ((GetStorageData.getData("logined") ?? false) == false) {
              if ((GetStorageData.getData("user_logined") ?? false) == false) {
                Get.toNamed(LoginScreen.routeName);
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
                    Future.delayed(const Duration(milliseconds: 1000),
                        () async {
                      await Get.to(() => const PlanScreen());
                    });
                    return;
                  }
                } else {
                  await Constants.showGeneralSnackBar(
                      "تهیه اشتراک ارزان با تخفیف",
                      "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
                  Future.delayed(const Duration(milliseconds: 1000), () async {
                    await Get.to(() => const PlanScreen());
                  });
                  return;
                }
              }
            }
            // launch search in google
          }
        }
      },
      child: Row(
        children: [
          Container(
            width: width - 80,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary.withAlpha(200),
                  Theme.of(context).colorScheme.secondary.withAlpha(80),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              children: [
                const Spacer(),
                Row(children: [
                  const SizedBox(width: 10),
                  const IconButton(onPressed: null, icon: Icon(Iconsax.play)),
                  const SizedBox(width: 10),
                  MyText(
                    txt:
                        "قسمت ${widget.video.title.toString().replaceAll("قسمت", "")}",
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  if (lastView.isNotEmpty)
                    const Row(
                      children: [
                        Icon(Iconsax.eye),
                        SizedBox(width: 10),
                        MyText(
                          txt: "تماشا شده",
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                ]),
                const Spacer(),
                LinearProgressIndicator(
                    value: lastViewMap.isNotEmpty
                        ? (lastViewMap['vid_time'] /
                            lastViewMap['vid_duration'])
                        : 0,
                    color: Colors.red),
              ],
            ),
          ),
          Expanded(
            child: IconButton(
                onPressed: () async {
                  if ((GetStorageData.getData("logined") ?? false)) {
                    DownloadVideo.downloadVideo(widget.video);
                  } else {
                    // launchUrl(Uri.parse(
                    //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
                    Utils().checkUSers();
                    if ((GetStorageData.getData("logined") ?? false) == false) {
                      if ((GetStorageData.getData("user_logined") ?? false) ==
                          false) {
                        Get.toNamed(LoginScreen.routeName);
                        return;
                      } else {
                        if (GetStorageData.getData("user_status") ==
                            "premium") {
                          String timeOut =
                              GetStorageData.getData("time_out_premium");
                          DateTime expireTimeOut = (DateTime.parse(timeOut));
                          DateTime now = (DateTime.now());

                          if (expireTimeOut.millisecondsSinceEpoch <
                              now.millisecondsSinceEpoch) {
                            await Constants.showGeneralSnackBar(
                                "خطا", "اشتراک شما به پایان رسیده است");
                            Future.delayed(const Duration(milliseconds: 1000),
                                () async {
                              await Get.to(() => const PlanScreen());
                            });
                            return;
                          }
                        } else {
                          await Constants.showGeneralSnackBar(
                              "تهیه اشتراک ارزان با تخفیف",
                              "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
                          Future.delayed(const Duration(milliseconds: 1000),
                              () async {
                            await Get.to(() => const PlanScreen());
                          });
                          return;
                        }
                      }
                    }
                    // launch search in google
                  }
                },
                icon: const Icon(Icons.cloud_download_rounded)),
          ),
        ],
      ),
    );
  }
}
