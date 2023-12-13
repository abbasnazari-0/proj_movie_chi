import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_chi/core/utils/mobile_detector.dart';
import 'package:movie_chi/features/feature_artists/presentation/controllers/artist_list_controller.dart';
import 'package:movie_chi/features/feature_plans/presentation/controllers/plan_controller.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/feature_homeScreen.dart';
import 'package:movie_chi/features/feature_onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movie_chi/locator.dart';
import 'package:uni_links/uni_links.dart';

import '../utils/database_helper.dart';
import '../utils/get_storage_data.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  chnageScreenToFull() async {
    await StatusBarControl.setFullscreen(true);
  }

  final artistController =
      Get.put(ArtistListController(homeCatagoryUseCase: locator()));
  final controller = Get.put(PlanScreenController(locator(), locator()));

  dbInitlizer() async {
    if (MobileDetector.isMobile()) {
      DictionaryDataBaseHelper dbHelper = locator();

      await dbHelper.init();
    }
  }

  @override
  initState() {
    super.initState();

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
          // }
        } else {
          openScreenWithPeriodic();
        }
      }
    } on PlatformException {
      openScreenWithPeriodic();
    }
  }

  openScreenWithPeriodic() async {
    if (!MobileDetector.isMobile()) {
      startNewActivity();
      return;
    }

    await dbInitlizer();
    await locatConfigSecoundPage();
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        startNewActivity();
        timer.cancel();
      },
    );
  }

  startNewActivity() {
// Check if User come with first time
    if ((GetStorageData.getData('isNotFirestTime')) ?? true) {
      Get.off(() => ObBoardingScreen());
    } else {
      Get.off(() => const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileDetector.getPlatformSize(MediaQuery.of(context).size) ==
              PltformSize.mobile
          ? Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            )
          : const SizedBox(),
    );
  }
}
