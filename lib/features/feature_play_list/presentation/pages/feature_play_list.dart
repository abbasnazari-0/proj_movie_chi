import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:movie_chi/core/utils/constants.dart';
import 'package:movie_chi/core/widgets/mytext.dart';
import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/locator.dart';

import '../../../../core/models/search_video_model.dart';
import '../../../../core/utils/page_status.dart';
import '../../../feature_detail_page/presentation/widgets/detail_page_loading_view.dart';
import '../../../feature_search/presentation/widgets/custom_footer_refresh.dart';
import '../../../feature_search/presentation/widgets/search_screen_item.dart';
import '../controller/play_list_controller.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({
    Key? key,
    required this.homeCatagoryItemID,
    required this.type,
    this.title = "",
    this.backGroundImage = "",
  }) : super(key: key);
  final String homeCatagoryItemID;
  final String type;
  final String title;
  final String backGroundImage;
  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final controller = Get.put(PlayListController(locator()));
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    controller.playListModel = null;
    controller.playListId = widget.homeCatagoryItemID.toString();
    controller.type = widget.type;
    controller.keyWord = widget.title;

    controller.loadPlayListData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hieght = MediaQuery.of(context).size.height;
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
      body: GetBuilder<PlayListController>(
        builder: (controller) {
          if (controller.pageStatus == PageStatus.loading) {
            return DetailPageLoadingView(hieght: hieght, width: width);
          }
          if (controller.pageStatus == PageStatus.error) {
            return const Center(child: Text('Error'));
          }
          if (controller.pageStatus == PageStatus.empty) {
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/lotties/empty.json",
                      height: 200.h, width: 200.w),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: MyText(
                        txt: "خالی است!",
                        size: 14.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ],
              ),
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: widget.backGroundImage != "" ? 200.h : 60.h,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  centerTitle: true,
                  // show image in appbar
                  automaticallyImplyLeading: false,
                  flexibleSpace: widget.backGroundImage != ""
                      ? FlexibleSpaceBar(
                          title: Text(widget.title),
                          centerTitle: true,
                          background: CachedNetworkImage(
                            imageUrl:
                                Constants.imageFiller(widget.backGroundImage),
                            fit: BoxFit.cover,
                          ))
                      : null,
                  title: widget.backGroundImage == ""
                      ? MyText(
                          txt: widget.title,
                          size: 14.sp,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        )
                      : null,
                ),
              ];
            },
            body: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              controller: refreshController,
              footer: const RefreshCustomWidget(),
              onLoading: () async {
                await controller.loadPlayListData(withLoad: true);
                refreshController.loadComplete();
                // searchController.onstartLoadSearch(false,
                //     withChangePage: false, refreshController: refreshController);
              },
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.25,
                    crossAxisCount: 3),
                itemCount: controller.playListModel?.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  // SearchVideo item = controller.playListModel!.data![index];
                  Video itemVideo = controller.playListModel!.data![index];
                  // convert video model to search video model
                  SearchVideo item = SearchVideo(
                    id: itemVideo.id,
                    title: itemVideo.title,
                    imdb: itemVideo.imdb,
                    tag: itemVideo.tag,
                    desc: itemVideo.desc,
                    thumbnail1x: itemVideo.thumbnail1x,
                    view: itemVideo.view,
                    type: itemVideo.type,
                    commonTag: itemVideo.commonTag,
                    subtitle: itemVideo.subtitle,
                    dubble: itemVideo.dubble,
                  );

                  return SearchItem(item: item, chainrouter: false);
                  // return Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
