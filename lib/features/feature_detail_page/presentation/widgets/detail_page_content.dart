import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_chi/core/utils/get_storage_data.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/comment_section.dart';
import 'package:movie_chi/features/feature_login_screen/presentations/screens/feature_login_screen.dart';
import 'package:movie_chi/features/feature_plans/presentation/screens/plan_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/play_section_section.dart';
import 'package:movie_chi/features/feature_detail_page/presentation/widgets/session_items_groupe.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/photo_viewer_screen.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../../core/widgets/share_item_circule.dart';
import '../../../feature_home/data/model/cinimo_config_model.dart';
import '../../../feature_home/presentation/widgets/home_drawer.dart';
import '../../data/model/video_model.dart';
import '../controllers/detail_page_controller.dart';
import '../controllers/download_page_controller.dart';
import '../pages/detial_widgets/header_action_button_groups.dart';
import '../pages/detial_widgets/imdb.dart';
import '../pages/detial_widgets/title_a_qualaties.dart';
import '../pages/detial_widgets/year_a_tags.dart';
import 'detail_suggestion_videos.dart';
import 'film_crew_section.dart';
import 'gallery_section_listview.dart';

// ignore: must_be_immutable
class DetailPageContent extends StatelessWidget {
  DetailPageContent({super.key, required this.deepLinking, this.heroTag});
  final bool deepLinking;
  final String? heroTag;
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

