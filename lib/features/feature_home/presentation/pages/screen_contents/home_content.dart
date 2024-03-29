import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/resources/home_view_exported.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_shimmer.dart';
import '../../../data/model/home_catagory_item_model.dart';
import '../../../data/model/home_catagory_model.dart';

import '../../widgets/home_artist_widgets.dart';
import '../../widgets/home_zhanner_view.dart';
import 'home_views/countinuios_wathcing.dart';

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
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () async {
          await controller.getHomeCatagoryData(false);
          controller.refreshController.refreshCompleted();
        },
        onLoading: () async {
          await controller.getHomeCatagoryData(true);
          controller.refreshController.loadComplete();
        },
        //     // header: WaterDropMaterialHeader(
        //     //   backgroundColor: Theme.of(context).colorScheme.secondary,
        //     //   color: Theme.of(context).colorScheme.background,
        //     // ),
        controller: controller.refreshController,
        child: (controller.homepageStatus == PageStatus.loading)
            ? HomeShimmerContent(height: height, width: width)
            : SingleChildScrollView(
                child: Column(
                  children: [
// contact detial
                    const Column(),

                    if (controller.artistData.isNotEmpty) ArtistHomeWidget(),

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
                            return HomeGalleryVideos(
                                itemGalleryData: homeCatagoryItem);

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
                    if (controller.zhannerList.isNotEmpty)
                      HomeZhannerView(width: width),
                  ],
                ),
              ),
      );
    });
  }
}
