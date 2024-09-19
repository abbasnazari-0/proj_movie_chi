import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/player_utils/check_quality.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadController extends GetxController {
// ignore_for_file: deprecated_member_use

  List downloadList = [];
  Video? video;
  String? taskID;

// open url in browser
  openUrl(String url, String userHeaderAuth) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: {'extra': userHeaderAuth},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> downloadVideo(Video video) async {
    if ((GetStorageData.getData("user_logined") ?? false) == false) {
      Get.toNamed(LoginScreen.routeName);
      return;
    }

    if (video.videoType?.type == (VideoTypeEnum.paid) ||
        video.videoType?.type == (VideoTypeEnum.premium)) {
      if (GetStorageData.getData("user_status") != "premium") {
        await Constants.showGeneralSnackBar(
            "اعضای ویژه", "این فیلم برای اعضای ویژه میباشد");
        Future.delayed(const Duration(milliseconds: 1000), () async {
          await Get.to(() => const PlanScreen());
        });
        return;
      }
    }

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
      } else {
        // check download count
        int downloadMax =
            int.parse(GetStorageData.getData("download_max") ?? 0);

        int userDownloaded = (GetStorageData.getData("downloaded_item") ?? 0);

        if (userDownloaded >= downloadMax && downloadMax != -1) {
          Constants.showGeneralSnackBar(
              "خطا", "شما به حداکثر تعداد دانلود رسیده اید");
          Future.delayed(const Duration(milliseconds: 1000), () async {
            await Get.to(() => const PlanScreen());
          });
          return;
        }
      }
    } else {
      int downloadMax =
          int.parse(GetStorageData.getData("download_max") ?? "0");

      int downloadednumber = (GetStorageData.getData("downloaded_item") ?? 0);
      if (downloadednumber >= downloadMax) {
        Constants.showGeneralSnackBar(
            "خطا", "شما به حداکثر تعداد دانلود رسیده اید");
        // await Get.to(() => const PlanScreen());
        Future.delayed(const Duration(milliseconds: 1000), () async {
          await Get.to(() => const PlanScreen());
        });
        return;
      }
    }

    // show bottom sheet to choose quality
    Get.bottomSheet(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Get.theme.colorScheme.background,
            ),
            height: Get.size.height / 3,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.center,
                      child: MyText(
                        txt: "شروع دانلود",
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const MyText(
                      txt:
                          "برای دانلود بهتر میتوانید از برنامه ADM کمک بگیرید\nبرنامه ADM برنامه ی رایگانی است که در مدریریت بهتر دانلود و افزایش سرعت دانلود فیلم ها به شما کمک میکند",
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15),

                    // download button
                    MaterialButton(
                      onPressed: () async {
                        String qualityLink = await CheckQuality.checkQuality(
                            video,
                            justQuality: true);

                        if (qualityLink == "") return;

                        int downloaded =
                            (GetStorageData.getData("downloaded_item") ?? 0);
                        GetStorageData.writeData(
                            "downloaded_item", downloaded + 1);

                        openUrl(
                            "${Constants.baseUrl()}${pageUrl}download.php?file=$qualityLink&user_tag=${GetStorageData.getData("user_tag")}&user_downloaded=$downloaded&video_tag=${video.tag}&quality_id=${video.qualitiesId}",
                            jsonEncode({
                              "user_downloaded": downloaded,
                              "video_tag": video.tag,
                            }));
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40 / 4),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.colorScheme.onSecondary,
                              Get.theme.colorScheme.secondary.withAlpha(50),
                            ],
                            end: Alignment.topLeft,
                            begin: Alignment.bottomRight,
                          ),
                        ),
                        width: Get.width,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              txt: "دانلود  فیلم",
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.download,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //   title: "دانلود با ADM",
                    //   onTap: () async {
                    //     String qualityLink =
                  ]),
            ),
          ),
        ),
        backgroundColor: Colors.transparent);

    return;
  }
}
