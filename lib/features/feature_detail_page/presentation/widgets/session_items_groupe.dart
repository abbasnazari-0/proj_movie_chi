import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';

import 'package:movie_chi/core/widgets/my_button.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/session_item.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';

import '../../../feature_play_list/data/model/session_playlist.dart';
import '../../data/model/video_model.dart';
import '../controllers/detail_page_controller.dart';

class SessionItemGroupe extends StatelessWidget {
  const SessionItemGroupe({
    super.key,
    required this.pageController,
  });

  final DetailPageController pageController;

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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return GetBuilder<DetailPageController>(
          id: "session",
          builder: (controllller) {
            return DefaultTabController(
              initialIndex: 0,
              length: pageController.playListModel?.data?.length ?? 0,
              child: Column(
                children: [
                  TabBar(
                      isScrollable: true,
                      onTap: (value) {
                        // sessionId = value;
                        controllller.chnageSessionData(value);
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
                        itemCount: pageController.playListModel
                            ?.data?[controllller.sessionId].episoids?.length,
                        itemBuilder: (context, index) {
                          EpisoidsData episoid = pageController.playListModel!
                              .data![controllller.sessionId].episoids![index];
                          Video video = controllller.episoidToVideo(
                              episoid, pageController.videoDetail ?? Video());

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
                                          ?.data?[controllller.sessionId]
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
                                      MediaQuery.of(context).size.width * 0.40),
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
                                      await Get.to(() => const PlanScreen());

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
  }
}
