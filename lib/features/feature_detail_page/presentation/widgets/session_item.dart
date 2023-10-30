// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/database_helper.dart';
import '../../../../core/utils/get_storage_data.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../locator.dart';
import '../../data/model/video_model.dart';
import '../controllers/detail_page_controller.dart';
import '../controllers/download_page_controller.dart';

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
        customLink: qualityLink,
        episoidList: pageController
                .playListModel?.data?[pageController.sessionId].episoids ??
            [],
        episoidIndex: widget.index,

        // episoidList: pageController.playListModel?.data,
      );

      Get.close(0);
    }
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
    LogPrint(lastViewMap);
  }

  final downloadController = Get.find<DownloadPageController>();
  final pageController = Get.find<DetailPageController>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        try {
          if ((GetStorageData.getData("logined") ?? false)) {
            String qualityLink = await downloadController
                .checkQuality(widget.video, actionButton: "پخش");
            if (qualityLink == "") return;
            Constants.openVideoPlayer(
              widget.video,
              path: qualityLink,
              customLink: qualityLink,
              episoidList: pageController.playListModel
                      ?.data?[pageController.sessionId].episoids ??
                  [],
              episoidIndex: widget.index,
            );
          } else {
            // launchUrl(Uri.parse(
            //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
            checkUSers();
            showSubscribtion();
          }
        } catch (e) {
          if (!(GetStorageData.getData("logined") ?? false)) {
            // launchUrl(Uri.parse(
            //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
            checkUSers();
            showSubscribtion();
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
              borderRadius: BorderRadius.circular(10.r),
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
                    downloadController.downloadVideo(widget.video);
                  } else {
                    // launchUrl(Uri.parse(
                    //     "https://imdb.com/find/?q=${pageController.videoDetail!.title ?? ''}"));
                    checkUSers();
                    showSubscribtion();
                  }
                },
                icon: const Icon(Icons.cloud_download_rounded)),
          ),
        ],
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
