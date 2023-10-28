import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/home_views/home_causoul_slider.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_shimmer.dart';
import '../../../data/model/home_catagory_item_model.dart';
import '../../../data/model/home_catagory_model.dart';

import '../../widgets/home_artist_widgets.dart';
import '../../widgets/home_zhanner_view.dart';
import 'home_views/catagory_home_view.dart';
import 'home_views/countinuios_wathcing.dart';
import 'home_views/extended_slider_home_view.dart';
import 'home_views/grid_home_view.dart';
import 'home_views/home_banner_view.dart';
import 'home_views/mini_slider_home_view.dart';

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
                    // if (controller.artistData.isNotEmpty)
                    //   SizedBox(
                    //     width: double.infinity,
                    //     height: 120,
                    //     child: ListView.separated(
                    //       separatorBuilder: (context, index) => SizedBox(
                    //         width: 10,
                    //       ),
                    //       itemCount: countryJsonData.length,
                    //       scrollDirection: Axis.horizontal,
                    //       padding: const EdgeInsets.symmetric(horizontal: 10),
                    //       itemBuilder: (context, index) {
                    //         Map item = countryJsonData[index];
                    //         return Column(
                    //           children: [
                    //             ClipRRect(
                    //               borderRadius: BorderRadius.circular(9999),
                    //               child: SvgPicture.network(
                    //                 "https://hatscripts.github.io/circle-flags/flags/${item['code'].toString().toLowerCase()}.svg",
                    //                 width: 80,
                    //               ),
                    //             ),
                    //             SizedBox(height: 10),
                    //             MyText(
                    //               txt: item['name_fa'],
                    //             )
                    //           ],
                    //         );
                    //       },
                    //     ),
                    //   ),
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
