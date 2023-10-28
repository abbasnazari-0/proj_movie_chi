import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/video_player_controller.dart';

import '../../../../core/utils/get_storage_data.dart';
import '../../../../core/widgets/mytext.dart';
import '../pages/feature_video_player.dart';

class SettingController {
  Widget qualityItem(String quality, context) {
    String videoQuality = "";
    // switch
    switch (quality) {
      case '240':
        videoQuality = pageVideoPlayerController.baseVideo!.quality240!;
        break;
      case '360':
        videoQuality = pageVideoPlayerController.baseVideo!.quality360!;
        break;
      case '480':
        videoQuality = pageVideoPlayerController.baseVideo!.quality480!;
        break;
      case '720':
        videoQuality = pageVideoPlayerController.baseVideo!.quality720!;
        break;
      case '1080':
        videoQuality = pageVideoPlayerController.baseVideo!.quality1080!;
        break;
      case '1440':
        videoQuality = pageVideoPlayerController.baseVideo!.quality1440!;
        break;
      case '2160':
        videoQuality = pageVideoPlayerController.baseVideo!.quality2160!;
        break;
      case '4320':
        videoQuality = pageVideoPlayerController.baseVideo!.quality4320!;
        break;
      default:
        getVideoUrl(pageVideoPlayerController.baseVideo!);
    }
    return InkWell(
      onTap: () {
        // pageVideoPlayerController.controller.setDataSource(
        //   DataSource(
        //     type: DataSourceType.network,
        //     source: videoQuality,
        //   ),
        //   autoplay: true,
        // );
        pageVideoPlayerController.videoUrl = videoQuality;
        pageVideoPlayerController.caption = pageVideoPlayerController.caption;
        pageVideoPlayerController.changeDataSource(true,
            pageVideoPlayerController.controller.position.value.inSeconds);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              height: 80,
              'assets/images/icon.png',
              cacheHeight: int.parse(quality) ~/ 6,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MyText(
                txt: quality,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final pageVideoPlayerController = Get.find<PageVideoPlayerController>();
  changeSubtitleTextSize(String size) {
    GetStorageData.writeData("subtitleTextSize", size);

    pageVideoPlayerController.controller.customCaptionView =
        (context, controller, responsive, string) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: string.isNotEmpty
              ? GetStorageData.getData("subtitleBackgroundColor_") ??
                  Colors.orange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: MyText(
          txt: string,
          color: GetStorageData.getData("subtitleColor_") ?? Colors.black,
          size: responsive.ip(
              double.parse(GetStorageData.getData("subtitleTextSize") ?? '2')),
          textAlign: TextAlign.center,
        ),
      );
    };
    pageVideoPlayerController.controller.onClosedCaptionEnabled(false);
    pageVideoPlayerController.controller.onClosedCaptionEnabled(true);
  }

  changeSubtitleBackgroundColor(String color) {
    GetStorageData.writeData("subtitleBackgroundColor", color);
    Color subtitleBackgroundColor =
        GetStorageData.getData("subtitleBackgroundColor") == "white"
            ? Colors.white
            : GetStorageData.getData("subtitleBackgroundColor") == "orange"
                ? Colors.orange
                : GetStorageData.getData("subtitleBackgroundColor") == "blue"
                    ? Colors.blue
                    : GetStorageData.getData("subtitleBackgroundColor") == "red"
                        ? Colors.red
                        : GetStorageData.getData("subtitleBackgroundColor") ==
                                "green"
                            ? Colors.green
                            : Colors.black;

    subtitleBackgroundColor = subtitleBackgroundColor.withAlpha(180);
    GetStorageData.writeData(
        "subtitleBackgroundColor_", subtitleBackgroundColor);
    pageVideoPlayerController.controller.customCaptionView =
        (context, controller, responsive, string) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: string.isNotEmpty
              ? GetStorageData.getData("subtitleBackgroundColor_") ??
                  Colors.orange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: MyText(
          txt: string,
          color: GetStorageData.getData("subtitleColor_") ?? Colors.black,
          size: responsive.ip(
              double.parse(GetStorageData.getData("subtitleTextSize") ?? '1')),
          textAlign: TextAlign.center,
        ),
      );
    };
    pageVideoPlayerController.controller.onClosedCaptionEnabled(false);
    pageVideoPlayerController.controller.onClosedCaptionEnabled(true);
  }

