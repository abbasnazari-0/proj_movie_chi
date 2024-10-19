import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/core/utils/convert_to_decimal_number.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/home_page_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/tv_controller/search_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/tv_controller/slider_controller.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/home_views/countinuios_wathcing.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/home_shimmer.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_profile/presentations/pages/feature_profile.dart';
import 'package:movie_chi/features/feature_search/presentation/widgets/search_screen_item.dart';
import 'package:movie_chi/locator.dart';

// ignore: must_be_immutable
class AndroidTVScreen extends StatelessWidget {
  AndroidTVScreen({super.key});

  final androidTvSliderController = Get.put(
    AndroidTVSliderController(
      Get.find<HomePageController>().homeCatagory!.data!.data![0].data!,
      locator(),
    ),
  );

  final homePageController = Get.find<HomePageController>();

  Widget indexingWidget(Widget widget, double index) {
    return GetBuilder<AndroidTVSliderController>(
      builder: (controller) {
        return Container(
          padding: index == controller.itemIndex
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
              : null,
          // width:  widget.toString().length * 10,
          decoration: BoxDecoration(
            color: index == controller.itemIndex ? Colors.black : null,
            border: index == controller.itemIndex
                ? Border.all(color: Colors.white, width: 2)
                : null,
            borderRadius: BorderRadius.circular(999),
          ),
          child: widget,
        );
      },
    );
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerItems = ScrollController();

  double prevItemValue = 0.0;

  onClick(double id) async {
    if (id.toInt() < 2) {
      switch (id.toString()) {
        case "0.00": //home
          break;
        case "0.01": //home
          break;

        case "0.02": //home
          break;
        case "0.03": //home
          break;
        case "0.04": //search
          AndroidTvSearchController().openSearchBox();

          break;
        case "0.05": //home
          //  if ((GetStorageData.getData("logined") ??
          //                                 false))

          if ((GetStorageData.getData("user_logined") ?? false) == false) {
            await Get.toNamed(LoginScreen.routeName);
          } else {
            if (MediaQuery.of(Get.context!).size.width < 600) {
              Get.to(() => const ProfileScreen());
            } else {
              Scaffold.of(Get.context!).openDrawer();
            }
          }

          break;
        case "1.0": //home
          androidTvSliderController
              .playVideo(androidTvSliderController.sliderVideo);

          break;
        case "1.01": //home
          break;
      }
    }

    if (id.toInt() >= 2) {
      int listVideoIndex = id.toInt() - 2;
      int videoIndex = int.parse(id.toString().split(".")[1]);

      androidTvSliderController.itemIndex = 1.0;

      androidTvSliderController.changeVideo(
          homePageController
              .homeCatagory!.data!.data![listVideoIndex].data![videoIndex],
          withStop: true);
    }
  }

  openVideoPlayer(SearchVideo videoSearchData) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      body: GetBuilder<HomePageController>(builder: (controller) {
        if ((controller.homepageStatus == PageStatus.loading)) {
          HomeShimmerContent(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width);
        }
        return RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: dsds,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GetBuilder<AndroidTVSliderController>(
                      id: "slider",
                      builder: (controller) {
                        return AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: androidTvSliderController
                                      .sliderVideo.thumbnail1x ??
                                  ""),
                        );
                        // 'https://cdn.tejaratnews.com/thumbnail/VxpFThqyOBL4/3UrEgAVS4xbeIimTa4KLHQZLM6uiOqK7qCBP0gQuvUQOAARzGG_Fv-aZ-Ag2Yzc4/%D8%AF%D8%A7%D9%86%D9%84%D9%88%D8%AF+%D9%81%DB%8C%D9%84%D9%85+%D9%BE%D9%84%D8%AA%D9%81%D8%B1%D9%85+2+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C+%D9%86%D9%82%D8%AF.jpg');
                      }),
                  Positioned(
                      top: 0,
                      right: 0,
                      height: (MediaQuery.of(context).size.width * 0.05) + 50,
                      width: MediaQuery.sizeOf(context).width,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                // radius: 0.75,
                                // focal: Alignment.bottomLeft,
                                // tileMode: TileMode.clamp,
                                colors: [
                              // Colors.black.withOpacity(0.8), // شفافیت بیشتر
                              Colors.black
                                  .withOpacity(0.5), // شروع با شفافیت کامل
                              Colors.black.withOpacity(0.4), // شفافیت نصفه
                              Colors.black.withOpacity(0.2), // شفافیت نصفه
                              Colors.black.withOpacity(0.0), // شفافیت نصفه
                            ])),
                        // color: Colors.black,
                      )),
                  Positioned(
                      // top:
                      // bottom:
                      right: 0,
                      // wi/
                      left: MediaQuery.of(context).size.width * 0.1,
                      bottom: MediaQuery.of(context).size.height * 0.4,
                      top: MediaQuery.of(context).size.height * 0.13,
                      child: Container(
                        // width: double.infinity,
                        decoration: BoxDecoration(
                            // color: Colors.red,
                            gradient: RadialGradient(
                                center: Alignment.centerRight,
                                focal: Alignment.centerRight,
                                radius: 0.9,
                                colors: [
                              // Colors.black.withOpacity(0.8), // شفافیت بیشتر
                              Colors.black
                                  .withOpacity(0.6), // شروع با شفافیت کامل
                              Colors.black.withOpacity(0.3), // شفافیت نصفه
                              Colors.black.withOpacity(0.2), // شفافیت نصفه
                              Colors.black.withOpacity(0.0), // شفافیت نصفه
                            ])),
                        // color: Colors.black,
                      )),
                  SafeArea(
                    child:
                        GetBuilder<HomePageController>(builder: (controller) {
                      return NestedScrollView(
                        body: MovieListWidget(
                          scrollController: _scrollControllerItems,
                        ),
                        controller: _scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            // ),
                            SliverAppBar(
                              // toolbarHeight: toolbarHeoght,
                              backgroundColor: Colors.transparent,
                              // backgroundColor:
                              //     Theme.of(context).colorScheme.surface,
                              // floating: true,
                              automaticallyImplyLeading: false,

                              pinned: false,
                              toolbarHeight:
                                  MediaQuery.of(context).size.height * 0.58,
                              elevation: 15,
                              excludeHeaderSemantics: true,
                              primary: true,
                              snap: false,
                              floating: true,
                              // foregroundColor: Colors.,
                              // foregroundColor: Colors.red,
                              flexibleSpace: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(10),
                                  Row(
                                    children: [
                                      const Gap(40),
                                      Image.asset(
                                        'assets/images/icon.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      const Gap(40),
                                      indexingWidget(
                                          const MyText(
                                            txt: 'خانه',
                                            fontWeight: FontWeight.normal,
                                            size: 22,
                                          ),
                                          0.00),
                                      const Gap(30),
                                      indexingWidget(
                                          const MyText(
                                            txt: 'فیلم',
                                            fontWeight: FontWeight.normal,
                                            size: 22,
                                          ),
                                          0.01),
                                      const Gap(30),
                                      indexingWidget(
                                          const MyText(
                                            txt: 'سریال',
                                            fontWeight: FontWeight.normal,
                                            size: 22,
                                          ),
                                          0.02),
                                      const Gap(30),
                                      indexingWidget(
                                          const MyText(
                                            txt: 'کودک',
                                            fontWeight: FontWeight.normal,
                                            size: 22,
                                          ),
                                          0.03),
                                      const Spacer(),
                                      indexingWidget(
                                          GestureDetector(
                                              onTap: () {},
                                              child: const Icon(
                                                  Icons.search_rounded,
                                                  size: 30,
                                                  color: Colors.white)),
                                          0.04),
                                      // if ((GetStorageData.getData("logined") ??
                                      //     false))
                                      indexingWidget(
                                          GestureDetector(
                                            // autofocus: false,
                                            onTap: () async {
                                              if ((GetStorageData.getData(
                                                          "user_logined") ??
                                                      false) ==
                                                  false) {
                                                await Get.toNamed(
                                                    LoginScreen.routeName);
                                              } else {
                                                // if device is mobile open profile page else open drawer

                                                if (MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600) {
                                                  Get.to(() =>
                                                      const ProfileScreen());
                                                } else {
                                                  Scaffold.of(context)
                                                      .openDrawer();
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.pink,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Icon(
                                                  Iconsax.user_octagon4),
                                            ),
                                          ),
                                          0.05),
                                      const Gap(30),
                                    ],
                                  ),
                                  const Spacer(),
                                  GetBuilder<AndroidTVSliderController>(
                                      id: "slider",
                                      builder: (controller) {
                                        return Row(
                                          children: [
                                            const Gap(30),
                                            MyText(
                                              txt: androidTvSliderController
                                                      .sliderVideo.title ??
                                                  "",
                                              fontWeight: FontWeight.bold,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                          ],
                                        );
                                      }),
                                  GetBuilder<AndroidTVSliderController>(
                                      id: "slider",
                                      builder: (controller) {
                                        return Row(
                                          children: [
                                            const Gap(30),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.5),
                                              child: MyText(
                                                txt: androidTvSliderController
                                                        .sliderVideo.desc ??
                                                    "",
                                                fontWeight: FontWeight.bold,
                                                maxLine: 3,
                                                overflow: TextOverflow.ellipsis,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Gap(30),
                                      indexingWidget(
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            // height: 80,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                            child: const Row(
                                              children: [
                                                MyText(
                                                  txt: 'پخش',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  size: 24,
                                                ),
                                                Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: Color.fromARGB(
                                                      255, 19, 6, 6),
                                                  size: 32,
                                                )
                                              ],
                                            ),
                                          ),
                                          1.00),
                                      const Gap(20),
                                      indexingWidget(
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            // height: 80,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                            child: const Row(
                                              children: [
                                                MyText(
                                                  txt: 'جزییات بیشتر',
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  size: 24,
                                                ),
                                                Gap(10),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  // color: Colors.black,
                                                  size: 24,
                                                )
                                              ],
                                            ),
                                          ),
                                          1.01),
                                    ],
                                  ),
                                  const Gap(20),
                                  GetBuilder<AndroidTVSliderController>(
                                      id: "slider",
                                      builder: (controller) {
                                        if (controller.tryStopping == true) {
                                          return const SizedBox();
                                        }
                                        return Row(
                                          children: [
                                            const Gap(30),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: controller.val,
                                                    color: Colors.white,
                                                    backgroundColor: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999),
                                                    minHeight: 7,
                                                  ),
                                                )),
                                          ],
                                        );
                                      }),
                                  const Spacer(),
                                ],
                              ),
                            )
                            // SliverOverlapAbsorber(
                            //   handle:
                            //       NestedScrollView.sliverOverlapAbsorberHandleFor(
                            //           context),
                            // sliver: Container(),
                            // ),
                            /*
                              
                              */
                          ];
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  String formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  void dsds(value) async {
    if (androidTvSliderController.isUpdating) return;

    androidTvSliderController.isUpdating = true;

    if (value.logicalKey == LogicalKeyboardKey.arrowRight) {
      androidTvSliderController.itemIndex =
          androidTvSliderController.itemIndex - 0.01;
      androidTvSliderController.update();

      // return;
    } else if (value.logicalKey == LogicalKeyboardKey.arrowLeft) {
      androidTvSliderController.itemIndex =
          androidTvSliderController.itemIndex + 0.01;

      androidTvSliderController.update();
      // return;
    } else if (value.logicalKey == LogicalKeyboardKey.arrowDown) {
      androidTvSliderController.itemIndex =
          androidTvSliderController.itemIndex + 1.0;
      androidTvSliderController.itemIndex =
          double.parse(androidTvSliderController.itemIndex.toStringAsFixed(0));
    } else if (value.logicalKey == LogicalKeyboardKey.arrowUp) {
      androidTvSliderController.itemIndex =
          androidTvSliderController.itemIndex - 1.0;
      androidTvSliderController.itemIndex =
          double.parse(androidTvSliderController.itemIndex.toStringAsFixed(0));
    } else if (value.logicalKey == LogicalKeyboardKey.enter) {
      // print("select ${androidTvSliderController.itemIndex}");
      onClick(androidTvSliderController.itemIndex);
    }

    if (androidTvSliderController.itemIndex < 0) {
      androidTvSliderController.itemIndex = 0.0;
    }
    if (androidTvSliderController.itemIndex >=
        Get.find<HomePageController>()
                .homeCatagory!
                .data!
                .data!
                .length
                .toDouble() +
            2) {
      androidTvSliderController.itemIndex = Get.find<HomePageController>()
              .homeCatagory!
              .data!
              .data!
              .length
              .toDouble() +
          1;
    }

    androidTvSliderController.itemIndex =
        double.parse(androidTvSliderController.itemIndex.toStringAsFixed(2));

    androidTvSliderController.update();

    await Future.delayed(const Duration(milliseconds: 200));
    androidTvSliderController.isUpdating = false;

    String afterFloor =
        (androidTvSliderController.itemIndex.toString().split(".")[1]);

    if (afterFloor == "99") {
      androidTvSliderController.itemIndex = prevItemValue;
      ScrollController scrollController = homePageController
          .homeCatagory!
          .data!
          .data![androidTvSliderController.itemIndex.toInt() - 2]
          .scrollController;
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }

    if (androidTvSliderController.itemIndex >= 2) {
      if (androidTvSliderController.itemIndex >= 5) {
        _scrollControllerItems.animateTo(
            prevItemValue.toInt() < androidTvSliderController.itemIndex.toInt()
                ? _scrollControllerItems.offset +
                    (androidTvSliderController.itemIndex * 40)
                : prevItemValue.toInt() >
                        androidTvSliderController.itemIndex.toInt()
                    ? _scrollControllerItems.offset -
                        (androidTvSliderController.itemIndex * 35) +
                        40
                    : _scrollControllerItems.offset,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }
      if (androidTvSliderController.itemIndex <= 3) {
        _scrollControllerItems.animateTo(0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }

      _scrollController.animateTo(1000,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else if (androidTvSliderController.itemIndex <= 1) {
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

      _scrollControllerItems.animateTo(0.0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
    // print(androidTvSliderController.itemIndex);
    if (androidTvSliderController.itemIndex >= 2) {
      // String afterFloor =
      //     (androidTvSliderController.itemIndex.toString().split(".")[1]);

      // if (afterFloor == "99") {
      //   androidTvSliderController.itemIndex = prevItemValue;
      // ScrollController scrollController = homePageController
      //     .homeCatagory!
      //     .data!
      //     .data![androidTvSliderController.itemIndex.toInt() - 2]
      //     .scrollController;
      // scrollController.animateTo(0,
      //     duration: const Duration(milliseconds: 200),
      //     curve: Curves.easeInOut);
      // afterFloor = ((androidTvSliderController.itemIndex
      //     .toString()
      //     .split(".")[1]));
      // }
      // print(androidTvSliderController.itemIndex);
      // print(prevItemValue);
      // if (prevItemValue == 0.0 && afterFloor >= 0) {
      //   androidTvSliderController.itemIndex = prevItemValue;
      // }

      if (afterFloor != '0' && afterFloor != '99') {
        if (prevItemValue >= androidTvSliderController.itemIndex) {
          int index = int.parse(formatNumber(int.parse(androidTvSliderController
              .itemIndex
              .toStringAsFixed(2)
              .toString()
              .split(".")[1])));
          debugPrint(index.toString());

          ScrollController scrollController = homePageController
              .homeCatagory!
              .data!
              .data![androidTvSliderController.itemIndex.toInt() - 2]
              .scrollController;
          scrollController.animateTo(index * 150,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        }
        if (prevItemValue <= androidTvSliderController.itemIndex) {
          int index = int.parse(formatNumber(int.parse(androidTvSliderController
              .itemIndex
              .toStringAsFixed(2)
              .toString()
              .split(".")[1])));
          debugPrint(index.toString());

          ScrollController? scrollController = homePageController
              .homeCatagory!
              .data!
              .data?[androidTvSliderController.itemIndex.toInt() - 2]
              .scrollController;
          if (scrollController != null) {
            scrollController.animateTo(index * 150,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut);
          }
        }
      } else {
        ScrollController? scrollController = homePageController
            .homeCatagory!
            .data!
            .data?[androidTvSliderController.itemIndex.toInt() - 2]
            .scrollController;
        if (scrollController != null) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        }
      }
    }
    prevItemValue = androidTvSliderController.itemIndex;
  }
}

class MovieListWidget extends StatelessWidget {
  MovieListWidget({
    super.key,
    required this.scrollController,
  });
  final ScrollController scrollController;

  final controller = Get.find<HomePageController>();

  Widget indexingWidget(Widget widget, double index) {
    return GetBuilder<AndroidTVSliderController>(
      builder: (controller) {
        return Container(
          padding: index == controller.itemIndex
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
              : null,
          // width:  widget.toString().length * 10,
          decoration: BoxDecoration(
            color: index == controller.itemIndex ? Colors.black : null,
            border: index == controller.itemIndex
                ? Border.all(color: Colors.white, width: 2)
                : null,
            borderRadius: BorderRadius.circular(19),
          ),
          child: widget,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AndroidTVSliderController>(
        builder: (androidTvController) {
      return Container(
          // color: Colors.black45,
          decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 0.3),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  // Colors.black12,
                  Colors.black54,
                  Colors.black87,
                  // Colors.black45,
                  Colors.black,
                ],
              )),
          child: ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.homeCatagory!.data!.data!.length,
            controller: scrollController,
            // controller: ,
            itemBuilder: (context, index) {
              HomeCatagoryItemModel homeCatagoryItem =
                  controller.homeCatagory!.data!.data![index];

              if (homeCatagoryItem.viewName == "continue_watchin") {
                if (controller.historyList.isNotEmpty) {
                  return CountinuisWatching(homeCatagoryItem: homeCatagoryItem);
                } else {
                  return Container();
                }
              }

              return Container(
                // color: Colors.red,
                height: 280,
                padding: const EdgeInsets.all(10),
                // margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MyText(
                          txt: controller
                              .homeCatagory!.data!.data![index].title!,
                          fontWeight: FontWeight.bold,
                          size: 32,
                        ),
                      ],
                    ),
                    const Gap(10),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Get.find<HomePageController>()
                                  .homeCatagory
                                  ?.data!
                                  .data?[index]
                                  .data!
                                  .length ??
                              0,
                          controller: Get.find<HomePageController>()
                              .homeCatagory
                              ?.data!
                              .data?[index]
                              .scrollController,
                          itemBuilder: (context, indexxx) {
                            return indexingWidget(
                                Container(
                                  height: 180,
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    // border: _focusNodeActive.hasFocus
                                    //     ? Border.all(color: Colors.white, width: 2)
                                    //     : null,
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: SearchItem(
                                    item: SearchVideo.fromJson(
                                        Get.find<HomePageController>()
                                            .homeCatagory!
                                            .data!
                                            .data![index]
                                            .data![indexxx]
                                            .toJson()),
                                  ),
                                ),
                                double.parse((double.parse("${index + 2}") +
                                        convertToDecimal(indexxx))
                                    .toStringAsFixed(2)));
                          }),
                    ),
                  ],
                ),
              );
            },
          ));
    });
  }
}
