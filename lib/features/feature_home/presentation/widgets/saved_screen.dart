import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_home/presentation/controller/bookmark_screen_controller.dart';
import 'package:movie_chi/core/models/search_video_model.dart';
import 'package:movie_chi/locator.dart';

class SavedVideoScreen extends StatelessWidget {
  const SavedVideoScreen({
    Key? key,
    required this.page,
  }) : super(key: key);

  final String page;

  @override
  Widget build(BuildContext context) {
    Get.put(BookMarkScreenController(locator(), page));
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 30, right: 20),
          child: FloatingActionButton(
            onPressed: () {
              Get.back();
            },
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Icon(Iconsax.arrow_right_14,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
        // appBar: AppBar(
        //   title: const MyText(txt: 'ذخیره شده'),
        // ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: GetBuilder(builder: (BookMarkScreenController controller) {
          if (controller.pageStatus == PageStatus.loading) {
            return Center(
                child: LoadingAnimationWidget.flickr(
              leftDotColor: Theme.of(context).colorScheme.secondary,
              rightDotColor:
                  Theme.of(context).colorScheme.background.withAlpha(100),
              size: size.width * 0.1,
            ));
          }
          if (controller.pageStatus == PageStatus.success) {
            if (controller.bookMarkList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lotties/empty.json',
                        width: size.width * 0.4),
                    const Text('فیلم ذخیره شده ای ندارید'),
                  ],
                ),
              );
            }
            return SizedBox(
              width: size.width,
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                // separatorBuilder: (context, index) => const Divider(),
                itemCount: controller.bookMarkList.length,
                itemBuilder: (context, index) {
                  SearchVideo video = controller.bookMarkList[index];
                  return SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: Constants.imageFiller(video.thumbnail1x!),
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black.withAlpha(100),
                          httpHeaders: const {
                            'Referer': 'https://www.cinimo.ir/'
                          },
                          // handle error
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: size.height * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(180),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     // remove bookmark
                                        //     final detailCntroller = Get.put(
                                        //         DetailPageController(
                                        //             locator(), video.tag!));
                                        //     detailCntroller.videoBookMarked =
                                        //         true;
                                        //     bool result = await detailCntroller
                                        //         .submitBookmark();
                                        //     if (result == false) {
                                        //       controller.removeBookMark(index);
                                        //     }
                                        //     detailCntroller.dispose();

                                        //     // controller.(video);
                                        //   },
                                        //   icon: const Icon(Iconsax.save_minus4),
                                        // ),

                                        // imdb section
                                        if (video.imdb != null)
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: Row(
                                              children: [
                                                const MyText(
                                                  txt: "10/",
                                                  color: Colors.black87,
                                                ),
                                                MyText(
                                                  txt: "IMDB ${video.imdb}",
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(width: 10),
                                        // view section
                                        Row(
                                          children: [
                                            MyText(
                                                txt: video.view.toString(),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            Icon(Iconsax.eye,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ],
                                        ),
                                      ],
                                    ),
                                    MyText(
                                      txt: video.title!.replaceAll("فیلم", ''),
                                      color: Colors.white,
                                      size: 20,
                                      fontWeight: FontWeight.bold,
                                      maxLine: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    MyText(
                                      txt: video.desc!,
                                      color: Colors.white,
                                      size: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            width: 40,
                            height: 40,
                            left: Get.size.width / 2 - 20,
                            top: Get.size.height / 3 - 20,
                            child: IconButton(
                              onPressed: () {
                                // Get.to(() => DetailPage(
                                //       vid_tag: video.tag!,
                                //     ));
                                Constants.openVideoDetail(
                                    vidTag: video.tag!,
                                    type: video.type,
                                    commonTag: video.commonTag,
                                    picture: video.thumbnail1x!);
                              },
                              icon: Icon(Iconsax.export_3,
                                  size: 50,
                                  // accent color
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ))
                        // .colorScheme
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
