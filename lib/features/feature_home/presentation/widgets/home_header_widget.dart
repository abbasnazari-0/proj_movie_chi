import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

import 'package:movie_chi/features/feature_home/presentation/controller/bottom_app_bar_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_profile/presentations/pages/feature_profile.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/search_page_controller.dart';

class HomeHeaderBar extends StatelessWidget {
  HomeHeaderBar({
    super.key,
  });
  final searchController = Get.find<SearchPageController>();
  final homePageController = Get.find<HomePageController>();
  // final adController = Get.put(AdController());

  final bottomAppBarController = Get.put(BottomAppBarController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if ((GetStorageData.getData("Authorizedd") ?? false))
          IconButton(
              onPressed: () {
                bottomAppBarController.chnageItemSelected(4.obs);
                bottomAppBarController.chnagePageViewSelected(4.obs);

                homePageController.changeBottomNavIndex(4);
              },
              icon: const Icon(Iconsax.search_normal4)),
        const Spacer(),
        Image.asset(
          'assets/images/icon.png',
          height: 30,
        ),
        const MyText(
          txt: 'مووی چی!؟',
          size: 24 / 1.618,
          fontWeight: FontWeight.bold,
        ),
        const Spacer(),
        if ((GetStorageData.getData("Authorizedd") ?? false))
          IconButton(
            onPressed: () async {
              if ((GetStorageData.getData("user_logined") ?? false) == false) {
                await Get.toNamed(LoginScreen.routeName);
              } else {
                Get.to(() => const ProfileScreen());
              }
            },
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(50)),
              child: const Icon(Iconsax.user_octagon4),
            ),
          )
      ],
    );
  }
}
