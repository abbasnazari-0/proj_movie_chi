import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/data/model/home_reels_model.dart';
import 'package:movie_chi/features/feature_home/presentation/widgets/reels_comment_input_box.dart';

import '../../../../core/widgets/mytext.dart';
import '../controller/home_page_controller.dart';

Future<dynamic> CommentBottomSheet(
    Size size, BuildContext context, ReelsModel reelsModel) {
  return Get.bottomSheet(
    GetBuilder<HomePageController>(
        id: 'reelsComment',
        builder: (controller) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: BackdropFilter(
                blendMode: BlendMode.srcOver,
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: size.height,
                  color: Colors.black.withAlpha(100),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                txt: 'دیدگاه ها',
                                fontWeight: FontWeight.bold,
                                size: 18,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: controller.reelCommentPageStatus ==
                                  PageStatus.loading
                              ? LoadingAnimationWidget.flickr(
                                  leftDotColor:
                                      Theme.of(context).colorScheme.secondary,
                                  rightDotColor: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withAlpha(100),
                                  size: size.width * 0.1,
                                )
                              : controller.reelCommentPageStatus ==
                                      PageStatus.empty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                              'assets/lotties/empty.json',
                                              height: size.width * 0.4,
                                              width: size.width * 0.4),
                                          const MyText(
                                              txt: "هنوز دیدگاهی ثبت نشده است"),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      controller: controller
                                          .commentListScrollController,
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          thickness: 1,
                                          color: Colors.grey.withOpacity(0.1),
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                            width: size.width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width * 0.1),
                                                  child: Container(
                                                    height: size.width * 0.1,
                                                    width: size.width * 0.1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    child: const Icon(
                                                        Iconsax.user),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    MyText(
                                                      txt: controller
                                                          .reelCommentData[
                                                              index]
                                                          .userTag!,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    MyText(
                                                      txt: controller
                                                          .reelCommentData[
                                                              index]
                                                          .comment!,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      },
                                      itemCount:
                                          controller.reelCommentData.length,
                                    ),
                        ),
                        const SizedBox(height: 10),

                        //  Comment input field
                        ReelUserInputComment(
                          size: size,
                          reelsModel: reelsModel,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
  );
}
