import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/data/model/home_reels_model.dart';
import 'package:movie_chi/features/feature_home/presentation/pages/screen_contents/reels_views/reels_widgets.dart';

import '../../controller/home_page_controller.dart';
import 'reels_views/reels_video_player.dart';

class ReelsScreemContent extends StatelessWidget {
  const ReelsScreemContent({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<HomePageController>(
        id: "reelsPage",
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Loading widget
              if (controller.reelsPageStatus == PageStatus.loading)
                LoadingAnimationWidget.flickr(
                  leftDotColor: Theme.of(context).colorScheme.secondary,
                  rightDotColor:
                      Theme.of(context).colorScheme.background.withAlpha(100),
                  size: size.width * 0.1,
                ),
              //
              PreloadPageView.builder(
                itemCount: controller.reelsData.length,
                scrollDirection: Axis.vertical,
                pageSnapping: true,
                preloadPagesCount: 2,
                controller:
                    PreloadPageController(initialPage: 0, keepPage: true),
                itemBuilder: (BuildContext context, int index) {
                  ReelsModel reelsModel = controller.reelsData[index];

                  return GestureDetector(
                    key: Key(Random.secure().nextInt(999999).toString()),
                    onDoubleTapDown: (s) {
                      controller.justLike(controller.reelsData, index);
                    },
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          VideoReelsPlayer(reelsModel),
                          // if (controller.showLikeinReels == true)
                          //   Center(
                          //     child: Lottie.asset(
                          //       'assets/lotties/67021-love-animation-with-particle.json',
                          //       height: size.height * 0.7,
                          //       width: size.width * 0.7,
                          //       repeat: false,
                          //     ),
                          //   ),
                          if (controller.isPlaying)
                            ReelsControllerWidgets(index: index),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
