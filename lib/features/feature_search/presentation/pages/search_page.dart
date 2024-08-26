import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/empty_search_screen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/search_shimmer.dart';

import '../../../../core/utils/page_status.dart';
import '../../../../core/models/search_video_model.dart';
import '../controller/search_page_controller.dart';
import '../widgets/custom_footer_refresh.dart';
import '../widgets/empty_search_page.dart';
import '../widgets/search_screen_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List data = [];
  bool isloading = true;
  var searchController = Get.find<SearchPageController>();
  void onloadig() {
    // isloading = !isloading;
    // searchController.loadingChanger(!searchController.searchLoader.value);
  }
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var lastOneDetected = false;
  int itemCount = 25;
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<SearchPageController>(
                builder: (controller) {
                  if (controller.searchPageStatus == PageStatus.empty) {
                    return const EmptyPage();
                  }
                  if (controller.searchData.data!.isEmpty &&
                      controller.searchPageStatus == PageStatus.error) {
                    return const SearchEmptyScreen();
                  } else {
                    return SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: true,
                      controller: refreshController,
                      footer: const RefreshCustomWidget(),
                      onLoading: () {
                        searchController.onstartLoadSearch(false,
                            withChangePage: false,
                            refreshController: refreshController);
                      },
                      child: (controller.searchPageStatus == PageStatus.loading)
                          ? const SearchShimmer()
                          : GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent:
                                          MediaQuery.of(context).size.height *
                                              0.27,
                                      crossAxisCount: 3),
                              itemCount: controller.searchData.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                SearchVideo item =
                                    controller.searchData.data![index];
                                return SearchItem(item: item);
                              },
                            ),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
