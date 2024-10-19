import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_chi/config/theme.dart';
import 'package:movie_chi/core/routes.dart';
// import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/mobile_detector.dart';
import 'package:movie_chi/features/feature_artists/presentation/controllers/artist_list_controller.dart';

import 'package:movie_chi/features/feature_search/presentation/controller/search_page_controller.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'notification_service.dart';

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

  // for debug we can clear the storage
  // GetStorageData.clear();

  // initialize the firebase for analytics
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Elsewhere in your code
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // initialize the notification service
  if (MobileDetector.isMobile()) {
    LocalNotificationService().initialize();
  }

  Get.put(ArtistListController(homeCatagoryUseCase: locator()));

  Get.put(SearchPageController(locator()));
  // final adController = Get.put(AdController());

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