  changeSubtitleTextColor(String color) {
    GetStorageData.writeData("subtitleColor", color);
    Color subtitleColor = GetStorageData.getData("subtitleColor") == "white"
        ? Colors.white
        : GetStorageData.getData("subtitleColor") == "orange"
            ? Colors.orange
            : GetStorageData.getData("subtitleColor") == "blue"
                ? Colors.blue
                : GetStorageData.getData("subtitleColor") == "red"
                    ? Colors.red
                    : GetStorageData.getData("subtitleColor") == "green"
                        ? Colors.green
                        : Colors.black;

    GetStorageData.writeData("subtitleColor_", subtitleColor);

    pageVideoPlayerController.controller.customCaptionView =
        (context, controller, responsive, String? string) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: string?.isNotEmpty ?? false
              ? GetStorageData.getData("subtitleBackgroundColor_") ??
                  Colors.orange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: MyText(
          txt: string ?? "",
          color: GetStorageData.getData("subtitleColor_") ?? Colors.black,
          size: responsive.ip(
              double.parse(GetStorageData.getData("subtitleTextSize") ?? '2')),
          textAlign: TextAlign.center,
        ),
      );
    };
    pageVideoPlayerController.controller.onClosedCaptionEnabled(false);
    pageVideoPlayerController.controller.onClosedCaptionEnabled(true);
  }

  changeVideoQuality(context) {
    int currentTab = 0;
    // pause video
    pageVideoPlayerController.controller.pause();
    PageController pageController = PageController(initialPage: currentTab);

    String subtitleTextSize = GetStorageData.getData("subtitleTextSize") ?? '1';
    String subtitleColor = GetStorageData.getData("subtitleColor") ?? 'white';
    String subtitleBackgroundColor =
        GetStorageData.getData("subtitleBackgroundColor") ?? 'black';
    showDialog(
      context: context,
      builder: (context) => Center(
        child: StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DefaultTabController(
                  initialIndex: currentTab,
                  length: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      TabBar(
                          onTap: (index) {
                            setState(() {
                              currentTab = index;
                              pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            });
                          },
                          tabs: const [
                            Tab(
                              text: 'کیفیت ویدیو',
                              icon: Icon(Icons.video_settings_rounded),
                            ),
                            Tab(
                              text: 'تنظیمات زیر نویس',
                              icon: Icon(Icons.closed_caption_rounded),
                            ),
                          ]),
                      SizedBox(height: 10.h),
                      const Divider(
                        color: Colors.white,
                        height: 0.5,
                        endIndent: 40,
                        indent: 40,
                        thickness: 0.1,
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: PageView(
                          pageSnapping: false,
                          allowImplicitScrolling: true,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              currentTab = index;
                            });
                          },
                          controller: pageController,
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality240 !=
                                        null)
                                      qualityItem(240.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality360 !=
                                        null)
                                      qualityItem(360.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality480 !=
                                        null)
                                      qualityItem(480.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality720 !=
                                        null)
                                      qualityItem(720.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality1080 !=
                                        null)
                                      qualityItem(1080.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality1440 !=
                                        null)
                                      qualityItem(1440.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality2160 !=
                                        null)
                                      qualityItem(2160.toString(), context),
                                    if (pageVideoPlayerController
                                            .baseVideo?.quality4320 !=
                                        null)
                                      qualityItem(4320.toString(), context),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    // set subtitle delay time
                                    Row(
                                      children: [
                                        const Spacer(),
                                        // change background color
                                        const MyText(
                                          txt: "تاخیر در زیر نویس - معکوس",
                                          color: Colors.white,
                                        ),
                                        const Spacer(),

                                        // show text field to set delay time
                                        SizedBox(
                                          width: 100.w,
                                          child: TextField(
                                            onChanged: (value) {
                                              pageVideoPlayerController
                                                      .captionDelayTime =
                                                  int.parse(value);

                                              pageVideoPlayerController
                                                  .controller
                                                  .setCaptionOffset(Duration(
                                                      seconds:
                                                          int.parse(value)));
                                              pageVideoPlayerController
                                                  .controller
                                                  .onClosedCaptionEnabled(
                                                      false);
                                              pageVideoPlayerController
                                                  .controller
                                                  .onClosedCaptionEnabled(true);
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText:
                                                  pageVideoPlayerController
                                                      .captionDelayTime
                                                      .toString(),
                                              hintStyle: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        // change background color
                                        const MyText(
                                          txt: 'رنگ پس زمینه',
                                          color: Colors.white,
                                        ),
                                        const Spacer(),
                                        // show 6 color plate

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleBackgroundColor = "white";
                                              changeSubtitleBackgroundColor(
                                                  "white");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleBackgroundColor ==
                                                    "white"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleBackgroundColor =
                                                  "orange";
                                              changeSubtitleBackgroundColor(
                                                  "orange");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleBackgroundColor ==
                                                    "orange"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),

                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleBackgroundColor = "blue";
                                              changeSubtitleBackgroundColor(
                                                  "blue");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleBackgroundColor ==
                                                    "blue"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleBackgroundColor = "red";
                                              changeSubtitleBackgroundColor(
                                                  "red");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child:
                                                subtitleBackgroundColor == "red"
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.black,
                                                      )
                                                    : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleBackgroundColor = "green";
                                              changeSubtitleBackgroundColor(
                                                  "green");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleBackgroundColor ==
                                                    "green"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleBackgroundColor = "black";
                                              changeSubtitleBackgroundColor(
                                                  "black");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleBackgroundColor ==
                                                    "black"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        // change background color
                                        const MyText(
                                          txt: 'رنگ متن',
                                          color: Colors.white,
                                        ),
                                        const Spacer(),
                                        // show 6 color plate

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleColor = "white";
                                              changeSubtitleTextColor("white");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleColor == "white"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleColor = "orange";
                                              changeSubtitleTextColor("orange");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleColor == "orange"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),

                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleColor = "blue";
                                              changeSubtitleTextColor("blue");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleColor == "blue"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleColor = "red";
                                              changeSubtitleTextColor("red");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleColor == "red"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleColor = "green";
                                              changeSubtitleTextColor("green");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleColor == "green"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtitleColor = "black";
                                              changeSubtitleTextColor("black");
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: subtitleColor == "black"
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // change background color
                                        const MyText(
                                          txt: 'سایز متن',
                                          color: Colors.white,
                                        ),

                                        // show DropdownButton to select size
                                        DropdownButton<String>(
                                          value: subtitleTextSize,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.white,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              // dropdownValue = newValue!;
                                              subtitleTextSize = newValue!;
                                              changeSubtitleTextSize(newValue);
                                            });
                                          },
                                          items: <String>[
                                            '1',
                                            '2',
                                            '3',
                                            '4',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: MyText(
                                                txt: value,
                                                color: Colors.white,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
    // pageVideoPlayerController.controller.setDataSource(
    //   DataSource(
    //     type: DataSourceType.network,
    //     source: getVideoUrl(video.),
    //   ),
    //   autoplay: true,
    // );
  }
}
