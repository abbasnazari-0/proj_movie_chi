import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_chi/config/theme.dart';
import 'package:movie_chi/core/screens/splash_screen.dart';
import 'package:movie_chi/core/utils/mobile_detector.dart';
import 'package:movie_chi/core/utils/photo_viewer_screen.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/pages/detail_page.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/feature_home_screen.dart';
import 'package:movie_chi/features/feature_zhanner/presentation/pages/zhanner_detail.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'notification_service.dart';
// I/flutter ( 5732): Pinput: App Signature for SMS Retriever API Is: mytcCT9Ar3o

final List<GetPage> _routes = [
  GetPage(
    name: "/",
    page: () => const Splash(),
  ),
  GetPage(
    name: "/home",
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: "/detail",
    page: () => const DetailPage(),
  ),
  //  PhotoViewer
  GetPage(
    name: "/photoViewer",
    page: () => PhotoViewer(),
  ),
  // ZhannerDetail
  GetPage(name: "/zhannerDetail", page: () => ZhannerDetail()),
];

void main() async {
  //
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // initialize the MediaKit for video player
  MediaKit.ensureInitialized();

  // initialize the flutter native splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

  FlutterNativeSplash.remove();

  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: _routes,
      locale: const Locale('en', 'US'),
      title: 'مووی چی!',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    ),
  );
}
