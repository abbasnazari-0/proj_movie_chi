import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/episod_converter.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/session_item.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';
import 'package:movie_chi/features/feature_video_player/presentation/controller/tv_video_player_controller.dart';

import '../../../feature_play_list/data/model/session_playlist.dart';
import '../../data/model/video_model.dart';
import '../controllers/detail_page_controller.dart';

class SessionItemGroupe extends StatelessWidget {
  const SessionItemGroupe({
    super.key,
    this.playListModel,
  });

  final SessionModel? playListModel;

  isUserPremium() {
    // if (GetStorageData.getData("user_status") != "premium") {
    //   return false;
    // }

    if (GetStorageData.getData("user_status") == "premium") {
      String timeOut = GetStorageData.getData("time_out_premium");
      DateTime expireTimeOut = (DateTime.parse(timeOut));
      DateTime now = (DateTime.now());

      if (expireTimeOut.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        debugPrint("false-1");
        return false;
      }
      debugPrint("true-1");
      return true;
    } else {
      debugPrint("false-2");
      return false;
    }
  }

  String formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      bool isPortrait = constraint.maxWidth < constraint.maxHeight;

      if (isPortrait) {
        return StatefulBuilder(builder: (context, setState) {
          return GetBuilder<DetailPageController>(
              id: "session",
              builder: (pageController) {
                return DefaultTabController(
                  initialIndex: 0,
                  length: pageController.playListModel?.data?.length ?? 0,
                  child: Column(
                    children: [
                      TabBar(
                          isScrollable: true,
                          onTap: (value) {
                            // sessionId = value;
                            pageController.chnageSessionData(value);
                          },
                          physics: const BouncingScrollPhysics(),
                          tabs: pageController.playListModel?.data
                                  ?.map((e) => Tab(text: e.title ?? ""))
                                  .toList() ??
                              []),
                      Stack(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pageController
                                .playListModel
                                ?.data?[pageController.sessionId]
                                .episoids
                                ?.length,
                            itemBuilder: (context, index) {
                              EpisoidsData episoid = pageController
                                  .playListModel!
                                  .data![pageController.sessionId]
                                  .episoids![index];
                              Video video = episoidToVideo(episoid,
                                  pageController.videoDetail ?? Video());

                              // LogPrint(video.toJson());
                              return SessionItem(
                                video: video,
                                index: index,
                              );
                            },
                          ),
                          if ((pageController.videoDetail?.videoType?.type ??
                                      VideoTypeEnum.free) !=
                                  VideoTypeEnum.free &&
                              isUserPremium() != true)
                            Container(
                              color: Colors.black.withOpacity(0.7),
                              width: double.infinity,
                              height: (pageController
                                              .playListModel
                                              ?.data?[pageController.sessionId]
                                              .episoids
                                              ?.length ??
                                          0) *
                                      70 +
                                  60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/lotties/premium.json",
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.40),
                                  const MyText(
                                    txt: "فیلم های اشتراکی",
                                    color: Colors.white,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const MyText(
                                    txt: "این فیلم برای کاربران ویژه میباشد",
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const Gap(30),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    child: MyButton(
                                      isFilledColor: false,
                                      color: Colors.amber,
                                      icon: Icons.workspace_premium,
                                      textColor: Colors.amber,
                                      onPressed: () async {
                                        await Constants.showGeneralSnackBar(
                                            "تهیه اشتراک ارزان با تخفیف",
                                            "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
                                        Future.delayed(
                                            const Duration(milliseconds: 1000),
                                            () async {
                                          await Get.to(
                                              () => const PlanScreen());

                                          setState(() {});
                                        });
                                      },
                                      text: 'دریافت اشتراک',
                                    ),
                                  ),
                                  const Gap(15),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        });
      } else {
        // is landscape
        // return SizedBox();

        return GetBuilder<TvVideoPlayerController>(
            id: "session",
            builder: (pageController) {
              return ListView.builder(
                itemCount: sessionCountWithEpisod(playListModel!),
                scrollDirection: Axis.horizontal,
                controller: pageController.scrollController,
                itemBuilder: (context, index) {
                  EpisoidsData episoid =
                      playListModel!.data![0].episoids![index];
                  Video video =
                      episoidToVideo(episoid, pageController.videoDetail);
                  return pageController.indexingWidget(
                      Container(
                        width: 300,
                        height: 200,
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: video.thumbnail1x ?? "",
                              fit: BoxFit.cover,
                              width: 200,
                              height: 100,
                            ),
                          ),
                          const Gap(10),
                          MyText(
                            txt: video.title ?? "",
                            size: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const Gap(10),
                        ]),
                      ),
                      double.parse("1.${formatNumber(index)}"));
                },
              );
            });
      }
    });
  }
  // shrinkWrap: true,

  int sessionCountWithEpisod(SessionModel sessionModel) {
    int count = 0;
    for (var element in sessionModel.data!) {
      for (int i = 0; i < element.episoids!.length; i++) {
        count++;
      }
    }
    return count;
  }

  // Reverse function to get the real item from a given index
  EpisoidsData getEpisoidFromIndex(SessionModel sessionModel, int index) {
    int count = 0;
    for (var element in sessionModel.data!) {
      for (int i = 0; i < element.episoids!.length; i++) {
        if (count == index) {
          return element.episoids![i];
        }
        count++;
      }
    }
    throw Exception("Index out of range");
  }
}
