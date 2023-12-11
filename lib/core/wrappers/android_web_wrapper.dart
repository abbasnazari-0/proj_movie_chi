import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/config/theme.dart';
import 'package:movie_chi/core/utils/lauch_url.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class AndroidWebWrapper {
  static show() {
    runApp(GetMaterialApp(
      locale: const Locale('en', 'US'),
      title: 'مووی چی!',
      darkTheme: buildDarkTheme(),
      theme: buildLightTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon
              Image.asset(
                'assets/images/icon.png',
                height: 100,
              ),
              const MyText(
                txt: "مووی چی!",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                size: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              const MyText(
                txt:
                    "برای استفاده از مووی چی! در گوشی های اندرویدی لطفا به لینک زیر مراجعه کنید",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              // // show image with link to download
              // // en_badge_web_generic.png
              GestureDetector(
                onTap: () {
                  mlaunchUrl(
                      ("https://play.google.com/store/apps/details?id=com.arianadeveloper.movie.chi"));
                },
                child: Image.asset(
                  'assets/images/en_badge_web_generic.png',
                  height: Get.size.width * 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
