import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_home/data/model/home_catagory_model.dart';

import 'package:movie_chi/features/feature_zhanner/data/model/zhanner_data_model.dart';
import 'package:movie_chi/features/feature_zhanner/presentation/controllers/zhanner_detail_controller.dart';
import 'package:movie_chi/locator.dart';

import '../../../../core/models/search_video_model.dart';
import '../../../../core/widgets/mytext.dart';
import '../../../feature_search/presentation/widgets/search_screen_item.dart';

class ZhannerDetail extends StatelessWidget {
  ZhannerDetail({
    Key? key,
  }) : super(key: key);

  final Zhanner zhanner = Get.arguments[0] as Zhanner;
  final String heroID = Get.arguments[1] as String;
  static String routeName = '/zhannerDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
      body: GetBuilder<ZhannerDetailController>(
          init: ZhannerDetailController(locator(), zhanner.tag!),
          builder: (controller) {
            return NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    // toolbarHeight: toolbarHeoght,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    // floating: true,
                    automaticallyImplyLeading: false,
                    // titleSpacing: 10,
                    // pinned: true,
                    // toolbarHeight: 100,
                    // collapsedHeight: 50,
                    // excludeHeaderSemantics: true,

                    flexibleSpace: Material(
                      child: Hero(
                        tag: heroID,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                zhanner.pics ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                    stops: const [0.0, 0.5],
                                    tileMode: TileMode.clamp,
                                    transform: const GradientRotation(1),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 60),
                                  child: MyText(
                                    txt: zhanner.tag!,
                                    color: Colors.white,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    maxLine: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // stretch: true,
                    expandedHeight: 220,
                  )
                ];
              },
              body: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 5,
                ),
                child: controller.pageStatus == PageStatus.error
                    ? const Center(child: Text('Error'))
                    : controller.pageStatus == PageStatus.empty
                        ? Container()
                        : controller.pageStatus == PageStatus.loading
                            ? LoadingAnimationWidget.flickr(
                                leftDotColor:
                                    Theme.of(context).colorScheme.secondary,
                                rightDotColor: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .withAlpha(100),
                                size: 30,
                              )
                            : SmartRefresher(
                                controller: RefreshController(),
                                enablePullDown: false,
                                enablePullUp: true,
                                onLoading: () {
                                  controller.getZhannerDataList(zhanner.tag!);
                                },
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1,
                                  ),
                                  itemCount: controller.zhannerDataList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    HomeItemData item =
                                        controller.zhannerDataList[index];
                                    // convert homeItemData to SearchVideo
                                    SearchVideo video =
                                        SearchVideo.fromJson(item.toJson());

                                    return SearchItem(
                                        item: video, chainrouter: true);
                                  },
                                ),
                              ),
              ),
            );
          }),
    );
  }
}
