import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_new_notification/presentation/controllers/news_page_controller.dart';
import 'package:movie_chi/features/feature_new_notification/presentation/widget/news_header.dart';
import 'package:movie_chi/locator.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewsPage extends StatelessWidget {
  NewsPage({super.key});
  final supportController =
      Get.put(NewsPageController(supportUseCase: locator()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              NewsHeader(),
              GetBuilder<NewsPageController>(builder: (cont) {
                if (cont.pageStatus == PageStatus.loading) {
                  return LoadingAnimationWidget.flickr(
                    leftDotColor: Theme.of(context).colorScheme.secondary,
                    rightDotColor:
                        Theme.of(context).colorScheme.background.withAlpha(100),
                    size: MediaQuery.sizeOf(context).width * 0.1,
                  );
                }
                if (cont.pageStatus == PageStatus.error) {
                  return Center(
                      child: Column(
                    children: [
                      LottieBuilder.asset("assets/lotties/empty.json"),
                      MyText(
                        txt: "خطا ",
                        size: 24,
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      MyText(
                        txt: "مشکلی در ارتباط با سرور پیش آمده است",
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ));
                }
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: supportController.list.length,
                    itemBuilder: (context, index) {
                      Map itemData = cont.list[index];
                      return VisibilityDetector(
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            cont.readNotif(itemData['tag']);
                          }
                        },
                        key: Key(itemData['tag']),
                        child: InkWell(
                          onTap: () {
                            String action = (itemData['action']);
                            if (action == "web") {
                              Constants.urlLauncher(itemData['action_content']);
                            }
                            if (action == "video") {
                              Constants.openVideoDetail(
                                  vidTag: itemData['action_content'],
                                  picture: '');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  txt: itemData['title'],
                                  fontWeight: FontWeight.bold,
                                  size: 14,
                                ),
                                MyText(
                                  txt: itemData['desc'],
                                  fontWeight: FontWeight.w300,
                                  size: 11,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
