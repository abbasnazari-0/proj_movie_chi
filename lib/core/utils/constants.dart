import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/pages/detail_page.dart';
import 'package:movie_chi/features/feature_new_notification/presentation/pages/news_page.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';
import 'package:movie_chi/features/feature_support/presentation/pages/support_page.dart';
import 'package:movie_chi/features/feature_video_player/presentation/pages/feature_new_video_player.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/feature_detail_page/data/model/video_model.dart';
import '../../features/feature_home/data/model/cinimo_config_model.dart';
import '../../features/feature_home/data/model/home_catagory_model.dart';
import '../../features/feature_home/presentation/widgets/home_drawer.dart';
import '../../features/feature_play_list/presentation/pages/feature_play_list.dart';
import '../widgets/mytext.dart';

String bbaseUrl = dotenv.env['CONST_URL'] ?? "";
String bfileBaseUrl = "https://files.cinimo.ir";
String pageUrl = "/v9/cinimo/";

String packageName = "com.arianadeveloper.movie.chi";

enum VideoTypeType { movie, serial, both }

class Constants {
  static urlLauncher(url) async {
    // open url in external browser
    if (await canLaunch(url)) {
      // open in external browser'
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }

  static String formatTime(int seconds) {
    int hours = (seconds / 3600).truncate();
    int minutes = ((seconds - (hours * 3600)) / 60).truncate();
    int remainingSeconds = seconds % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    if (hours > 0) {
      String formattedHours = hours.toString().padLeft(2, '0');
      return "$formattedHours:$formattedMinutes:$formattedSeconds";
    } else {
      return "$formattedMinutes:$formattedSeconds";
    }
  }

  static const String telegramUrl = "https://t.me/cinimo_offcial";
  static const String instagramUrl = "https://instagram.com/moviechi.reels";

  static Future<int> pingWithPort(String address, String port) async {
    final stopwatch = Stopwatch()..start();

    try {
      await Socket.connect(address, int.parse(port),
          timeout: const Duration(seconds: 3));
      return stopwatch.elapsedMilliseconds;
    } catch (e) {
      return -1;
    }
  }

  static bool allowToShowAd() {
    if (kIsWeb) {
      return false;
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        return true;
      } else {
        return false;
      }
    }
  }

  static String baseUrl() {
    CinimoConfig config = configDataGetter();

    String base = config.config?.baseUrl ?? bbaseUrl;

    return base;
  }

  static String fileBaseUrl() {
    CinimoConfig config = configDataGetter();
    if (config.config?.baseUrl != null) {
      return config.config!.fileUrl!;
    } else {
      return bfileBaseUrl;
    }
  }

  static String videoUrl = "${fileBaseUrl()}/cinimo/videos/";
  static String imageUrl = "${fileBaseUrl()}/cinimo/images/";

  static String imageFiller(String img) {
    if (isLink(img)) {
      return img;
    } else {
      return imageUrl + img;
    }
  }

  static String videoFiller(String videoLink) {
    if (isLink(videoLink)) {
      return videoLink;
    } else {
      return imageUrl + videoLink;
    }
  }

//unoffcial, offcial =

  static Future<String> versionApplication() async {
    // if (GetStorageData.getData("version") != null) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
    // GetStorageData.writeData("version", packageInfo.buildNumber);
    // }
    // return GetStorageData.getData("version");

    // return "35";
  }

  // static String versionApplication = "36";
// bazaar | google | myket
  static String market_name = "google";

  static String iconSrc = "assets/images/icon.png";
  static Future<dynamic> showGeneralProgressBar({bool backDismissable = true}) {
    return Get.dialog(
        WillPopScope(
          onWillPop: () async {
            return backDismissable;
          },
          child: SizedBox(
              height: 60,
              width: 60,
              child: Center(
                  child: LoadingAnimationWidget.flickr(
                size: 50,
                leftDotColor: Get.theme.colorScheme.secondary,
                rightDotColor:
                    Get.theme.colorScheme.background.withOpacity(0.5),
              ))),
        ),
        barrierDismissible: false);
  }

  static showGeneralSnackBar(String titl, String txt) {
    Get.snackbar(
      titl,
      txt,
      titleText: MyText(
        txt: titl,
        color: Colors.black,
        textAlign: TextAlign.center,
        size: 15,
        fontWeight: FontWeight.bold,
      ),
      messageText: MyText(
        txt: txt,
        color: Colors.black,
        textAlign: TextAlign.center,
        size: 12,
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      colorText: Colors.black,
      margin: const EdgeInsets.all(15.0),
      borderRadius: 10.0,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 200),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static openVideoPlayer(
    Video video, {
    bool? isLocal,
    String? path,
    String? customLink,
    List<EpisoidsData>? episoidList,
    int? episoidIndex,
    String? additionTitle,
  }) {
    Get.to(() => FeatureNewVideoPlayer(isLocaled: isLocal ?? false),
        arguments: {
          "data": video,
          "isLocal": isLocal ?? false,
          "path": path ?? "",
          "custom_link": customLink,
          "episoids": episoidList ?? [],
          "edpisoid_index": episoidIndex ?? 0,
          "addition_title": additionTitle ?? "",
        });
  }

  static openHomeItem(
      HomeCatagoryItemModel homeCatagoryItem, int index, String pic,
      {String type = "custom"}) {
    // if (homeCatagoryItem.)
    switch (homeCatagoryItem.valueType) {
      case "video":
        // Get.to(() => DetailPage(vid_tag: homeCatagoryItem.data![index].tag!));
        openVideoDetail(
            picture: pic,
            hero: 'home-item-${homeCatagoryItem.data![index].tag}',
            vidTag: homeCatagoryItem.data![index].tag!,
            type: homeCatagoryItem.data?[index].type,
            commonTag: homeCatagoryItem.data?[index].commonTag);
        break;

      case "data":
        String val = (homeCatagoryItem.data![index].tags!);

        if (val.startsWith("https://")) {
          openUrl(val);
        } else {
          Get.toNamed(PlayListScreen.routeName, arguments: {
            "homeCatagoryItemID": homeCatagoryItem.data![index].id.toString(),
            "type": type,
            "backGroundImage": homeCatagoryItem.data![index].thumbnail1x ?? '',
            "title": homeCatagoryItem.data![index].title ?? '',
          });
        }

        break;
      default:
        break;
    }
  }

  static openSupportMessages() => Get.to(() => SupportPage());
  static openNewsPage() => Get.to(() => NewsPage());

  static openVideoDetail(
      {required String vidTag,
      String? commonTag,
      String? type,
      bool deepLink = false,
      String? hero = "",
      required String picture}) {
    Get.toNamed(DetailPage.routeName, arguments: {
      "tag": vidTag,
      "deepLinking": deepLink,
      "pic": picture,
      "heroTag": hero,
      "commonTag": commonTag,
      "type": type
    });
  }

  static Color hexToColor(String hexString) {
    String opacity = "0.8";
    if (hexString.contains("+")) {
      opacity = hexString.split("+")[1];
    }

    // remove +0.2
    hexString = hexString.split("+")[0];

    final buffer = StringBuffer();
    if (hexString.length == 6) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));

    final int color = int.parse(buffer.toString(), radix: 16);

    return Color.fromRGBO(
        ((color & 0xFF0000) >> 16), // red
        ((color & 0xFF00) >> 8), // green
        ((color & 0xFF) >> 0), // blue
        double.parse(opacity));
  }
}

bool isLink(String text) {
  RegExp regExp = RegExp(
    r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
    multiLine: false,
  );
  return regExp.hasMatch(text);
}
