import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movie_chi/config/theme.dart';

import 'package:movie_chi/core/utils/mobile_detector.dart';
import 'package:movie_chi/core/utils/platoformOS.dart';
import 'package:movie_chi/core/wrappers/android_web_wrapper.dart';
import 'package:movie_chi/core/wrappers/web_wrapper.dart';
import 'core/params/admob-ids-getter.dart';
import 'core/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'locator.dart';

import 'notification_service.dart';

// I/flutter ( 5732): Pinput: App Signature for SMS Retriever API Is: mytcCT9Ar3o

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (!kIsWeb) {
    if (Platform.isWindows) {
      WebWrapper.show();
      return;
    }
  } else {
    String webOS = getOSInsideWeb();

    if (webOS == "Android") {
      AndroidWebWrapper.show();
      return;
    }
  }

  await setup();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (MobileDetector.isMobile()) {
    AdmobDataGetter.init();
    LocalNotificationService().initialize();
  }

  runApp(
    ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: false,
      designSize: const Size(360, 690),
      builder: (context, child) => GetMaterialApp(
        // navigatorKey: navigatorKey,
        locale: const Locale('en', 'US'),
        title: 'مووی چی!',
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
    ),
  );
}
