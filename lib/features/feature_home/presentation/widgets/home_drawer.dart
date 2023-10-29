import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:movie_chi/core/screens/splash_screen.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/random_string.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/drawer_controller.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_support/presentation/pages/support_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/data/model/cinimo_config_model.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/saved_screen.dart';

import '../../../feature_critism/presentation/pages/criticism_page.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  getDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? deviceId = await PlatformDeviceId.getDeviceId;

    String deviceName = "";
    if (kIsWeb) {
      deviceName = "web";
    } else {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine!;
      }
    }
    GetStorageData.writeData("user_tag", generateRandomString(10));
    postdeviceInfoToServer(
        deviceName, deviceId, GetStorageData.getData("user_tag"));
  }

  postdeviceInfoToServer(deviceName, deviceId, userTag) async {
    Dio dio = Dio();
    await dio
        .post("${Constants.baseUrl()}${pageUrl}register.php", queryParameters: {
      "device_name": deviceName,
      "device_id": deviceId,
      "user_tag": userTag,
      "version": await Constants.versionApplication(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyText(
                txt: 'حساب',
                color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                size: 12,
                textAlign: TextAlign.right,
              ),
            ),
            GetBuilder<HomeDrawerController>(
                init: HomeDrawerController(),
                builder: (controller) {
                  return Column(
                    children: [
                      if ((GetStorageData.getData("user_logined") ?? false) ==
                          false)
                        ListTile(
                          onTap: () async {
                            // close drawer
                            Navigator.pop(context);
                            await Get.to(() => LoginScreen());
                          },
                          leading: Icon(Iconsax.login,
                              color: Theme.of(context).primaryIconTheme.color),
                          title: const MyText(txt: 'ورود به حساب کاربری'),
                        ),
                      if ((GetStorageData.getData("user_logined") ?? false) !=
                          false)
                        ListTile(
                          onTap: () async {
                            // show dialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const MyText(
                                      txt: "خروج از حساب کاربری",
                                      size: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    content: const MyText(
                                      txt: "آیا مطمئن هستید؟",
                                      size: 16,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const MyText(
                                          txt: "خیر",
                                          size: 16,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // close dialog
                                          Navigator.pop(context);
                                          // close drawer
                                          Navigator.pop(context);
                                          // clear data
                                          await GetStorageData.clear();
                                          Get.offAll(const Splash());
                                        },
                                        child: const MyText(
                                          txt: "بله",
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          leading: Icon(Iconsax.login,
                              color: Theme.of(context).primaryIconTheme.color),
                          title: const MyText(txt: 'خروج از حساب کاربری'),
                        ),
                    ],
                  );
                }),
            Divider(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(20)),
            ListTile(
              onTap: () {
                Scaffold.of(context).closeDrawer();
                Get.to(() => SupportPage());
              },
              leading: Icon(Iconsax.support,
                  color: Theme.of(context).primaryIconTheme.color),
              title: const MyText(txt: "چت با پشتیبانی"),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const CriticismPage());
              },
              leading: Icon(Iconsax.add_square,
                  color: Theme.of(context).primaryIconTheme.color),
              title: const MyText(txt: 'درخواست افزودن فیلم'),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const SavedVideoScreen(page: "bookmark"));
              },
              leading: Icon(Iconsax.save_2,
                  color: Theme.of(context).primaryIconTheme.color),
              title: const MyText(txt: 'ذخیره شده ها'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyText(
                txt: 'دیگر پلتفرم ها',
                color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                size: 12,
                textAlign: TextAlign.right,
              ),
            ),
            ListTile(
              onTap: () {
                // Get.to(() => const SavedVideoScreen(page: "bookmark"));
                // open url
                CinimoConfig config = configDataGetter();
                openUrl(config.config!.telegram!);
              },
              leading: Icon(LineAwesome.telegram,
                  color: Theme.of(context).primaryIconTheme.color),
              title: const MyText(txt: "کانال تلگرام ما"),
            ),
            ListTile(
              onTap: () {
                CinimoConfig config = configDataGetter();
                openUrl(config.config!.instgram!);
              },
              leading: Icon(LineAwesome.instagram,
                  color: Theme.of(context).primaryIconTheme.color),
              title: const MyText(txt: "پیج اینستاگرام"),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyText(
                txt: 'مالی',
                color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                size: 12,
                textAlign: TextAlign.right,
              ),
            ),
            ListTile(
              onTap: () {
                Scaffold.of(context).closeDrawer();
                donateBottomSheet(context);
              },
              leading: Icon(BoxIcons.bx_donate_heart,
                  color: Theme.of(context).primaryIconTheme.color),
              title: const MyText(txt: "حمایت و دونیت"),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

CinimoConfig configDataGetter() {
  // print(CinimoConfig.fromJson(json.decode(GetStorageData.getData("config"))));

  try {
    CinimoConfig config =
        CinimoConfig.fromJson(json.decode(GetStorageData.getData("config")));

    return config;
  } catch (e) {
    CinimoConfig config = CinimoConfig(config: Config());
    return config;
  }
}

// function to open url
Future<void> openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void donateBottomSheet(context) {
  Get.bottomSheet(
    ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: Container(
        // height: 250,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            MyText(
              txt: "حمایت و دونیت",
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 30),
            //  Show payment unit
            //  show radio button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // open url
                    Get.back();
                    CinimoConfig config = configDataGetter();
                    openUrl(config.config!.iranDonateGetWay!);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.black),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      MyText(
                        txt: "ریالی",
                        size: 16,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      CachedNetworkImage(
                        imageUrl: configDataGetter().config!.irPicGetway!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // open url
                    Get.back();
                    CinimoConfig config = configDataGetter();
                    openUrl(config.config!.dollorDonateGetWay!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      MyText(
                        txt: "دلاری",
                        size: 16,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      CachedNetworkImage(
                        imageUrl: configDataGetter().config!.dollorPicGateway!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
