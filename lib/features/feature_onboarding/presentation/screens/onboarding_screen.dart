// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/utils/mobile_detector.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/feature_home_screen.dart';

import '../../../../core/utils/random_string.dart';

// ignore: must_be_immutable
class ObBoardingScreen extends StatelessWidget {
  ObBoardingScreen({super.key});

  bool allowLogin = false;

  getDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // String? deviceId = await PlatformDeviceId.getDeviceId;

    String deviceName = "";
    if (kIsWeb) {
      deviceName = "web";
    } else {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine;
      }
    }
    GetStorageData.writeData("user_tag", generateRandomString(10));
    postdeviceInfoToServer(deviceName, "", GetStorageData.getData("user_tag"));
  }

  postdeviceInfoToServer(deviceName, deviceId, userTag) async {
    Dio dio = Dio();
    var res = await dio
        .post("${Constants.baseUrl()}${pageUrl}register.php", queryParameters: {
      "device_name": deviceName,
      "device_id": deviceId,
      "user_tag": userTag,
      "version": await Constants.versionApplication(),
    });
    if (res.statusCode == 200) {
      if (res.data.toString().startsWith("user added")) {
        allowLogin = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getDevice();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.select) {
          GetStorageData.writeData('isNotFirestTime', false);
          // if (allowLogin)
          Get.off(() => const HomeScreen());
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/cover.jpg',
                height: height,
                width: width,
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                height: height,
                width: width,
                color: Colors.black.withAlpha(180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const MyText(
                      textAlign: TextAlign.right,
                      txt: 'به مووی چی! خوش آمدید',
                      size: 25,
                    ),
                    const MyText(
                      textAlign: TextAlign.right,
                      txt:
                          'از دیدن فیلم های مورد علاقه تان در\nهمه جا لذت ببرید',
                      size: 15,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        GetStorageData.writeData('isNotFirestTime', false);
                        // if (allowLogin)
                        Get.off(() => const HomeScreen());
                      },
                      child: Container(
                        width: MobileDetector.sizeHelper(
                            MediaQuery.of(context).size,
                            mobileSize: width * 0.9,
                            tabletSize: width * 0.7,
                            desktopSize: width * 0.4),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: MyText(
                            txt: 'شروع',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
