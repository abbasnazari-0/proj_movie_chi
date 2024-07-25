import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart' as iconSax;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/bottom_app_bar_controller.dart';

import '../controller/home_page_controller.dart';
import 'home_drawer.dart';

class FBottomNavigationBar extends StatelessWidget {
  FBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  final bottomAppBarController = Get.find<BottomAppBarController>();
  final homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomAppBarController>(builder: (controller) {
      // for prevent show bottom navigation  in search page
      if (controller.itemSected == 4.obs) {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
      return Container(
        height:
            controller.cinimoconfig?.config?.showBanner == "true" ? 172 : 100,
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
              child: GetBuilder<BottomAppBarController>(builder: (controller) {
                return SalomonBottomBar(
                  currentIndex: bottomAppBarController.itemSected.toInt(),
                  selectedItemColor: Theme.of(context).colorScheme.secondary,
                  unselectedItemColor: Colors.grey.shade700,
                  items: [
                    SalomonBottomBarItem(
                      icon: const Icon(iconSax.Iconsax.home_24),
                      title: const MyText(txt: 'خانه'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.slow_motion_video_rounded),
                      title: const MyText(txt: 'ریلیزو'),
                    ),
                  ],
                  onTap: ((value) {
                    switch (value) {
                      case 0:
                        changePage(0, value);
                        break;
                      case 1:
                        changePage(3, value);

                        break;
                      default:
                    }
                  }),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  changePage(int page, int value) {
    bottomAppBarController.chnageItemSelected(value.obs);
    bottomAppBarController.chnagePageViewSelected(page.obs);
    homePageController.changeBottomNavIndex(page);
  }
}
