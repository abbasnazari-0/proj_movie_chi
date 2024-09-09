import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/download_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/f_bottom_navigation.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_header_widget.dart';
import 'package:movie_chi/features/feature_search/presentation/controller/home_searchbar_controller.dart';
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
import 'package:movie_chi/features/feature_search/presentation/pages/search_page.dart';

// import '../../../../core/ad/ad_controller.dart';
import '../../../feature_detail_page/presentation/controllers/detail_page_controller.dart';
import '../../../feature_search/presentation/controller/search_page_controller.dart';
import '../../../feature_series_movies/presentations/widgets/film_header_widget.dart';
import '../../../feature_series_movies/presentations/widgets/serias_header_widget.dart';
import '../widgets/home_drawer.dart';
import 'screen_contents/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static String routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final searchController = Get.find<SearchPageController>();
  final homePageController = Get.find<HomePageController>();
  // final adController = Get.put(AdController());
  final downloadController = Get.find<DownloadPageController>();

  final pageController = Get.find<DetailPageController>();

  //Method that to run url with url_launcher

  final bottomAppBarController = Get.put(BottomAppBarController());

  bool supportedArea = ((GetStorageData.getData("logined") ?? false));

  @override
  void initState() {
    super.initState();
    homePageController.checkVideoStatus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //Change StatusBarColor

    final height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          // ignore: unrelated_type_equality_checks
          if (bottomAppBarController.itemSected == 0) {
            return true;
          } else {
            bottomAppBarController.chnageItemSelected(0.obs);
            bottomAppBarController.pageController.jumpToPage(0);
            return false;
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: supportedArea
              ? HomeBottomNavigationBar()
              : FBottomNavigationBar(),
          drawer: const HomeDrawer(),
          body: PageView.builder(
            controller: bottomAppBarController.pageController,
            onPageChanged: (value) {
              // bottomAppBarController.chnageItemSelected(value.obs);
            },
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return GetBuilder<HomePageController>(builder: (context) {
                    return NestedScrollView(
                      body: RefreshIndicator(
                          onRefresh: () async {
                            await pageController.checkUSers();
                            return homePageController.getHomeCatagoryData(false,
                                withClear: true);
                          },
                          child: HomeScreenContent()),
                      physics: const BouncingScrollPhysics(),
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            // toolbarHeight: toolbarHeoght,
                            backgroundColor: Colors.black54,
                            // backgroundColor:
                            //     Theme.of(context).colorScheme.surface,
                            // floating: true,
                            automaticallyImplyLeading: false,

                            pinned: true,
                            toolbarHeight: 60,
                            elevation: 5,
                            excludeHeaderSemantics: true,
                            primary: true,
                            snap: true,
                            floating: true,
                            // foregroundColor: Colors.red,
                            title: HomeHeaderBar(),
                          )
                        ];
                      },
                    );
                  });
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
                          toolbarHeight: 140,
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
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: AppAppBar(height: height),
                              ),
                              SeriasHeader()
                            ],
                          ),
                        )
                      ];
                    },
                  );
                case 3:
                  return const ReelsScreemContent();
                case 4:
                  return // search Content
                      GetBuilder<HomeSearchBarController>(
                          builder: (controller) {
                    return SafeArea(
                      child: NestedScrollView(
                        floatHeaderSlivers: true,
                        body: const SearchPage(),
                        physics: const BouncingScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              // automaticallyImplyLeading: false,
                              toolbarHeight: 60,
                              //     ? toolbarHeoght + 50 + 50 + 20 + 70
                              //     : toolbarHeoght,
                              // backgroundColor:
                              //     Theme.of(context).colorScheme.background,
                              floating: true,
                              snap: true,
                              leading: const SizedBox(),
                              flexibleSpace: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    // AppAppBar(height: height),
                                    Row(
                                      children: [
                                        const Gap(10),
                                        IconButton(
                                          onPressed: () {
                                            bottomAppBarController
                                                .chnageItemSelected(0.obs);
                                            bottomAppBarController
                                                .chnagePageViewSelected(0.obs);

                                            homePageController
                                                .changeBottomNavIndex(0);
                                          },
                                          icon: Icon(Iconsax.arrow_right_3,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                        ),
                                        const Gap(10),
                                        const Expanded(child: HomeSearchBar()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ];
                        },
                      ),
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
                          toolbarHeight: 60,
                          automaticallyImplyLeading: false,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          stretch: true,
                          pinned: true,
                          flexibleSpace: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: AppAppBar(height: height),
                                ),
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
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
