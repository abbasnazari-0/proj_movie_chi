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

                      Video video = Video(
                        title: episoid.title,
                        tag: episoid.qualityId,
                        desc: pageController.videoDetail?.desc,
                        thumbnail1x: pageController.videoDetail?.thumbnail1x,
                        thumbnail2x: pageController.videoDetail?.thumbnail2x,
                        qualitiesId: episoid.qualityId,
                        galleryId: pageController.videoDetail?.galleryId,
                        quality1080: episoid.quality1080,
                        quality1440: episoid.quality1440,
                        quality2160: episoid.quality2160,
                        quality240: episoid.quality240,
                        quality360: episoid.quality360,
                        quality4320: episoid.quality4320,
                        quality480: episoid.quality480,
                        quality720: episoid.quality720,
                        view: pageController.videoDetail?.view,
                        userLiked: pageController.videoDetail?.userLiked,
                        userBookmarked:
                            pageController.videoDetail?.userBookmarked,
                        tagData: pageController.videoDetail?.tagData,
                        artistData: pageController.videoDetail?.artistData,
                        lastSessionTime:
                            pageController.videoDetail?.lastSessionTime,
                        type: pageController.videoDetail?.type,
                        commonTag: pageController.videoDetail?.commonTag,
                        subtitle: pageController.videoDetail?.subtitle,
                        dubble: pageController.videoDetail?.dubble,
                      );

                      // LogPrint(video.toJson());
                      return SessionItem(video: video);
                    },
                  ),
                ],
              ),
            );
          });
    });
  }
}
