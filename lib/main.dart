import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_chi/config/theme.dart';
import 'package:movie_chi/core/routes.dart';
import 'package:movie_chi/core/utils/mobile_detector.dart';
import 'package:movie_chi/features/feature_artists/presentation/controllers/artist_list_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/search_page_controller.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'notification_service.dart';
// I/flutter ( 5732): Pinput: App Signature for SMS Retriever API Is: mytcCT9Ar3o

void main() async {
// debugRepaintRainbowEnabled = true;
  //
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the MediaKit for video player
  MediaKit.ensureInitialized();

  // initialize the dotenv package
  await dotenv.load(fileName: ".env");

  // initialize the locator
  await setup();

  // initialize the firebase for analytics
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // initialize the notification service
  if (MobileDetector.isMobile()) {
    LocalNotificationService().initialize();
  }

  // await initialDeepLinks();

  // Get.put(PlanScreenController(locator(), locator()));

  Get.put(ArtistListController(homeCatagoryUseCase: locator()));
  Get.put(HomePageController(locator(), locator()));
  Get.put(SearchPageController(locator()));
  // final adController = Get.put(AdController());
  // Get.put(DownloadPageController());

  // Get.put(DetailPageController(locator(), null, locator())).checkUSers();

  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      locale: const Locale('en', 'US'),
      title: 'مووی چی!',
      // theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    ),
  );
}
