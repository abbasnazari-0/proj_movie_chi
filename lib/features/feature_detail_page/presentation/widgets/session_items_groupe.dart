import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/session_item.dart';

import '../../../feature_play_list/data/model/session_playlist.dart';
import '../../data/model/video_model.dart';
import '../controllers/detail_page_controller.dart';

class SessionItemGroupe extends StatelessWidget {
  const SessionItemGroupe({
    super.key,
    required this.pageController,
  });

  final DetailPageController pageController;

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
                ],
              ),
            );
          });
    });
  }
}
