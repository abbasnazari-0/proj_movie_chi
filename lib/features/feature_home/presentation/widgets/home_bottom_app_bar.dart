import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iconsax/iconsax.dart' as iconSax;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/bottom_app_bar_controller.dart';

import '../controller/home_page_controller.dart';
import 'home_drawer.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  HomeBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  final bottomAppBarController = Get.find<BottomAppBarController>();
  final homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomAppBarController>(builder: (controller) {
      return Container(
        height:
            controller.cinimoconfig?.config?.showBanner == "true" ? 172 : 72,
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            if (controller.cinimoconfig != null &&
                controller.cinimoconfig?.config?.showBanner == "true")
              InkWell(
                onTap: () {
                  if (controller.cinimoconfig?.config?.bannerActionType ==
                      "link") {
                    controller.cinimoconfig?.config?.bannerActionData != null
                        ? openUrl(
                            controller.cinimoconfig!.config!.bannerActionData!)
                        : null;
                  }
                },
                child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondary,
                    child: CachedNetworkImage(
                      imageUrl:
                          controller.cinimoconfig!.config!.bannerPictureUrl!,
                      fit: BoxFit.fill,
                    )),
              ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              height: 1,
              thickness: 1.5,
            ),
            SizedBox(
              height: 70,
              child: GetBuilder<BottomAppBarController>(builder: (controller) {
                return SalomonBottomBar(
                  currentIndex: bottomAppBarController.itemSected.toInt(),

                  // backgroundColor: Theme.of(context).primaryColor,
                  selectedItemColor: Theme.of(context).colorScheme.secondary,
                  unselectedItemColor: Colors.grey.shade700,
                  items: [
                    SalomonBottomBarItem(
                      icon: const Icon(iconSax.Iconsax.home_24),
                      title: const MyText(txt: 'خانه'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(BoxIcons.bx_movie),
                      title: const MyText(txt: 'فیلم'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.video_library),
                      title: const MyText(txt: 'سریال'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(iconSax.Iconsax.search_normal4),
                      title: const MyText(txt: 'جستجو'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.slow_motion_video_rounded),
                      title: const MyText(txt: 'ریلیزو'),
                    ),

                    // SalomonBottomBarItem(
                    //   icon: const Icon(Iconsax.star4),
                    //   title: const MyText(txt: 'نشان شده ها'),
                    // ),
                    // SalomonBottomBarItem(
                    //   icon: const Icon(Iconsax.profile_circle5),
                    //   title: const MyText(txt: 'پروفایل'),
                    // )
                  ],
                  onTap: ((value) {
                    bottomAppBarController.chnageItemSelected(value.obs);
                    bottomAppBarController.chnagePageViewSelected(value.obs);

                    homePageController.changeBottomNavIndex(value);
                  }),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
