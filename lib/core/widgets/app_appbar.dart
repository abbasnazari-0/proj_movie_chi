import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:badges/badges.dart' as badges;

import '../../features/feature_home/presentation/controller/bottom_app_bar_controller.dart';
import '../../features/feature_home/presentation/controller/home_page_controller.dart';
import '../utils/constants.dart';
import 'mytext.dart';

class AppAppBar extends StatelessWidget {
  AppAppBar({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;
  final homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Iconsax.menu,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            onPressed: () {
              Scaffold.maybeOf(context)!.openDrawer();
            },
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // showPrivacyDialog();
              // homePageController.showIpDialog();

              // LocalNotificationService.displayLocal();
              // showGeneralSnackBar("خطا", "خطا در اتصال به سرور");
            },
            child: Image.asset(
              'assets/images/icon.png',
              height: 30,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          MyText(
            txt: 'مووی چی!',
            color: Theme.of(context).primaryIconTheme.color,
            fontWeight: FontWeight.w900,
            size: 16.sp,
          ),
          const Spacer(),
          // IconButton(
          //   icon: Icon(
          //     BoxIcons.bx_donate_heart,
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   onPressed: () async {
          //     donateBottomSheet(context);
          //     // if (await AdaptiveTheme.getThemeMode() ==
          //     //     AdaptiveThemeMode.light) {
          //     //   await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
          //     // } else {
          //     //   await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
          //     // }
          //     // AdaptiveTheme.maybeOf(context)?.toggleThemeMode();
          //   },
          // ),
          IconButton(
            icon: Icon(
              FontAwesome.masks_theater,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            onPressed: () async {
              // final homePageController = Get.find<HomePageController>();
              if (homePageController.updateBadge) {
                homePageController.updatingBadge(false);
              }

              // change bottom nav index to download
              final bottomAppBarController = Get.find<BottomAppBarController>();

              bottomAppBarController.chnageItemSelected(5.obs);
              bottomAppBarController.chnagePageViewSelected(5.obs);

              // homePageController.changeBottomNavIndex(3.obs);
            },
          ),
          if (Constants.allowToShowAd())
            IconButton(
              icon: badges.Badge(
                position: badges.BadgePosition.bottomStart(),
                showBadge: homePageController.updateBadge,
                child: Icon(
                  BoxIcons.bx_download,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onPressed: () async {
                // final homePageController = Get.find<HomePageController>();
                if (homePageController.updateBadge) {
                  homePageController.updatingBadge(false);
                }

                // change bottom nav index to download
                final bottomAppBarController =
                    Get.find<BottomAppBarController>();

                bottomAppBarController.chnageItemSelected(6.obs);
                bottomAppBarController.chnagePageViewSelected(6.obs);

                // homePageController.changeBottomNavIndex(3.obs);
              },
            ),
          IconButton(
            icon: Icon(
              BoxIcons.bx_moon,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            onPressed: () async {
              // if (await AdaptiveTheme.getThemeMode() ==
              //     AdaptiveThemeMode.light) {
              //   await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
              // } else {
              //   await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
              // }
              AdaptiveTheme.maybeOf(context)?.toggleThemeMode();
            },
          ),
        ],
      ),
    );
  }
}
