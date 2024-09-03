import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/saved_screen.dart';

import '../../../../core/utils/database_helper.dart';
import '../../../../locator.dart';
import 'home_header_item.dart';
import 'last_played.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  DictionaryDataBaseHelper dbHelper = locator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GetBuilder<HomePageController>(builder: (controller) {
                return Row(
                  children: [
                    controller.favoriteList.isEmpty
                        ? Container()
                        : HomeHeaderItem(
                            title: 'مورد علاقه',
                            icon: Icons.favorite_rounded,
                            onPresses: () {
                              Get.to(() =>
                                  const SavedVideoScreen(page: "favorite"));
                            },
                          ),
                    controller.downloadList.isEmpty
                        ? Container()
                        : HomeHeaderItem(
                            title: 'دانلود شده ها',
                            icon: Icons.download_rounded,
                            onPresses: () {},
                          ),
                    controller.historyList.isEmpty
                        ? Container()
                        : HomeHeaderItem(
                            title: 'آخرین پخش',
                            icon: Icons.history_rounded,
                            onPresses: () {
                              Get.to(() => const LastPlayerScreen());
                            },
                          ),
                    controller.bookmarkList.isEmpty
                        ? Container()
                        : HomeHeaderItem(
                            title: 'نشان شده ها',
                            icon: Icons.bookmark_rounded,
                            onPresses: () {
                              Get.to(() =>
                                  const SavedVideoScreen(page: "bookmark"));
                            },
                          ),
                  ],
                );
              }),
            ),
          ),
          stretchModes: const [
            // StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle
          ],
          titlePadding:
              const EdgeInsetsDirectional.only(start: 10.0, bottom: 16.0),
        ),
      ],
    );
  }
}
