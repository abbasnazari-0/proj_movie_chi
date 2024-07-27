import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/resources/home_view_exported.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/home_views/countinuios_wathcing.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_artist_widgets.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_shimmer.dart';
import '../../../data/model/home_catagory_item_model.dart';
import '../../../data/model/home_catagory_model.dart';

import '../../widgets/home_zhanner_view.dart';

// ignore: must_be_immutable
class HomeScreenContent extends StatelessWidget {
  HomeScreenContent({
    super.key,
  });

  ScrollController scrollController = ScrollController();

  bool searchListAndMap(String searchTerm, List<HomeCatagagoryItemModel> list) {
    for (HomeCatagagoryItemModel map in list) {
      if (map.title!.contains(searchTerm)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<HomePageController>(builder: (controller) {
      return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        onRefresh: () async {
          await controller.getHomeCatagoryData(false);
          controller.refreshController.refreshCompleted();
        },
        onLoading: () async {
          await controller.getHomeCatagoryData(true);
          controller.refreshController.loadComplete();
        },
        controller: controller.refreshController,
        child: (controller.homepageStatus == PageStatus.loading)
            ? HomeShimmerContent(height: height, width: width)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (double.parse(
                            controller.packageInfo?.buildNumber ?? '0') <
                        double.parse(controller
                                .homeCatagory?.data?.setting?.androidVersion ??
                            "0"))
                      UpdateWidget(),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          ((controller.homeCatagory?.data?.data?.length) ?? 0),
                      itemBuilder: (context, index) {
                        HomeCatagoryItemModel homeCatagoryItem =
                            controller.homeCatagory!.data!.data![index];

                        switch (homeCatagoryItem.viewName) {
                          case "carousel_slider":
                            return Column(
                              children: [
                                HomeGalleryVideos(
                                    itemGalleryData: homeCatagoryItem),
                                if ((GetStorageData.getData("logined") ??
                                    false))
                                  HomeZhannerView(width: width),
                                const Gap(10),
                                if ((GetStorageData.getData("logined") ??
                                    false))
                                  ArtistHomeWidget()
                              ],
                            );
                          case "extended_slider":
                            return ExtendedSliderHomeView(
                                homeCatagoryItem: homeCatagoryItem);
                          case "banner":
                            return HomeBannerView(
                                homeCatagoryItem: homeCatagoryItem);
                          case "catagory":
                            return CatagoryHomeView(
                                homeCatagoryItem: homeCatagoryItem);
                          case "mini_slider":
                            return MiniSliderView(
                                homeCatagoryItem: homeCatagoryItem);
                          case "grid":
                            return GridHomeView(
                                homeCatagoryItem: homeCatagoryItem);
                          case "continue_watchin":
                            if (controller.historyList.isNotEmpty) {
                              return CountinuisWatching(
                                  homeCatagoryItem: homeCatagoryItem);
                            } else {
                              return Container();
                            }
                          default:
                            return Container();
                        }
                      },
                    ),
                    if ((GetStorageData.getData("logined") ?? false))
                      HomeZhannerView(width: width),
                  ],
                ),
              ),
      );
    });
  }
}

class UpdateWidget extends StatelessWidget {
  UpdateWidget({
    super.key,
  });

  final HomePageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      // height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(10),
          MyText(
            txt: controller.homeCatagory?.data?.setting?.updateTitle ?? "",
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          MyText(
            txt: controller.homeCatagory?.data?.setting?.updateDesc ?? "",
            size: 14,
          ),
          const Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: MyButton(
              onPressed: () {
                Constants.urlLauncher(
                    controller.homeCatagory?.data?.setting?.updateUrl ?? "");
              },
              icon: Icons.download,
              text: 'نصب',
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
