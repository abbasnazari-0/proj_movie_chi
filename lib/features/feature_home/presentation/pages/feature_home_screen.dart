import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/controllers/download_page_controller.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_profile/presentations/pages/feature_profile.dart';
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
import 'package:movie_chi/locator.dart';

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

  final bottomAppBarController = Get.put(BottomAppBarController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //Change StatusBarColor

    final height = MediaQuery.of(context).size.height;

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
            backgroundColor: Theme.of(context).colorScheme.surface,
            bottomNavigationBar: HomeBottomNavigationBar(),
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
                    return NestedScrollView(
                      body: HomeScreenContent(),
                      physics: const BouncingScrollPhysics(),
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          GetBuilder<HomePageController>(builder: (controller) {
                            return SliverAppBar(
                              // toolbarHeight: toolbarHeoght,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              // floating: true,
                              automaticallyImplyLeading: false,

                              pinned: true,
                              toolbarHeight: 50,
                              // collapsedHeight: 0,
                              // titleSpacing: ,
                              elevation: 10,
                              excludeHeaderSemantics: true,
                              // titleSpacing: 10,

                              // excludeHeaderSemantics: true,

                              // flexibleSpace: controller.hasDataInlocaStorage
                              //     ? const HomeHeader()
                              //     : Container(),
                              // stretch: true,
                              primary: true,
                              snap: true,
                              // expandedHeight: -50,
                              // collapsedHeight: 0,

                              //     controller.hasDataInlocaStorage ? 100 : 0,
                              floating: true,
                              title: Column(
                                children: [
                                  // AppAppBar(height: height),
                                  // const SocialHeader()
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      // AppAppBar(height: height),
                                      // const SocialHeader()
                                      IconButton(
                                          onPressed: () {
                                            bottomAppBarController
                                                .chnageItemSelected(4.obs);
                                            bottomAppBarController
                                                .chnagePageViewSelected(4.obs);

                                            homePageController
                                                .changeBottomNavIndex(4);
                                          },
                                          icon: const Icon(
                                              Iconsax.search_normal4)),
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

                                      IconButton(
                                        onPressed: () async {
                                          if ((GetStorageData.getData(
                                                      "user_logined") ??
                                                  false) ==
                                              false) {
                                            await Get.to(() => LoginScreen());
                                          } else {
                                            Get.to(() => const ProfileScreen());
                                          }
                                        },
                                        icon: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child:
                                              const Icon(Iconsax.user_octagon4),
                                        ),
                                      )
                                    ],
                                  )
                                ],
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
                                                  .chnagePageViewSelected(
                                                      0.obs);

                                              homePageController
                                                  .changeBottomNavIndex(0);
                                            },
                                            icon: Icon(Iconsax.arrow_right_3,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                          ),
                                          const Gap(10),
                                          const Expanded(
                                              child: HomeSearchBar()),
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
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
