import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/mobile_detector.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/feature_home_screen.dart';
import 'package:movie_chi/features/feature_onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movie_chi/locator.dart';
import 'package:uni_links/uni_links.dart';

import '../utils/database_helper.dart';
import '../utils/get_storage_data.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  chnageScreenToFull() async {
    await StatusBarControl.setFullscreen(true);
  }

  dbInitlizer() async {
    if (MobileDetector.isMobile()) {
      DictionaryDataBaseHelper dbHelper = locator();

      await dbHelper.init();
    }
  }

  @override
  initState() {
    super.initState();

    dbInitlizer();

    //Script that chnage Screen Status

    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      if (initialLink == null) {
        openScreenWithPeriodic();
      } else {
        var uri = Uri.parse(initialLink.toString());
        if (uri.scheme == "app") {
          String query = uri.queryParameters['query'] ?? "";

          if (uri.queryParameters['type'] == "gateway") {
            // final controllerss = Get.find<PlanScreenController>();
            GetStorageData.writeData("plan_viewed", true);
            GetStorageData.writeData("is_premium", false);
            openScreenWithPeriodic();
            return;
          }
          if (uri.queryParameters['type'] == "player") {
            GetStorageData.writeData("video_open", query);
          }
        }
        // https://cinimo.ir/video/ihiehfdf
        // should have video path
        if ((uri.scheme == "http" || uri.scheme == "https") &&
            uri.pathSegments[0] == "video") {
          GetStorageData.writeData("video_open", uri.pathSegments[1]);
          openScreenWithPeriodic();
          return;
        }
        //   //

        // }
        //

        if (uri.pathSegments.isNotEmpty) {
          if (uri.pathSegments[0] == "payment") {
            openScreenWithPeriodic();
            return;
          }
          await GetStorage.init();

          // write notification click to database
          Map payload = {"tag": uri.pathSegments[1]};
          GetStorageData.writeData("has_notif", true);
          GetStorageData.writeData("notif_data", payload);

          openScreenWithPeriodic();
          return;
          // }
        } else {}
      }
    } on PlatformException {
      openScreenWithPeriodic();
      return;
    }
    openScreenWithPeriodic();
  }

  openScreenWithPeriodic() async {
    if (!MobileDetector.isMobile()) {
      startNewActivity();
      return;
    }

    await dbInitlizer();

    if (await Constants.pingWithPort(dotenv.env['CONST_URL'] ?? "", "443") ==
        -1) {
      Dio dio = Dio();
      var res = await dio.get(
        dotenv.env['GITHUB_URL'] ?? "",
      );
      if (res.statusCode == 200) {
        GetStorageData.writeData("config", res.data);
        startNewActivity();
      } else {
        startNewActivity();
      }
    } else {
      startNewActivity();
    }
  }

  startNewActivity() {
// Check if User come with first time
    if ((GetStorageData.getData('isNotFirestTime')) ?? true) {
      Get.off(() => ObBoardingScreen());
    } else {
      Get.offNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileDetector.getPlatformSize(MediaQuery.of(context).size) ==
              PltformSize.mobile
          ? Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const LinearProgressIndicator(
                  minHeight: 2,
                )
              ],
            )
          : const SizedBox(),
    );
  }
}
