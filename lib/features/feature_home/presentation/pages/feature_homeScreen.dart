// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/download_page_controller.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/home_searchbar_controller.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/search_filter_items.dart';
import 'package:movie_chi/features/feature_series_movies/presentations/pages/movies_page_screen.dart';
import 'package:movie_chi/features/feature_series_movies/presentations/pages/seriase_page_screen.dart';
import 'package:movie_chi/core/widgets/app_appbar.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/bottom_app_bar_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/download_content.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/reels_content.dart';
import 'package:movie_chi/features/feature_zhanner/presentation/pages/zhanner_content.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_bottom_app_bar.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_search_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_chi/features/feature_search/presentation/pages/search_page.dart';
import 'package:movie_chi/locator.dart';

// import '../../../../core/ad/ad_controller.dart';
import '../../../../core/widgets/header_social.dart';
import '../../../feature_detail_page/presentation/controllers/detail_page_controller.dart';
import '../../../feature_search/presentation/controller/search_page_controller.dart';
import '../../../feature_series_movies/presentations/widgets/film_header_widget.dart';
import '../../../feature_series_movies/presentations/widgets/serias_header_widget.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_header.dart';
import 'screen_contents/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final searchController = Get.put(SearchPageController(locator()));
  final homePageController = Get.put(HomePageController(locator(), locator()));
  // final adController = Get.put(AdController());
  final downloadController = Get.put(DownloadPageController());

  final pageController =
      Get.put(DetailPageController(locator(), null, locator()));

  //Method that to run url with url_launcher
  void _launchUrl(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  final bottomAppBarController = Get.put(BottomAppBarController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //Change StatusBarColor

    final height = MediaQuery.of(context).size.height;

    const double toolbarHeoght = 150.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (bottomAppBarController.itemSected.value == 0) {
            return true;
          } else {
            bottomAppBarController.chnageItemSelected(0.obs);
            bottomAppBarController.pageController.jumpToPage(0);
            return false;
          }
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            bottomNavigationBar: HomeBottomNavigationBar(),
            drawer: const HomeDrawer(),
            body: SafeArea(
              child: PageView.builder(
                controller: bottomAppBarController.pageController,
                onPageChanged: (value) {
                  // bottomAppBarController.chnageItemSelected(value.obs);
                },
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return // Home Page
                          NestedScrollView(
                        body: HomeScreenContent(),
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            GetBuilder<HomePageController>(
                                builder: (controller) {
                              return SliverAppBar(
                                // toolbarHeight: toolbarHeoght,
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                // floating: true,
                                automaticallyImplyLeading: false,

                                pinned: true,
                                toolbarHeight: 100,
                                // collapsedHeight: 50,
                                // excludeHeaderSemantics: true,

                                flexibleSpace: controller.hasDataInlocaStorage
                                    ? const HomeHeader()
                                    : Container(),
                                stretch: true,
                                expandedHeight:
                                    controller.hasDataInlocaStorage ? 180.h : 0,

                                title: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                  ),
                                  child: Column(
                                    children: [
                                      AppAppBar(height: height),
                                      const SocialHeader()
                                    ],
                                  ),
                                ),
                              );
                            })
                          ];
                        },
                      );

                    // films
                    case 1:
                      return // search Content
                          NestedScrollView(
                        floatHeaderSlivers: true,
                        body: const MoviesScreen(),
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              toolbarHeight: 130,
                              // expandedHeight: 60,
                              pinned: true,
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              stretch: true,
                              title: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: AppAppBar(height: height),
                                  ),
                                  FilmHeader()
                                ],
                              ),
                            )
                          ];
                        },
                      );
                    // serials
                    case 2:
                      return NestedScrollView(
                        floatHeaderSlivers: true,
                        body: const SeriaseScreen(),
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              toolbarHeight: 130,
                              automaticallyImplyLeading: false,
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              stretch: true,
                              pinned: true,
                              title: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: AppAppBar(height: height),
                                  ),
                                  SeriasHeader()
                                ],
                              ),
                            )
                          ];
                        },
                      );
                    case 4:
                      return const ReelsScreemContent();
                    case 3:
                      return // search Content
                          GetBuilder<HomeSearchBarController>(
                              builder: (controller) {
                        return NestedScrollView(
                          floatHeaderSlivers: true,
                          body: const SearchPage(),
                          physics: const BouncingScrollPhysics(),
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                automaticallyImplyLeading: false,
                                toolbarHeight: controller.advancedFilter
                                    ? toolbarHeoght + 50 + 50 + 20 + 70
                                    : toolbarHeoght + 70,
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                flexibleSpace: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      AppAppBar(height: height),
                                      const HomeSearchBar(),

                                      // check box filter
                                      CheckboxListTile(
                                        value: controller.advancedFilter,
                                        onChanged: (val) {
                                          controller.changeAdvancedFilter(val!);
                                        },
                                        title: const MyText(
                                          txt: "فیلتر پیشرفته",
                                        ),
                                      ),
                                      // SizedBox(height: 10.h),
                                      if (controller.advancedFilter)
                                        const SearchFilterParent(),
                                    ],
                                  ),
                                ),
                              )
                            ];
                          },
                        );
                      });
                    case 5:
                      return NestedScrollView(
                        floatHeaderSlivers: true,
                        body: const ZhannerList(),
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              toolbarHeight: 80,
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              flexibleSpace: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    AppAppBar(height: height),
                                  ],
                                ),
                              ),
                            )
                          ];
                        },
                      );

                    case 6:
                      return NestedScrollView(
                        floatHeaderSlivers: true,
                        body: const DownloadContent(),
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              toolbarHeight: 80,
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              flexibleSpace: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    AppAppBar(height: height),
                                  ],
                                ),
                              ),
                            )
                          ];
                        },
                      );
                    default:
                      return Container();
                  }
                },
                itemCount: 7,
              ),
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
