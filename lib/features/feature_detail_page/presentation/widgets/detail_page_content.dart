import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/play_section_section.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/session_items_groupe.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/photo_viewer_screen.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../core/widgets/share_item_circule.dart';
import '../../../feature_home/data/model/cinimo_config_model.dart';
import '../../../feature_home/presentation/widgets/home_drawer.dart';
import '../../data/model/video_model.dart';
import '../controllers/detail_page_controller.dart';
import '../controllers/download_page_controller.dart';
import '../pages/detial_widgets/dubble_o_subtitle.dart';
import '../pages/detial_widgets/header_action_button_groups.dart';
import '../pages/detial_widgets/imdb.dart';
import '../pages/detial_widgets/title_a_qualaties.dart';
import '../pages/detial_widgets/year_a_tags.dart';
import 'comment_section.dart';
import 'detail_suggestion_videos.dart';
import 'film_crew_section.dart';
import 'gallery_section_listview.dart';

// ignore: must_be_immutable
class DetailPageContent extends StatelessWidget {
  DetailPageContent({super.key, required this.deepLinking});
  final bool deepLinking;
  final pageController = Get.find<DetailPageController>();
  final controller = Get.find<DetailPageController>();
  final downloadController = Get.find<DownloadPageController>();

  CinimoConfig config = configDataGetter();
  checkUSers() async {
    bool canSeeVide = await pageController.isallowToPlay();

    if (canSeeVide) {
      //launch mx
      final downloadController = Get.find<DownloadPageController>();
      String qualityLink = await downloadController
          .checkQuality(pageController.videoDetail!, actionButton: "پخش");

      GetStorageData.writeData("logined", true);
      Constants.openVideoPlayer(
          pageController.video ?? pageController.videoDetail!,
          path: qualityLink,
          customLink: qualityLink);

      Get.close(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hieght = MediaQuery.of(context).size.height;
    int itemCount = pageController.galleryList.length > width ~/ 40
        ? width ~/ 60
        : pageController.galleryList.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            if (pageController.videoDetail?.thumbnail1x != null)
              GestureDetector(
                onTap: () {
                  Get.to(() => PhotoViewer(
                      photoUrl: Constants.imageFiller(
                          pageController.videoDetail!.thumbnail1x!)));
                },
                child: SizedBox(
                  height: hieght * 0.6,
                  width: width,
                  child: Hero(
                    tag: Constants.imageFiller(
                        pageController.videoDetail!.thumbnail1x!),
                    child: CachedNetworkImage(
                      imageUrl: Constants.imageFiller(
                        pageController.videoDetail!.thumbnail1x!,
                      ),
                      color: Colors.black.withOpacity(0.4),
                      colorBlendMode: BlendMode.darken,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            if (pageController.videoDetail?.type == "video")
              Positioned(
                left: MediaQuery.sizeOf(context).width * 0.5 - 40,
                top: hieght * 0.6 * 0.5 - 40,
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: PlayIcon(),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4.0),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           controller.submitLike();
        //         },
        //         icon: Icon(
        //           controller.videoLiked ? Iconsax.heart5 : Iconsax.heart4,
        //           color: controller.videoLiked
        //               ? Colors.red
        //               : Theme.of(context).colorScheme.onBackground,
        //         ),
        //       ),
        //       IconButton(
        //         onPressed: () {
        //           controller.submitBookmark();
        //         },
        //         icon: Icon(
        //           controller.videoBookMarked ? Iconsax.save_25 : Iconsax.save_2,
        //         ),
        //       ),
        //       IconButton(
        //         onPressed: () {
        //           Share.share("${pageController.videoDetail?.title} \n"
        //               'https://www.cinimo.ir/video/${pageController.videoDetail?.tag} '
        //               "  \n\n دانلود اپلیکیشن مووی چی! از لینک زیر \n https://www.cinimo.ir/");
        //         },
        //         icon: const Icon(Iconsax.share4),
        //       ),

        //       if (pageController.videoDetail?.type == "video" &&
        //           Constants.allowToShowAd())
        //         ElevatedButton.icon(
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: Theme.of(context).colorScheme.secondary,
        //               foregroundColor:
        //                   Theme.of(context).colorScheme.onSecondary,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(40 / 4),
        //               ),
        //             ),
        //             onPressed: () {
        //               final downloadController =
        //                   Get.find<DownloadPageController>();

        //               if (pageController.isDownloading) {
        //                 // should cancel download
        //                 if (pageController.videoDetail?.tag ==
        //                     downloadController.video?.tag) {
        //                   pageController.cancellTaskDownlod();
        //                   return;
        //                 }
        //               }

        //               downloadController.startNewDownload(
        //                   pageController.videoDetail!,
        //                   detailController: pageController);
        //             },
        //             icon: pageController.isVideoDownloaded
        //                 ? const Icon(
        //                     Iconsax.play,
        //                   )
        //                 : pageController.isDownloading == true &&
        //                         pageController.videoDetail?.tag ==
        //                             downloadController.video?.tag
        //                     ? const Icon(
        //                         Icons.close,
        //                       )
        //                     : const Icon(
        //                         Iconsax.arrow_down_24,
        //                       ),
        //             label: MyText(
        //               txt: pageController.isVideoDownloaded
        //                   ? 'پخش دانلود شده'
        //                   : pageController.isDownloading == true &&
        //                           pageController.videoDetail?.tag ==
        //                               downloadController.video?.tag
        //                       ? 'لغو دانلود'
        //                       : "دانلود نیم بها",
        //               color: Theme.of(context).colorScheme.onSecondary,
        //             )),

        //       // const Spacer(),
        //       // View Section
        //       const SizedBox(width: 20),
        //       if (pageController.videoDetail?.view != null &&
        //           (config.config?.viewShow ?? false) == true)
        //         Row(
        //           children: [
        //             MyText(
        //               txt: pageController.videoDetail!.view.toString(),
        //               fontWeight: FontWeight.bold,
        //             ),
        //             SizedBox(
        //               width: width * 0.01,
        //             ),
        //             Icon(
        //               Iconsax.eye,
        //               color: Theme.of(context).colorScheme.secondary,
        //               size: 15,
        //             ),
        //           ],
        //         ),
        //       const SizedBox(width: 10),

        //       // IMDB Section
        //       if (pageController.videoDetail?.imdb != null)
        //         Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //             color: Colors.orangeAccent,
        //           ),
        //           padding: const EdgeInsets.all(3),
        //           child: Row(
        //             children: [
        //               const MyText(
        //                 txt: "10/",
        //                 color: Colors.black87,
        //               ),
        //               MyText(
        //                 txt:
        //                     "IMDB ${double.parse(pageController.videoDetail!.imdb ?? '0').toStringAsFixed(1)}",
        //                 color: Colors.black87,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ],
        //           ),
        //         ),
        //       const SizedBox(width: 10),

        //       // Notif Section
        //       if (pageController.videoDetail?.status == "released")
        //         Container(
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(999),
        //               color: Colors.black,
        //             ),
        //             margin: const EdgeInsets.symmetric(
        //                 horizontal: 20, vertical: 10),
        //             child: MaterialButton(
        //               onPressed: () {},
        //               child: Row(
        //                 children: [
        //                   const SizedBox(
        //                     width: 20,
        //                   ),
        //                   const MyText(
        //                     txt: "اطلاع بده بهم",
        //                   ),
        //                   Icon(Icons.notification_add)
        //                 ],
        //               ),
        //             ))
        //     ],
        //   ),
        // ),
        SizedBox(height: 10.h),
        // Title Section
        SizedBox(height: 1.h),
        TitleAQualities(width: width, vid: controller.videoDetail ?? Video()),
        SizedBox(height: 5.h),

        YearATags(width: width, vid: controller.videoDetail ?? Video()),
        SizedBox(height: 5.h),

        ImdbSection(width: width, vid: controller.videoDetail ?? Video()),
        SizedBox(height: 20.h),
        HeaderActionButtonGroup(),

        // if (pageController.isDownloading &&
        //     downloadController.video?.tag == pageController.videoDetail?.tag)
        //   Column(
        //     children: [
        //       SizedBox(height: 10.h),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           MyText(
        //             txt: "در حال دانلود",
        //             textAlign: TextAlign.center,
        //             fontWeight: FontWeight.bold,
        //             size: 16.sp,
        //           ),
        //           const SizedBox(width: 10),
        //           MyText(
        //             txt: '${((pageController.prog?.toStringAsFixed(2) ?? 0))}%',
        //             textAlign: TextAlign.center,
        //           )
        //         ],
        //       ),
        //       SizedBox(height: 5.h),
        //       Row(
        //         children: [
        //           const SizedBox(
        //             width: 10,
        //           ),
        //           IconButton(
        //               onPressed: () {
        //                 pageController.cancellTaskDownlod();
        //               },
        //               icon: const Icon(Icons.close)),
        //           Expanded(
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 10),
        //               child: Directionality(
        //                   textDirection: TextDirection.ltr,
        //                   child: pageController.prog != null
        //                       ? LinearProgressIndicator(
        //                           backgroundColor:
        //                               Theme.of(context).colorScheme.onSecondary,
        //                           value: pageController.prog! / 100,
        //                           color:
        //                               Theme.of(context).colorScheme.secondary,
        //                         )
        //                       : LinearProgressIndicator(
        //                           backgroundColor:
        //                               Theme.of(context).colorScheme.onSecondary,
        //                           color:
        //                               Theme.of(context).colorScheme.secondary,
        //                         )),
        //             ),
        //           ),
        //           LoadingAnimationWidget.bouncingBall(
        //             color: Theme.of(context).colorScheme.secondary,
        //             size: 25,
        //           ),
        //           // IconButton(
        //           //     onPressed: () {
        //           //       pageController.pauseDownload();
        //           //     },
        //           //     icon: const Icon(Icons.pause)),
        //         ],
        //       ),
        //       const SizedBox(height: 5),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 15),
        //         child: Directionality(
        //           textDirection: TextDirection.ltr,
        //           child: Row(
        //             children: [
        //               MyText(
        //                 txt:
        //                     '${pageController.getFileSizeString(bytes: pageController.downloadedSize)} / ',
        //                 fontWeight: FontWeight.bold,
        //               ),
        //               MyText(
        //                 txt: pageController
        //                     .getFileSizeString(
        //                         bytes: pageController.fileSize.toDouble())
        //                     .toString(),
        //                 fontWeight: FontWeight.bold,
        //               ),
        //               const Spacer(),
        //               // MyText(
        //               //   txt: pageController.remaingTime,
        //               // )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(height: 20.h),
        //     ],
        //   ),
        // SizedBox(height: 10.h),

        // Desc Section
        if (pageController.videoDetail?.desc != null)
          StatefulBuilder(builder: (context, _) {
            final expanableController = ExpandableController();
            return ExpandablePanel(
              controller: expanableController,
              collapsed: InkWell(
                onTap: () {
                  expanableController.toggle();
                },
                child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: MyText(
                              txt: "جزییات فیلم",
                              // color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              size: 16.sp,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: MyText(
                              txt: pageController.videoDetail!.desc
                                  .toString()
                                  .replaceAll("\n", "\t"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              // length: 20,
                              maxLine: 2,
                              size: 13.sp,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: MyText(
                              txt: "ادامه جزییات فیلم",
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              expanded: InkWell(
                onTap: () {
                  expanableController.toggle();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: MyText(
                    txt: pageController.videoDetail!.desc!,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            );
          }),
        const SizedBox(height: 10),
        // add dubble
        if ((pageController.videoDetail?.dubble ?? "0") == "1" ||
            (pageController.videoDetail?.subtitle ?? "0") == "1")
          DubbleOSubtitle(pageController: pageController),

        // Film Crew Section
        // const SizedBox(height: 10),
        if (pageController.videoDetail?.artistData != null &&
            pageController.videoDetail!.artistData!.isNotEmpty)
          FilmCrewSection(pageController: pageController),

        // Photo Gallery
        if (pageController.galleryList.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: MyText(
              txt: "گالری عکس",
              fontWeight: FontWeight.bold,
            ),
          ),

        const SizedBox(height: 10),

        // Photo Gallery
        if (pageController.galleryList.isNotEmpty)
          GallerySectionListView(
              width: width,
              itemCount: itemCount,
              pageController: pageController),
        if (pageController.videoDetail?.type == "video")
          MaterialButton(
            onPressed: () {
              if ((GetStorageData.getData("logined") ?? false)) {
                downloadController.startNewDownload(pageController.videoDetail!,
                    detailController: pageController);
              } else {
                checkUSers();
                showSubscribtion();
              }
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40 / 4),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.onSecondary,
                    Theme.of(context).colorScheme.secondary.withAlpha(50),
                  ],
                  end: Alignment.topLeft,
                  begin: Alignment.bottomRight,
                ),
              ),
              width: width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    txt: pageController.isVideoDownloaded
                        ? 'پخش دانلود شده'
                        : pageController.isDownloading == true &&
                                pageController.videoDetail?.tag ==
                                    downloadController.video?.tag
                            ? 'لغو دانلود'
                            : "دانلود  فیلم",
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  pageController.isVideoDownloaded
                      ? const Icon(
                          Iconsax.play,
                        )
                      : pageController.isDownloading == true &&
                              pageController.videoDetail?.tag ==
                                  downloadController.video?.tag
                          ? const Icon(
                              Icons.close,
                            )
                          : const Icon(
                              Icons.download,
                            ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        // Play Section
        if (pageController.videoDetail?.thumbnail1x != null ||
            pageController.videoDetail?.thumbnail2x != null)
          if (pageController.videoDetail?.type == "video")
            PlaySectionDetailPage(width: width, pageController: pageController),

        if (pageController.videoDetail?.type != "video")
          pageController.serialStatus == PageStatus.loading
              ? Center(
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: Theme.of(context).colorScheme.secondary,
                    rightDotColor:
                        Theme.of(context).colorScheme.background.withAlpha(100),
                    size: width * 0.1,
                  ),
                )
              : pageController.serialStatus == PageStatus.error
                  ? const Center(child: Text('Error'))
                  : SessionItemGroupe(pageController: pageController),

        const SizedBox(height: 10),

        // Share Section
        GestureDetector(
          onTap: () {
            Share.share("${pageController.videoDetail?.title} \n"
                'https://www.cinimo.ir/video/${pageController.videoDetail?.tag} '
                "  \n\n دانلود اپلیکیشن مووی چی! از لینک زیر \n https://www.cinimo.ir/");
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                const MyText(
                  txt: "اشتراک گذاری در",
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                ShareItemCirecule(
                    messangerName: "90760-whatsapp-icon", onTap: () {}),
                const ShareItemCirecule(messangerName: "91510-instagram"),
                const ShareItemCirecule(messangerName: "69034-facebook"),
                const ShareItemCirecule(messangerName: "44061-telegram"),
                const ShareItemCirecule(messangerName: "99229-linkedin"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Suggest Video by Tags

        if (pageController.showSuggestionView &&
            pageController.suggestionList.isNotEmpty)
          SuggestionVideos(pageController: pageController, width: width),

        // Comment Section
        // if (pageController.commentList.isNotEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: MyText(
            txt: "نظرات کاربران",
            fontWeight: FontWeight.bold,
          ),
        ),

        Builder(builder: (cont) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40 / 4),
              // color: Theme.of(context).primaryColor,
            ),
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: controller.userCommentController,
                    decoration: const InputDecoration(
                      hintText: 'نظر خود را بنویسید',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onSubmitted: (value) {
                      controller.submitComment();
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.submitComment();
                  },
                  icon: controller.commentStatus == PageStatus.loading
                      ? const CircularProgressIndicator()
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          );
        }),

        Divider(
          color: Theme.of(context).colorScheme.secondary,
        ),

        const SizedBox(height: 10),
        // Comment Section
        if (pageController.commentList.isNotEmpty)
          VisibilityDetector(
            key: const Key("unique key"),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.5) {
                pageController.onCommentTap(true);
              } else {
                pageController.onCommentTap(false);
              }
            },
            child: CommentSection(pageController: pageController, width: width),
          ),

        if (pageController.showCommentInput)
          const SizedBox(
            height: 50.0,
          ),

        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  showSubscribtion() {
    Get.defaultDialog(
        title: "اشتراک ویژه",
        content: Column(
          children: [
            MyText(
              txt: "برای دیدن این ویدیو باید اشتراک ویژه داشته باشید",
              color: Get.theme.textTheme.bodyLarge!.color,
              size: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      launchUrl(Uri.parse("https://cinimo.ir"),
                          mode: LaunchMode.externalApplication);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.colorScheme.secondary,
                    ),
                    child: const MyText(
                      txt: "سایت سینیمو",
                      size: 16,
                    )),
                ElevatedButton(
                    onPressed: () {
                      // open url in external browser
                      launchUrl(
                          Uri.parse(
                            "https://payment.cinimo.ir/user/login",
                          ),
                          mode: LaunchMode.externalApplication);
                    },
                    child: MyText(
                      txt: "خرید اشتراک",
                      color: Get.theme.colorScheme.secondary,
                      size: 16,
                    )),
              ],
            )
          ],
        ));
  }
}
