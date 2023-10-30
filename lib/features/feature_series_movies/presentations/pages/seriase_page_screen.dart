import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/resources/home_view_exported.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';

import 'package:movie_chi/features/feature_series_movies/presentations/controllers/seriase_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../core/utils/page_status.dart';
import '../../../feature_home/presentation/widgets/search_shimmer.dart';
import '../../../feature_search/presentation/widgets/custom_footer_refresh.dart';

class SeriaseScreen extends StatelessWidget {
  const SeriaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeriasController>(builder: (controller) {
      if (controller.pageStatus == PageStatus.error) {
        return const Center(
          child: Text("Error"),
        );
      }
      return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: controller.refreshController,
        footer: const RefreshCustomWidget(),
        onLoading: () {
          controller.getSerias(false);
        },
        child: (controller.pageStatus == PageStatus.loading)
            ? const SearchShimmer()
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ((controller.homeCatagory?.data?.data?.length) ?? 0),
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
                      return HomeBannerView(homeCatagoryItem: homeCatagoryItem);
                    case "catagory":
                      return CatagoryHomeView(
                          homeCatagoryItem: homeCatagoryItem);
                    case "mini_slider":
                      return MiniSliderView(homeCatagoryItem: homeCatagoryItem);
                    case "grid":
                      return GridHomeView(homeCatagoryItem: homeCatagoryItem);

                    default:
                      return Container();
                  }
                },
              ),
      );
    });
  }
}