  String cleanText(String text) {
    List<String> lines = text.split('\n');
    lines.removeWhere((line) => line.trim().isEmpty);
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hieght = MediaQuery.of(context).size.height;
    int itemCount = pageController.galleryList.length > width ~/ 40
        ? width ~/ 60
        : pageController.galleryList.length;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (pageController.videoDetail?.thumbnail1x != null)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(PhotoViewer.routeName, arguments: {
                        "heroTag": heroTag ?? pageController.videoDetail!.tag!,
                        "photoUrl": Constants.imageFiller(
                            pageController.videoDetail!.thumbnail1x!)
                      });
                    },
                    child: Hero(
                      tag: heroTag ?? pageController.videoDetail!.tag!,
                      child: SizedBox(
                        height: hieght * 0.6,
                        width: width,
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

            const Gap(10),
            // Title Section
            const Gap(1),
            TitleAQualities(
                width: width, vid: controller.videoDetail ?? Video()),
            const Gap(5),

            YearATags(width: width, vid: controller.videoDetail ?? Video()),
            const Gap(10),
            const Divider(
              color: Colors.white10,
            ),
            const Gap(10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ImdbSection(
                      width: width, vid: controller.videoDetail ?? Video()),
                  const Gap(10),
                  if ((pageController.videoDetail?.dubble ?? "0") == "1")
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Iconsax.microphone,
                          color: Colors.amber,
                        ),
                        MyText(txt: "دوبله فارسی", color: Colors.amber)
                      ],
                    ),
                  const Gap(10),
                  if ((pageController.videoDetail?.subtitle ?? "0") == "1")
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Iconsax.subtitle),
                        MyText(
                          txt: "زیرنویس فارسی",
                          color: Colors.white,
                        )
                      ],
                    )
                ],
              ),
            ),
            const Gap(20),
            HeaderActionButtonGroup(),

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
                        // height: 140,
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: MyText(
                                  txt: "جزییات فیلم",
                                  // color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                  size: 16,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: MyText(
                                  txt: cleanText(
                                      pageController.videoDetail!.desc ?? ""),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  // length: 20,
                                  maxLine: 2,
                                  size: 13,
                                ),
                              ),
                              // const Spacer(),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: MyText(
                                  txt: "ادامه جزییات فیلم",
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                onPressed: () {
                                  expanableController.toggle();
                                },
                                icon: const Icon(Icons.close))),
                        SelectableText(
                          (cleanText(pageController.videoDetail?.desc ?? "")),
                          textAlign: TextAlign.right,

                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 14,
                          ),
                          // change color of thumb and selection
                          // selectionControls: TextSelectionControls ,
                        )
                        // MyText(
                        //   txt:,
                        //   textAlign: TextAlign.right,
                        // ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 10),
            // add dubble

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
            if ((GetStorageData.getData("logined") ?? false))
              if (pageController.videoDetail?.type == "video")
                InkWell(
                  onTap: () async {
                    if ((GetStorageData.getData("logined") ?? false) == false) {
                      if ((GetStorageData.getData("user_logined") ?? false) ==
                          false) {
                        Get.to(() => LoginScreen());
                        return;
                      } else {
                        if (GetStorageData.getData("user_status") ==
                            "premium") {
                          String timeOut =
                              GetStorageData.getData("time_out_premium");
                          DateTime expireTimeOut = (DateTime.parse(timeOut));
                          DateTime now = (DateTime.now());

                          if (expireTimeOut.millisecondsSinceEpoch <
                              now.millisecondsSinceEpoch) {
                            await Constants.showGeneralSnackBar(
                                "خطا", "اشتراک شما به پایان رسیده است");
                            Future.delayed(const Duration(milliseconds: 1000),
                                () async {
                              await Get.to(() => const PlanScreen());
                            });
                            return;
                          }
                        } else {
                          await Constants.showGeneralSnackBar(
                              "تهیه اشتراک ارزان با تخفیف",
                              "لطفا اشتراک ارزان تهیه کنید تا بتوانید از ما حمایت کنید");
                          Future.delayed(const Duration(milliseconds: 1000),
                              () async {
                            await Get.to(() => const PlanScreen());
                          });
                          return;
                        }
                      }
                    }
                    downloadController.startNewDownload(
                        pageController.videoDetail!,
                        detailController: pageController);

                    // if ((GetStorageData.getData("logined") ?? false)) {
                    // } else {
                    //   checkUSers();
                    //   showSubscribtion();
                    // }
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50 / 4),
                        color: Theme.of(context).primaryColor),
                    width: width,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyText(
                          txt: "دانلود  فیلم",
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

            const Gap(10),

            // Play Section
            // if (pageController.videoDetail?.thumbnail1x != null ||
            //     pageController.videoDetail?.thumbnail2x != null)
            if (pageController.videoDetail?.type == "video")
              PlaySectionDetailPage(
                  width: width, pageController: pageController),

            if (pageController.videoDetail?.type != "video")
              pageController.serialStatus == PageStatus.loading
                  ? Center(
                      child: LoadingAnimationWidget.flickr(
                        leftDotColor: Theme.of(context).colorScheme.secondary,
                        rightDotColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(100),
                        size: width * 0.1,
                      ),
                    )
                  : pageController.serialStatus == PageStatus.error
                      ? const Center(child: Text('Error'))
                      : SessionItemGroupe(pageController: pageController),

            const SizedBox(height: 10),

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
            if ((GetStorageData.getData("logined") ?? false))
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

            const Gap(10),
            // // Comment Section
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
                child: CommentSection(
                    pageController: pageController, width: width),
              ),

            if (pageController.showCommentInput)
              const SizedBox(
                height: 50.0,
              ),

            const SizedBox(
              height: 10.0,
            )
          ],
        ),
        if (controller.videoDetail!.trailerSources!.isNotEmpty)
          Positioned(
            top: hieght * 0.6 - 20,
            left: 10,
            child: TextButton.icon(
                onPressed: () {
                  if (controller.videoDetail!.trailerSources!.length > 1) {
                    Get.defaultDialog(
                        title: "تیزر ها",
                        content: Column(
                          children: controller.videoDetail!.trailerSources!
                              .map((trailerSource) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ListTile(
                                      title: MyText(
                                          txt:
                                              "تیزر ${trailerSource.id} - ${trailerSource.title ?? ''}"),
                                      onTap: () {
                                        Constants.openVideoPlayer(
                                            controller.videoDetail!,
                                            customLink: trailerSource.path,
                                            additionTitle:
                                                "تیزر ${trailerSource.id} - ${trailerSource.title ?? ''}");
                                      },
                                    ),
                                  ))
                              .toList(),
                        ));
                    return;
                  }
                  TrailerSources trailerSources =
                      controller.videoDetail!.trailerSources![0];
                  Constants.openVideoPlayer(
                    controller.videoDetail!,
                    customLink: trailerSources.path,
                    additionTitle: "تیزر",
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                icon: const Icon(Icons.play_circle_fill_rounded),
                label: const MyText(
                  txt: "نمایش تیزر",
                )),
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
                      txt: "سایت مووی چی",
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
