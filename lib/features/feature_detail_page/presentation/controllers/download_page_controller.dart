// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/database_helper.dart';
import 'package:movie_chi/locator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/video_model.dart';
import '../widgets/quality_chooser.dart';
import 'detail_page_controller.dart';

class DownloadPageController extends GetxController {
  Dio dioDownloader = Dio();
  List downloadList = [];
  Video? video;
  String? taskID;

  DictionaryDataBaseHelper dbHelper = locator();

  DetailPageController? detailPageController;
  deleteDownloadedVideo(String tag) async {
    List itemDownload = await dbHelper.getQuery("tbl_downloaded",
        where: "tag", whereValue: tag);

    try {
      dbHelper.query("DELETE FROM tbl_downloaded WHERE tag = '$tag'");
      // update
      detailPageController?.isDownloading = false;
      detailPageController!.updateList();
      detailPageController?.updateStatus();
      update();

      if (await checkPermission()) {
        String? filePath = (itemDownload[0]['download_path']);
        await File(filePath!).delete();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    detailPageController!.updateList();
    detailPageController?.updateStatus();
    update();
  }

  startNewDownload(Video videoDetail,
      {required DetailPageController detailController}) async {
    if (detailController.isDownloading &&
        detailController.video?.tag != videoDetail.tag) {
      // Get.snackbar("دانلود", "دانلود دیگری در حال انجام است");
      Constants.showGeneralSnackBar("دانلود", "دانلود دیگری در حال انجام است");
      return;
    }

    detailPageController = detailController;
    if (await checkVideoDownloaded(videoDetail.tag)) {
      await playDownloadedVideo(videoDetail.tag!);
      return;
    }

    downloadVideo(videoDetail);
  }

  String getVideoUrl(String url) {
    return url;
  }

  checkVideoDownloaded(tag) async {
    List videoDownloadedList = await dbHelper.getDoubleQuery("tbl_downloaded",
        where: "tag",
        whereValue: tag,
        where2: "download_status",
        whereValue2: "true");

    if (videoDownloadedList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> checkQuality(Video video, {String? actionButton}) async {
    // if just have 1 quality
    List<Map<String, String?>> videosQualities = [
      {"vid": video.quality1080, "quality": "1080"},
      {"vid": video.quality1440, "quality": "1440"},
      {"vid": video.quality2160, "quality": "2160"},
      {"vid": video.quality360, "quality": "360"},
      {"vid": video.quality480, "quality": "480"},
      {"vid": video.quality720, "quality": "720"},
      {"vid": video.quality240, "quality": "240"},
      {"vid": video.quality4320, "quality": "4320"}
    ];

    // if not have any quality
    if (videosQualities.where((element) => element["vid"] != null).isEmpty) {
      // show error
      Constants.showGeneralSnackBar(
          "خطا", "کیفیتی برای ${actionButton ?? ""} وجود ندارد");
      return "";
    }
    // where to check
    if (videosQualities.where((element) => element["vid"] != null).length ==
        1) {
      // download video
      // return one quality
      return getVideoUrl(videosQualities
          .where((element) => element["vid"] != null)
          .first["vid"]!);
    } else {
      String qualitySelected = "";
      // show dialog to choose quality
      qualitySelected =
          await chooseQuality(videosQualities, actionButton: actionButton);
      return getVideoUrl(qualitySelected);
    }
  }

  playDownloadedVideo(String tag) async {
    List videoDownloadedList = await dbHelper.getDoubleQuery("tbl_downloaded",
        where: "tag",
        whereValue: tag,
        where2: "download_status",
        whereValue2: "true");
    try {
      Map dataItem = videoDownloadedList[0];
      LogPrint(dataItem['video']);

      String? filePath = (dataItem['download_path']);

// var path = await FlutterAbsolutePath.getAbsolutePath(
//     Uri uri = Uri.parse(dataItem['download_path']);
//     File file = File.fromUri(uri);

//     String realPath = file.path;
      // print(realPath);

      Video v = Video.fromJson(json.decode(dataItem['video']));
      Constants.openVideoPlayer(
        v,
        isLocal: true,
        path: filePath,
      );
    } catch (e) {
      // show error and route user to use from other player and gallery
      Get.dialog(
        AlertDialog(
          title: const Text(
            "خطا",
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "خطایی در پخش ویدیو رخ داده است\nلطفا از پخش کننده دیگری استفاده کنید",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("باشه"))
          ],
        ),
      );
    }
  }

  // open url in browser
  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> downloadVideo(Video video) async {
    if ((GetStorageData.getData("user_logined") ?? false) == false) {
      Get.to(() => LoginScreen());
      return;
    }

    if (GetStorageData.getData("user_status") == "premium") {
      String timeOut = GetStorageData.getData("time_out_premium");
      DateTime expireTimeOut = (DateTime.parse(timeOut));
      DateTime now = (DateTime.now());

      if (expireTimeOut.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        Constants.showGeneralSnackBar("خطا", "اشتراک شما به پایان رسیده است");
        await Get.to(() => const PlanScreen());

        return;
      } else {
        // check download count
        int downloadMax =
            int.parse(GetStorageData.getData("download_max") ?? 0);

        int userDownloaded = (GetStorageData.getData("downloaded_item") ?? 0);

        if (userDownloaded >= downloadMax && downloadMax != -1) {
          Constants.showGeneralSnackBar(
              "خطا", "شما به حداکثر تعداد دانلود رسیده اید");
          await Get.to(() => const PlanScreen());

          return;
        }
      }
    } else {
      int downloadMax =
          int.parse(GetStorageData.getData("download_max") ?? "0");

      int downloadednumber = (GetStorageData.getData("downloaded_item") ?? 0);
      if (downloadednumber >= downloadMax) {
        await Get.to(() => const PlanScreen());
        Constants.showGeneralSnackBar(
            "خطا", "شما به حداکثر تعداد دانلود رسیده اید");

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
                        String qualityLink = await checkQuality(video);
                        int downloaded =
                            (GetStorageData.getData("downloaded_item") ?? 0);
                        GetStorageData.writeData(
                            "downloaded_item", downloaded + 1);
                        openUrl(qualityLink);
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
    // if (this.video == null) this.video = video;

    // if (!await checkPermission()) {
    //   // show beatiful dialog to show permission
    //   // Get.snackbar("دانلود", "برای دانلود ویدیو باید دسترسی را بدهید");
    //   Constants.showGeneralSnackBar(
    //       "دانلود", "برای دانلود ویدیو باید دسترسی را بدهید");
    //   print("not granted");
    //   return;
    // }

    // await dbHelper.query("Delete from tbl_downloaded");

//     List isDownloading = await dbHelper.query(
//         "SELECT * FROM tbl_downloaded WHERE tag = '${video.tag}' AND isDownloading = 'true'");

//     if (isDownloading.isNotEmpty) {
//       Constants.showGeneralSnackBar("دانلود",
//           "این ویدیو در حال دانلود است" 'تا انتهای دانلود لطفا صبر کنید');
//       return;
//     }

//     List isDownloaded = await dbHelper.query(
//         "SELECT * FROM tbl_downloaded WHERE tag = '${video.tag}' AND download_status = 'true'");

//     if (isDownloaded.isNotEmpty) {
//       // Get.snackbar("دانلود", "این ویدیو قبلا دانلود شده است");
//       Constants.showGeneralSnackBar("دانلود", "این ویدیو قبلا دانلود شده است");
//       return;
//     }

//     {
//       final homePageController = Get.find<HomePageController>();
//       homePageController.updatingBadge(true);
//     }

//     await dbHelper.addQuery(
//         "video, tag, download_status, download_path, isDownloading",
//         "'${json.encode(video.toJson())}', '${video.tag}', 'false', '', 'false' ",
//         "tbl_downloaded");

//     // change downlload  status
//     detailPageController?.isDownloading = true;
//     detailPageController?.updateStatus();

//     dioDownloader = Dio();

//     // qualityLink =
//     //     "https://files2.cinimo.ir/cinimo/videos/vifprvymvghqauijqopm.mp4";

//     try {
//       detailPageController?.changeProgressBarValue(0, 0, 0);

//       changeDownloadStatus(video.tag!,
//           prog: 0, isDownloading: true, video: video);

//       detailPageController?.updateStatus();

//       // get file size from url
//       var response = await dioDownloader.head(qualityLink);
//       var size = response.headers['content-length']?[0] ?? "0";
//       var total = int.parse(size.toString());

//       // NativeFlutterDownloader.initialize();
//       taskID = DateTime.now().millisecondsSinceEpoch.toString();
//       if (await checkPermission()) {
//         // define the download task (subset of parameters shown)
//         final downloadTask = DownloadTask(
//             url: qualityLink,
//             filename:
//                 "${video.tag}-${video.title.toString().replaceAll(" ", "_")}.mp4",
//             directory: "cinimo/",
//             updates: Updates
//                 .statusAndProgress, // request status and progress updates
//             taskId: taskID,
//             requiresWiFi: false,
//             retries: 5,
//             allowPause: true,
//             metaData: 'data for me',
//             baseDirectory: BaseDirectory.applicationDocuments);

// // Start download, and wait for result. Show progress and status changes
// // while downloading
//         this.video = video;
//         await FileDownloader().download(downloadTask, onProgress: (progress) {
//           var received = total * progress;

//           if (total != 0) {
//             detailPageController?.fileSize = total.toDouble();

//             if (received == total) {
//             } else {
//               // double progress = (received / total * 100);

//               detailPageController?.changeProgressBarValue(
//                   progress.toDouble() * 100,
//                   total.toDouble(),
//                   received.toDouble());

//               changeDownloadStatus(video.tag!,
//                   prog: progress.toDouble(), isDownloading: true, video: video);
//             }
//           }
//         }, onElapsedTime: (e) {
//           debugPrint(e.toString());
//         }, onStatus: (status) async {
//           if (status == TaskStatus.complete) {
//             // print("on completed!");
//             detailPageController?.isDownloading = false;
//             changeDownloadStatus(video.tag!,
//                 prog: 100, isDownloading: false, video: video);
//             detailPageController?.updateStatus();

//             // if (fileMoved['isSuccess']) {

//             await dbHelper.updateQuery(
//                 "UPDATE  tbl_downloaded SET download_status= 'true', isDownloading = 'false', download_path= '/storage/emulated/0/Download/cinimo/${downloadTask.filename}' WHERE tag = '${video.tag}';");

//             // Get.snackbar("دانلود", "دانلود با موفقیت انجام شد");
//             final newFilePath = await FileDownloader().moveToSharedStorage(
//                 downloadTask, SharedStorage.downloads,
//                 directory: 'cinimo');
//             if (newFilePath == null) {
//               Constants.showGeneralSnackBar("خطا", "خطا در ذخیره فایل");
//               // handle error
//             } else {
//               // do something with the newFilePath
//               Constants.showGeneralSnackBar(
//                   "دانلود",
//                   "دانلود با موفقیت انجام شد"
//                       'میتوانید از بخش دانلود ها مشاهده کنید');

//               if (detailPageController?.videoDetail != null) {
//                 detailPageController?.checkVideoDownloaded(
//                     detailPageController?.videoDetail?.tag);
//               }
//             }

//             detailPageController?.updateStatus();
//             // task = DownloadTask(url: "");
//           } else if (status == TaskStatus.canceled) {
//             debugPrint('Download was canceled');
//             debugPrint('Download canceled');
//             changeDownloadStatus(video.tag!,
//                 prog: 0, isDownloading: false, video: video);
//             await cancelDownload();
//           } else if (status == TaskStatus.paused) {
//             debugPrint('Download was paused');
//             debugPrint('Download paused');

//             //   Future.delayed(
//             //     const Duration(milliseconds: 250),
//             //     () => NativeFlutterDownloader.attachDownloadProgress(
//             //         event.downloadId),
//             //   );
//             // } else if (event.status == DownloadStatus.pending) {
//             //   changeDownloadStatus(video.tag!,
//             //       prog: 0, isDownloading: true, token: videoID!, video: video);
//             // }
//           } else if (status == TaskStatus.failed) {
//             debugPrint('Download failed');
//             changeDownloadStatus(video.tag!,
//                 prog: -1, isDownloading: false, video: video);

//             Constants.showGeneralSnackBar(
//                 "دانلود", "دانلود با موفقیت انجام نشد");
//             // videoID = null; //TODO
//           } else {}
//         });
//       } else {
//         debugPrint('Permission denied =(');
//       }
//     } catch (e) {
//       changeDownloadStatus(video.tag!,
//           prog: -1, isDownloading: false, video: video);
//     }

    // update();
  }

  changeDownloadStatus(String tag,
      {double prog = 0,
      bool isDownloading = false,
      required Video video}) async {
    if ((taskID ?? "") == "") {
      // TODO
    }
    dbHelper.updateQuery(
        "UPDATE tbl_downloaded SET `download_status` = '${isDownloading ? "false" : "true"}',`isDownloading`= '$isDownloading' WHERE tag= 'tag' ");

    if (!isDownloading) {
      await cancelDownload();
    }
    update();
    detailPageController?.updateStatus();
  }

  cancelDownload() async {
//     if (await FileDownloader().cancelTaskWithId(taskID ?? "")) {
//       if (detailPageController?.videoDetail != null) {
//         if ((await detailPageController?.checkVideoDownloaded(
//                 detailPageController?.videoDetail?.tag ?? "")) ==
//             false) {
// // DELETE from tbl_download
//           dbHelper
//               .query("DELETE FROM tbl_downloaded WHERE tag = '${video?.tag}'");
//           detailPageController?.isDownloading = false;
//           detailPageController?.updateStatus();
//           update();
//         }
//       }
//     }
  }

  Future<bool> checkPermission() async {
    bool permissionGranted = false;
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        // setState(() {
        permissionGranted = true;
        // });
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        // setState(() {
        permissionGranted = false;
        // });
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        // setState(() {
        permissionGranted = true;
        // });
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {
        // setState(() {
        permissionGranted = false;
        // });
      }
    }
    return permissionGranted;
    // return true;
  }
}
